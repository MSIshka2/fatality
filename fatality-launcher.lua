script_version '1.0.3'

require('lib.moonloader')
local imgui = require 'mimgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local cp = encoding.CP1251
local function recode(u8) return encoding.UTF8:decode(u8) end
local new = imgui.new
local dlstatus = require "moonloader".download_status
local sampev = require 'samp.events'


function update()
    local updatePath = os.getenv('TEMP')..'\\Update.json'
    sampAddChatMessage((u8:decode('[Update]: Поиск обновления')), 0xFFFFFF)
    downloadUrlToFile("https://raw.githubusercontent.com/MSIshka2/fatality/refs/heads/main/fatality.json", updatePath, function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            local file = io.open(updatePath, 'r')
            if file and doesFileExist(updatePath) then
                local info = decodeJson(file:read("*a"))
                file:close(); os.remove(updatePath)
                if info.version ~= thisScript().version then
                    lua_thread.create(function()
                        wait(2000)
                        sampAddChatMessage((u8:decode('[Update]: Идёт обновление')), 0xFFFFFF)
                        downloadUrlToFile("https://raw.githubusercontent.com/MSIshka2/fatality/refs/heads/main/fatality-launcher.lua", thisScript().path, function(id, status, p1, p2)
                            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                                sampAddChatMessage((u8:decode('[Update]: Обновление установлено')), 0xFFFFFF)
                                thisScript():reload()
                            end
                        end)
                    end)
                else
                    sampAddChatMessage((u8:decode('[Update]: У вас и так последняя версия! Обновление отменено')), 0xFFFFFF)
                end
            end
        end
    end)
end


local WinState = new.bool()
local fileContent = ''
local fileContent2 = ''
local fileContent3 = ''
local fileContent4 = ''
local inputField = new.char[256]()
local inputField2 = new.char[256]()
local messages = {}
local act = true
local checkboxone = new.bool()
local checkx = imgui.new.float(500)
local checky = imgui.new.float(150)
local carbuffer = new.char[256]()
local skinbuffer = new.char[256]()
local searchResults = {}
local showSearchWindow = imgui.new.bool()
local selectedText = ""
local isSelecting = false
local startIdx, endIdx = nil, nil
local favoritesVehicles = {}
local favoritesSkins = {}
local inputa1 = new.char[256]()
local inputa2 = new.char[256]()
local Font = renderCreateFont('Arial', 15, 0)
local activation = new.bool()
local aclLevel = 3
local password = new.char[256]()
local enterpassword = "1111"
local dostup = new.bool()

