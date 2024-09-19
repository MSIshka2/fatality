script_version '1.3'

require('lib.moonloader')
local imgui = require 'mimgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local new = imgui.new
local dlstatus = require "moonloader".download_status

function update()
    local updatePath = os.getenv('TEMP')..'\\Update.json'
    -- �������� ����� ������
    downloadUrlToFile("https://raw.githubusercontent.com/MSIshka2/fatality/main/fatality.json?", updatePath, function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            local file = io.open(updatePath, 'r')
            if file and doesFileExist(updatePath) then
                local info = decodeJson(file:read("*a"))
                file:close(); os.remove(updatePath)
                if info.version ~= thisScript().version then
                    lua_thread.create(function()
                        wait(2000)
                        -- �������� �������, ���� ������ ����������
                        downloadUrlToFile("https://raw.githubusercontent.com/MSIshka2/fatality/main/fatality-launcher.lua?", thisScript().path, function(id, status, p1, p2)
                            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                                -- ���������� ������� ���������, ����� ������: info.version
                                thisScript():reload()
                            end
                        end)
                    end)
                else
                    -- ���������� ���
                end
            end
        end
    end)
end


local WinState = new.bool()
local fileContent = ''
local fileContent2 = ''
local inputField = new.char[256]()
local inputField2 = new.char[256]()

-- ������� ��� ������ ����������� �����
local function readFile(filename)
    local file = io.open(filename, 'r')
    if file then
        fileContent = file:read('*all')
        file:close()
    else
        fileContent = '�� ������� ������� ����.'
    end
end

local function readFile2(filename2)
    local file = io.open(filename2, 'r')
    if file then
        fileContent2 = file:read('*all')
        file:close()
    else
        fileContent2 = '�� ������� ������� ����.'
    end
end

local moonloaderPath = getGameDirectory() .. '\\moonloader\\'
readFile(moonloaderPath .. 'fatality\\vehicles.txt')
readFile2(moonloaderPath .. 'fatality\\skins.txt')

local function charArrayToString(array, length)
    local str = ''
    for i = 0, length do
        local char = string.char(array[i])
        if char == '\0' then  -- ����������, ���� �������� ����� ������
            break
        end
        str = str .. char
    end
    return str
end

imgui.OnFrame(function() return WinState[0] end, function(player)
    imgui.Begin('##Window', WinState, imgui.WindowFlags.NoScrollbar)
    if imgui.BeginTabBar('Tabs') then
        if imgui.BeginTabItem(u8'������') then
            if imgui.Button(u8'������� ������ �����') then
                imgui.OpenPopup(u8'������ �����')
            end
            if imgui.BeginPopup(u8'������ �����') then
                imgui.BeginChild(u8'FileContent', imgui.ImVec2(900, 700), true)
                imgui.TextUnformatted(fileContent)
                imgui.EndChild()
                if imgui.Button(u8'�������', imgui.ImVec2(280, 24)) then
                    imgui.CloseCurrentPopup()
                end
                imgui.EndPopup()
            end
            imgui.InputText(u8"Id ������", inputField, 256)
            if imgui.Button(u8"������� ������") then
                local vehicleID = charArrayToString(inputField,256)
                sampSendChat('/veh ' .. vehicleID .. ' 1 1')
            end
            imgui.SetCursorPos(imgui.ImVec2(130, 100.5))
            if imgui.Button(u8"������� ������") then
                sampSendChat('/adelveh')
            end
            imgui.EndTabItem()
        end
        if imgui.BeginTabItem(u8'�����') then
            if imgui.Button(u8'������� ������ ������') then
                imgui.OpenPopup(u8'������ ������')
            end
            if imgui.BeginPopup(u8'������ ������') then
                imgui.BeginChild(u8'FileContent2', imgui.ImVec2(900, 700), true)
                imgui.TextUnformatted(fileContent2)
                imgui.EndChild()
                if imgui.Button(u8'�������', imgui.ImVec2(280, 24)) then
                    imgui.CloseCurrentPopup()
                end
                imgui.EndPopup()
            end
            imgui.InputText(u8"Id �����", inputField2, 256)
            if imgui.Button(u8"������� ����") then
                local skinID = charArrayToString(inputField2,256)
                sampSendChat('/skin ' .. skinID)
                
            end
            imgui.EndTabItem()
        end
        if imgui.BeginTabItem(u8'��������') then
            if imgui.Button(u8'�����') then
                local id = getCharModel(PLAYER_PED)
                sampSendChat('/skin ' .. '1')
                sampSpawnPlayer()
                sampSendChat('/skin ' .. id)
            end
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.Text(u8'���� �� �������, �����:')
                imgui.Text(u8'1. ������� ��������� �� �����-�� �������')
                imgui.Text(u8'2. ����� ������� �� ������')
                imgui.Text(u8'3. ������� ������')
                imgui.EndTooltip()
            end
            if imgui.Button(u8'����������') then
                update()
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
    end
end
