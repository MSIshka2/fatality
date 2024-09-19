script_name("fatality-launcher")
script_version('1.4')

require('lib.moonloader')
local imgui = require 'mimgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local new = imgui.new

local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'РћР±РЅР°СЂСѓР¶РµРЅРѕ РѕР±РЅРѕРІР»РµРЅРёРµ. РџС‹С‚Р°СЋСЃСЊ РѕР±РЅРѕРІРёС‚СЊСЃСЏ c '..thisScript().version..' РЅР° '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Р—Р°РіСЂСѓР¶РµРЅРѕ %d РёР· %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Р—Р°РіСЂСѓР·РєР° РѕР±РЅРѕРІР»РµРЅРёСЏ Р·Р°РІРµСЂС€РµРЅР°.')sampAddChatMessage(b..'РћР±РЅРѕРІР»РµРЅРёРµ Р·Р°РІРµСЂС€РµРЅРѕ!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'РћР±РЅРѕРІР»РµРЅРёРµ РїСЂРѕС€Р»Рѕ РЅРµСѓРґР°С‡РЅРѕ. Р—Р°РїСѓСЃРєР°СЋ СѓСЃС‚Р°СЂРµРІС€СѓСЋ РІРµСЂСЃРёСЋ..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': РћР±РЅРѕРІР»РµРЅРёРµ РЅРµ С‚СЂРµР±СѓРµС‚СЃСЏ.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': РќРµ РјРѕРіСѓ РїСЂРѕРІРµСЂРёС‚СЊ РѕР±РЅРѕРІР»РµРЅРёРµ. РЎРјРёСЂРёС‚РµСЃСЊ РёР»Рё РїСЂРѕРІРµСЂСЊС‚Рµ СЃР°РјРѕСЃС‚РѕСЏС‚РµР»СЊРЅРѕ РЅР° '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, РІС‹С…РѕРґРёРј РёР· РѕР¶РёРґР°РЅРёСЏ РїСЂРѕРІРµСЂРєРё РѕР±РЅРѕРІР»РµРЅРёСЏ. РЎРјРёСЂРёС‚РµСЃСЊ РёР»Рё РїСЂРѕРІРµСЂСЊС‚Рµ СЃР°РјРѕСЃС‚РѕСЏС‚РµР»СЊРЅРѕ РЅР° '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/MSIshka2/fatality/main/fatality.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/MSIshka2/fatality/"
        end
    end
end

local WinState = new.bool()
local fileContent = ''
local fileContent2 = ''
local inputField = new.char[256]()
local inputField2 = new.char[256]()

-- Функция для чтения содержимого файла
local function readFile(filename)
    local file = io.open(filename, 'r')
    if file then
        fileContent = file:read('*all')
        file:close()
    else
        fileContent = 'Не удалось открыть файл.'
    end
end

local function readFile2(filename2)
    local file = io.open(filename2, 'r')
    if file then
        fileContent2 = file:read('*all')
        file:close()
    else
        fileContent2 = 'Не удалось открыть файл.'
    end
end

local moonloaderPath = getGameDirectory() .. '\\moonloader\\'
readFile(moonloaderPath .. 'fatality\\vehicles.txt')
readFile2(moonloaderPath .. 'fatality\\skins.txt')

local function charArrayToString(array, length)
    local str = ''
    for i = 0, length do
        local char = string.char(array[i])
        if char == '\0' then  -- Прекращаем, если достигли конца строки
            break
        end
        str = str .. char
    end
    return str
end

imgui.OnFrame(function() return WinState[0] end, function(player)
    imgui.Begin('##Window', WinState, imgui.WindowFlags.NoScrollbar)
    if imgui.BeginTabBar('Tabs') then
        if imgui.BeginTabItem(u8'Машины') then
            if imgui.Button(u8'Открыть список машин') then
                imgui.OpenPopup(u8'Список машин')
            end
            if imgui.BeginPopup(u8'Список машин') then
                imgui.BeginChild(u8'FileContent', imgui.ImVec2(900, 700), true)
                imgui.TextUnformatted(fileContent)
                imgui.EndChild()
                if imgui.Button(u8'Закрыть', imgui.ImVec2(280, 24)) then
                    imgui.CloseCurrentPopup()
                end
                imgui.EndPopup()
            end
            imgui.InputText(u8"Id машины", inputField, 256)
            if imgui.Button(u8"Создать машину") then
                local vehicleID = charArrayToString(inputField,256)
                sampSendChat('/veh ' .. vehicleID .. ' 1 1')
            end
            imgui.SetCursorPos(imgui.ImVec2(130, 100.5))
            if imgui.Button(u8"Удалить машину") then
                sampSendChat('/adelveh')
            end
            imgui.EndTabItem()
        end
        if imgui.BeginTabItem(u8'Скины') then
            if imgui.Button(u8'Открыть список скинов') then
                imgui.OpenPopup(u8'Список скинов')
            end
            if imgui.BeginPopup(u8'Список скинов') then
                imgui.BeginChild(u8'FileContent2', imgui.ImVec2(900, 700), true)
                imgui.TextUnformatted(fileContent2)
                imgui.EndChild()
                if imgui.Button(u8'Закрыть', imgui.ImVec2(280, 24)) then
                    imgui.CloseCurrentPopup()
                end
                imgui.EndPopup()
            end
            imgui.InputText(u8"Id скина", inputField2, 256)
            if imgui.Button(u8"Сменить скин") then
                local skinID = charArrayToString(inputField2,256)
                sampSendChat('/skin ' .. skinID)
                
            end
            imgui.EndTabItem()
        end
        if imgui.BeginTabItem(u8'Основное') then
            if imgui.Button(u8'Спавн') then
                local id = getCharModel(PLAYER_PED)
                sampSendChat('/skin ' .. '1')
                sampSpawnPlayer()
                sampSendChat('/skin ' .. id)
            end
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.Text(u8'Если не помогло, тогда:')
                imgui.Text(u8'1. Начните наблюдать за каким-то игроком')
                imgui.Text(u8'2. Затем выйдите из рекона')
                imgui.Text(u8'3. Нажмите кнопку')
                imgui.EndTooltip()
            end
        end
        imgui.EndTabBar()
    end
    imgui.End()
end)

function main()
    while true do
        wait(0)
        if wasKeyPressed(VK_R) and not sampIsCursorActive() then
            WinState[0] = not WinState[0]
        end

        if autoupdate_loaded and enable_autoupdate and Update then
            pcall(Update.check, Update.json_url, Update.prefix, Update.url)
        end
    end
end