local commands1 = {
    "/atops - Рейтинг основателей",
    "/zpanel - Панель админа(все функции доступны)",
    "/ripmans - Список игроков в RIP",
    "/rconsay - RCON чат",
    "/offgivedonate - Выдать донат очки оффлайн",
    "/offalvladmin - Выдать админку оффлайн",
    "/caseon - Вкл кейсы/подарки",
    "/caseoff - Выкл кейсы/подарки",
    "/ratingon - Вкл рейтинги",
    "/ratingoff - Выкл рейтинги",
    "/ablow - Покупка салюта",
    "/agiverub - Выдача рублей",
    "/mpwin - Огласить победителя",
    "/tps - Новое телепорт-меню",
    "/apanel - Панель основателя",
    "/dostup - Выдать fd1",
    "/undostup - Снять fd1",
    "/glava - Выдать 16 lvl",
    "/unglava - Снять 16 lvl",
    "/delvipcase - Удалить кейс",
    "/givecmd - Выдача команд",
    "/setminigun - Разрешение на миниган",
    "/farmer - Поставить ограничение",
    "/unfarmer - Снять ограничение",
    "/akkreset - Аннулировать все донат очки",
    "/unbanall - Разбанить всех игроков",
    "/unconpens - Разрешить повторный ввод компенсации и промокодов"
}
local commands2 = {
    "/antierror - Снять ошибку безопасности",
    "/offawarn - Выдать оффлайн выговор",
    "/podarok - Открыть НГ подарок",
    "/aban - Бан навсегда",
    "/offleader - Убрать лидера",
    "/amute - Админ-затычка",
    "/look - Вид от 1 лица (в ТС)",
    "/neon - Неон на домашний ТС",
    "/jetpack - Получить ранец",
    "/ahostname - Изменить название сервера",
    "/apassword - Изменить пароль сервера",
    "/ops - Режим тех. работ",
    "/asban - Тихий бан навсегда",
    "/iban - Бан навсегда 2",
    "/sban - Тихий бан",
    "/offgiverub - Выдача рублей оффлайн",
    "/offgivestars - Выдача баллов оффлайн",
    "/onprom - Разрешить ввод промокодов",
    "/offleaders - Оффлайн лидеры",
    "/geton - Последний заход игрока",
    "/cuff - Надеть наручники",
    "/aclub - Все пункты доступны",
    "/setquest - Управление квестом у игрока",
    "/aquest - Вкл/выкл квест у игрока",
    "/clubload - Загрузка клубов",
    "/atext - Сделать важное объявление",
    "/title - Выдача титулов",
    "/giveclist - Выдать радужный клист",
    "/giveguns - Выдать набор цветов на оружия",
    "/givepay - Выдать команды /rpay /dpay",
    "/givedice - Выдать команды /rdice /ddice",
    "/holkinacc - Удалить аккаунт",
    "/getakk - Посмотреть пароль игрока",
    "/osnova - Выдача основателя",
    "/unosnova - Снятие основателя",
}
local commands3 = {
    "/setpass - Сменить пароль игрока",
    "/atp - Принудительно телепортировать всех к себе",
    "/aconnect - Видеть чат, смс, ввод комманд",
    "/ajoin - Вкл/выкл /mp /givegun /agivegun /sethp /asethp /slap",
    "/amenu - Панель статистики",
    "/atitle - Проверить титул у игрока",
    "/ahack - Отнять деньги, деньги в банке, дом, бизнес, азс",
    "/people - Показать топ по разным типам",
    "/block - Заблокировать/разблокировать ввод prefix, quest, dpanel, donate",
    "/createprom - Создание промокодов",
    "/rinfo - Проверить местоположение игрока",
    "/giveitems - Выдать особые объекты",
    "/givevip - Выдача VIP",
    "/setarm - Изменение брони игрока",
    "/setcarhp - Изменение здоровья ТС игрока",
    "/settime - Изменение времени сервера",
    "/setweather - Изменение погоды сервера",
    "/fatality - Новые аксессуары"
}

function sampev.onServerMessage(color, text)
    if act then
        local playerid2 = select(2,sampGetPlayerIdByCharHandle(PLAYER_PED))
        local name = sampGetPlayerNickname(playerid2)
        if text:find("<%s*.-%s*" .. name ) then
            table.insert(messages, u8(text))
        end
    end
end

local function readFile(filename)
    local file = io.open(filename, 'r')
    if file then
        fileContent = file:read('*all')
        file:close()
    else
        fileContent = 'Error open file.'
    end
end

local function readFile2(filename2)
    local file = io.open(filename2, 'r')
    if file then
        fileContent2 = file:read('*all')
        file:close()
    else
        fileContent2 = 'Error open file.'
    end
end

local function writeToFile(filename, data)
    local file = io.open(filename, 'a')
    if file then
        for _, entry in ipairs(data) do
            file:write(entry .. "\n")
        end
        file:close()
    end
end

local function readFile3()
    local vehicleFile = getGameDirectory() .. "\\moonloader\\fatality\\favoritescar.txt"
        local file = io.open(vehicleFile, 'r')
        if file then
            fileContent3 = file:read('*all')
            file:close()
        else
            fileContent3 = 'Error open file.'
        end
end
local function readFile4()
    local skinFile = getGameDirectory() .. "\\moonloader\\fatality\\favoritesskin.txt"
        local file = io.open(skinFile, 'r')
        if file then
            fileContent4 = file:read('*all')
            file:close()
        else
            fileContent4 = 'Error open file.'
        end
end

local moonloaderPath = getGameDirectory() .. '\\moonloader\\'
readFile(moonloaderPath .. 'fatality\\vehicles.txt')
readFile2(moonloaderPath .. 'fatality\\skins.txt')
readFile3(moonloaderPath .. 'fatality\\favoritescar.txt')
readFile4(moonloaderPath .. 'fatality\\favoritesskin.txt')

local function charArrayToString(array, length)
    local str = ''
    for i = 0, length do
        local char = string.char(array[i])
        if char == '\0' then
            break
        end
        str = str .. char
    end
    return str
end

local function spawnPlayer()
    local id = getCharModel(PLAYER_PED)
    sampSendChat('/skin ' .. '1')
    sampSpawnPlayer()
    sampSendChat('/skin ' .. id)
end

imgui.OnInitialize(function()
    SoftBlueTheme()
end)
imgui.OnFrame(function() return WinState[0] end, function(player)
    imgui.Begin('##Window', WinState, imgui.WindowFlags.NoScrollbar)
    if imgui.BeginTabBar('Tabs') then
        if imgui.BeginTabItem('Машины') then
            if imgui.Button('Открыть список машин') then
                imgui.OpenPopup('List Cars')
            end
            imgui.SameLine()
            if imgui.Button("Добавить в избранное") then
                local vehicleID = charArrayToString(inputField, 256)
                table.insert(favoritesVehicles, vehicleID)
                writeToFile(getGameDirectory() .. "\\moonloader\\fatality\\favoritescar.txt", {vehicleID})
            end
            if imgui.BeginPopup('List Cars') then
                imgui.BeginChild('FileContent', imgui.ImVec2(900, 700), true)
                imgui.InputText('Название/ID машины', carbuffer, 256)
                imgui.SameLine()
                if imgui.Button('Поиск') then
                    searchResults = {}
                    local search = charArrayToString(carbuffer, 256)
                    for line in io.lines(getGameDirectory() .. "\\moonloader\\fatality\\vehicles.txt") do
                        if line:find(search) then table.insert(searchResults, line) end
                    end
                    showSearchWindow = true
                end
                imgui.TextUnformatted(fileContent)
                imgui.EndChild()
                if imgui.Button('Закрыть', imgui.ImVec2(280, 24)) then
                    imgui.CloseCurrentPopup()
                end
                imgui.EndPopup()
            end
            imgui.InputText("ID машины", inputField, 256)
            if imgui.Button("Создать машину") then
                local vehicleID = charArrayToString(inputField,256)
                sampSendChat('/veh ' .. vehicleID .. ' 1 1')
            end
            imgui.SetCursorPos(imgui.ImVec2(135, 151.0))
            if imgui.Button("Удалить машину") then
                sampSendChat('/adelveh')
            end
            imgui.SetCursorPos(imgui.ImVec2(15, 182.0))
            if imgui.Button("Починить машину") then
                local playerid = select(2,sampGetPlayerIdByCharHandle(PLAYER_PED))
                sampSendChat('/hp ' .. playerid )
            end
            imgui.SetCursorPos(imgui.ImVec2(143, 182.0))
            if imgui.Button("Перевернуть машину") then
                veh = getCarCharIsUsing(PLAYER_PED)
                setVehicleQuaternion(veh, 0, 0, 0, 0)
            end
            imgui.EndTabItem()
        end
        if imgui.BeginTabItem('Скины') then
            if imgui.Button('Открыть список скинов') then
                imgui.OpenPopup('List Skins')
            end
            imgui.SameLine()
            if imgui.Button("Добавить в избранное") then
                local skinID = charArrayToString(inputField2, 256)
                table.insert(favoritesSkins, skinID)
                writeToFile(getGameDirectory() .. "\\moonloader\\fatality\\favoritesskin.txt", {skinID})
            end
            if imgui.BeginPopup('List Skins') then
                imgui.BeginChild('FileContent2', imgui.ImVec2(900, 700), true)
                imgui.InputText('Название/ID скина', skinbuffer, 256)
                imgui.SameLine()
                if imgui.Button('Поиск') then
                    searchResults = {}
                    local search = charArrayToString(skinbuffer, 256)
                    for line in io.lines(getGameDirectory() .. "\\moonloader\\fatality\\skins.txt") do
                        if line:find(search) then table.insert(searchResults, line) end
                    end
                    showSearchWindow = true
                end
                imgui.TextUnformatted(fileContent2)
                imgui.EndChild()
                if imgui.Button('Close', imgui.ImVec2(280, 24)) then
                    imgui.CloseCurrentPopup()
                end
                imgui.EndPopup()
            end
            imgui.InputText("ID скина", inputField2, 256)
            if imgui.Button("Сменить скин") then
                local skinID = charArrayToString(inputField2,256)
                sampSendChat('/skin ' .. skinID)
                
            end
            imgui.PushItemWidth(30)
            imgui.InputText('1 акс', inputa1, 10)
            imgui.PushItemWidth(30)
            imgui.InputText('2 акс', inputa2, 10)
            if imgui.Button('Применить') then
                local aksID = charArrayToString(inputa1,256)
                local aksID2 = charArrayToString(inputa2,256)
                sampSendChat('/launcher ' .. aksID)
                sampSendChat('/launcher ' .. aksID2)
            end
            imgui.EndTabItem()
        end
        if imgui.BeginTabItem('Основное') then
            if imgui.Button('Спавн') then
                spawnPlayer()
            end
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.Text('Если не работает:')
                imgui.Text('1. /re <любой игрок>')
                imgui.Text('2. Выйдите из /re')
                imgui.Text('3. Нажмите кнопку спавна')
                imgui.EndTooltip()
            end
            if imgui.Button('Обновить скрипт') then
                update()
            end
                imgui.BeginChild("ChatLog", imgui.ImVec2(checkx[0], checky[0]), true)      
                for _, msg in ipairs(messages) do
                    imgui.TextWrapped(msg)
                end
                imgui.EndPopup()
                imgui.SetCursorPos(imgui.ImVec2(15, 305.0))
            if imgui.Button('Очистить') then
                messages = {}
            end
            imgui.SetCursorPos(imgui.ImVec2(93, 305.0))
            if imgui.Button('Настройки') then
                imgui.OpenPopup('Settings')
            end
            if imgui.BeginPopup('Settings') then
                imgui.SliderFloat('X', checkx, 1, 1000)
                imgui.SliderFloat('Y', checky, 1, 1000)
                if imgui.Button('Reset') then
                    checkx[0] = 500.000
                    checky[0] = 150.000
                end
                imgui.EndPopup()
            end
            imgui.EndTabItem()
        end
        if imgui.BeginTabItem('Избранное') then
        
            if imgui.Button('Открыть избранные машины') then
                imgui.OpenPopup('Favorites Car')
            end
            if imgui.BeginPopup('Favorites Car') then
                imgui.BeginChild('FileContent3', imgui.ImVec2(400, 300), true)
                imgui.TextUnformatted(fileContent3)
                imgui.EndChild()
                if imgui.Button('Закрыть', imgui.ImVec2(280, 24)) then
                    imgui.CloseCurrentPopup()
                end
                imgui.EndPopup()
            end
        
            if imgui.Button('Открыть избранные скины') then
                imgui.OpenPopup('Favorites Skins')
            end
            if imgui.BeginPopup('Favorites Skins') then
                imgui.BeginChild('FileContent4', imgui.ImVec2(400, 300), true)
                imgui.TextUnformatted(fileContent4)
                imgui.EndChild()
                if imgui.Button('Закрыть', imgui.ImVec2(280, 24)) then
                    imgui.CloseCurrentPopup()
                end
                imgui.EndChild()
                imgui.EndPopup()
            end
            imgui.EndTabItem()
        end
        if imgui.BeginTabItem('Команды') then
            imgui.InputText('Пароль', password,256)
            local inputp = charArrayToString(password, 256)
            if inputp == enterpassword then
                dostup[0] = true
                if aclLevel >= 1 and dostup[0] == true then
                    if imgui.Button('1 АКЛ') then
                        imgui.OpenPopup('1 ACL')
                    end
                    if imgui.BeginPopup('1 ACL') then
                        imgui.BeginChild('CommandList', imgui.ImVec2(500, 350), true)
                        for i, command in ipairs(commands1) do
                            imgui.TextUnformatted(command)
                        end
                        imgui.EndChild()
                        if imgui.Button('Закрыть', imgui.ImVec2(280, 24)) then
                            imgui.CloseCurrentPopup()
                        end
                        imgui.EndPopup()
                    end
                else
                    imgui.Text("У вас недостаточный уровень доступа")
                end
                if aclLevel >= 2 and dostup[0] == true then
                    if imgui.Button('2 АКЛ') then
                        imgui.OpenPopup('2 ACL')
                    end
                    if imgui.BeginPopup('2 ACL') then
                        imgui.BeginChild('CommandList', imgui.ImVec2(500, 350), true)
                        for i, command in ipairs(commands2) do
                            imgui.TextUnformatted(command)
                        end
                        imgui.EndChild()
                        if imgui.Button('Закрыть', imgui.ImVec2(280, 24)) then
                            imgui.CloseCurrentPopup()
                        end
                        imgui.EndPopup()
                    end
                else
                    imgui.Text("У вас недостаточный уровень доступа")
                end
                if aclLevel >= 3 and dostup[0] == true then
                    if imgui.Button('3 АКЛ') then
                        imgui.OpenPopup('3 ACL')
                    end
                    if imgui.BeginPopup('3 ACL') then
                        imgui.BeginChild('CommandList', imgui.ImVec2(500, 350), true)
                        for i, command in ipairs(commands3) do
                            imgui.TextUnformatted(command)
                        end
                        imgui.EndChild()
                        if imgui.Button('Закрыть', imgui.ImVec2(280, 24)) then
                            imgui.CloseCurrentPopup()
                        end
                        imgui.EndPopup()
                    end
                else
                    imgui.Text("У вас недостаточный уровень доступа")
                end
            else
                dostup[0] = false
            imgui.EndTabItem()
        end
        imgui.EndTabBar()
    end
    imgui.End()
    if showSearchWindow == true then
        imgui.Begin('Найденное')
        if #searchResults > 0 then
            imgui.BeginChild('ResultsChild', imgui.ImVec2(500, 150), true)
            for idx, result in ipairs(searchResults) do
                if imgui.Selectable(result, selectedIndex == idx) then
                    selectedIndex = idx
                    local id = result:match("^(%d+)")
                    selectedText = id
                end
            end
            imgui.EndChild()
            if imgui.Button('Копировать выделенное') then
                if selectedText ~= "" then
                    imgui.SetClipboardText(selectedText)
                end
            end
        else
            imgui.Text('Нет результата')
        end

        if imgui.Button('Закрыть') then
            showSearchWindow = false
        end
        imgui.End()
    end
end
end)



function SoftBlueTheme()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
  
    style.WindowPadding = imgui.ImVec2(15, 15)
    style.WindowRounding = 10.0
    style.ChildRounding = 6.0
    style.FramePadding = imgui.ImVec2(8, 7)
    style.FrameRounding = 8.0
    style.ItemSpacing = imgui.ImVec2(8, 8)
    style.ItemInnerSpacing = imgui.ImVec2(10, 6)
    style.IndentSpacing = 25.0
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 12.0
    style.GrabMinSize = 10.0
    style.GrabRounding = 6.0
    style.PopupRounding = 8
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

    style.Colors[imgui.Col.Text]                   = imgui.ImVec4(0.90, 0.90, 0.93, 1.00)
    style.Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.40, 0.40, 0.45, 1.00)
    style.Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.12, 0.12, 0.14, 1.00)
    style.Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.18, 0.20, 0.22, 0.30)
    style.Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.13, 0.13, 0.15, 1.00)
    style.Colors[imgui.Col.Border]                 = imgui.ImVec4(0.30, 0.30, 0.35, 1.00)
    style.Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    style.Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.18, 0.18, 0.20, 1.00)
    style.Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.28, 1.00)
    style.Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.30, 0.30, 0.34, 1.00)
    style.Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.15, 0.15, 0.17, 1.00)
    style.Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.10, 0.10, 0.12, 1.00)
    style.Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.15, 0.15, 0.17, 1.00)
    style.Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.14, 1.00)
    style.Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.14, 1.00)
    style.Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.30, 0.30, 0.35, 1.00)
    style.Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.40, 0.40, 0.45, 1.00)
    style.Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.50, 0.50, 0.55, 1.00)
    style.Colors[imgui.Col.CheckMark]              = imgui.ImVec4(0.70, 0.70, 0.90, 1.00)
    style.Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.70, 0.70, 0.90, 1.00)
    style.Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.80, 0.80, 0.90, 1.00)
    style.Colors[imgui.Col.Button]                 = imgui.ImVec4(0.18, 0.18, 0.20, 1.00)
    style.Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.60, 0.60, 0.90, 1.00)
    style.Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.28, 0.56, 0.96, 1.00)
    style.Colors[imgui.Col.Header]                 = imgui.ImVec4(0.20, 0.20, 0.23, 1.00)
    style.Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.25, 0.25, 0.28, 1.00)
    style.Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.30, 0.30, 0.34, 1.00)
    style.Colors[imgui.Col.Separator]              = imgui.ImVec4(0.40, 0.40, 0.45, 1.00)
    style.Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.50, 0.50, 0.55, 1.00)
    style.Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.60, 0.60, 0.65, 1.00)
    style.Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.20, 0.20, 0.23, 1.00)
    style.Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.25, 0.25, 0.28, 1.00)
    style.Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.30, 0.30, 0.34, 1.00)
    style.Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.64, 1.00)
    style.Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(0.70, 0.70, 0.75, 1.00)
    style.Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.61, 0.61, 0.64, 1.00)
    style.Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(0.70, 0.70, 0.75, 1.00)
    style.Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.30, 0.30, 0.34, 1.00)
    style.Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.10, 0.10, 0.12, 0.80)
    style.Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.18, 0.20, 0.22, 1.00)
    style.Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.60, 0.60, 0.90, 1.00)
    style.Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.28, 0.56, 0.96, 1.00)
end

function main()
    while true do
        wait(0)
        if wasKeyPressed(VK_R) and not sampIsCursorActive() then
            WinState[0] = not WinState[0]
        end
        if isCharDead(PLAYER_PED) then spawnPlayer() end
    end
end
