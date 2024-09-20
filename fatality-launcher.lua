script_version '2.9'

require('lib.moonloader')
local imgui = require 'mimgui'
local encoding = require 'encoding'
encoding.default = 'UTF-8'
local u8 = encoding.UTF8
local new = imgui.new
local dlstatus = require "moonloader".download_status

function update()
    local updatePath = os.getenv('TEMP')..'\\Update.json'
    -- Check new update
    downloadUrlToFile("https://raw.githubusercontent.com/MSIshka2/fatality/main/fatality.json?", updatePath, function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            local file = io.open(updatePath, 'r')
            if file and doesFileExist(updatePath) then
                local info = decodeJson(file:read("*a"))
                file:close(); os.remove(updatePath)
                if info.version ~= thisScript().version then
                    lua_thread.create(function()
                        wait(2000)
                        -- Update script
                        downloadUrlToFile("https://raw.githubusercontent.com/MSIshka2/fatality/main/fatality-launcher.lua?", thisScript().path, function(id, status, p1, p2)
                            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                                -- Update successful: info.version
                                thisScript():reload()
                            end
                        end)
                    end)
                else
                    -- No update
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
local messages = {}
act = false

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

local moonloaderPath = getGameDirectory() .. '\\moonloader\\'
readFile(moonloaderPath .. 'fatality\\vehicles.txt')
readFile2(moonloaderPath .. 'fatality\\skins.txt')

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

imgui.OnFrame(function() return WinState[0] end, function(player)
    imgui.Begin('##Window', WinState, imgui.WindowFlags.NoScrollbar)
    if imgui.BeginTabBar('Tabs') then
        if imgui.BeginTabItem('Cars') then
            if imgui.Button('Open list Cars') then
                imgui.OpenPopup('List Cars')
            end
            if imgui.BeginPopup('List Cars') then
                imgui.BeginChild('FileContent', imgui.ImVec2(900, 700), true)
                imgui.TextUnformatted(fileContent)
                imgui.EndChild()
                if imgui.Button('Close', imgui.ImVec2(280, 24)) then
                    imgui.CloseCurrentPopup()
                end
                imgui.EndPopup()
            end
            imgui.InputText("ID Car", inputField, 256)
            if imgui.Button("Create Car") then
                local vehicleID = charArrayToString(inputField,256)
                sampSendChat('/veh ' .. vehicleID .. ' 1 1')
            end
            imgui.SetCursorPos(imgui.ImVec2(90, 100.5))
            if imgui.Button("Delete Car") then
                sampSendChat('/adelveh')
            end
            imgui.SetCursorPos(imgui.ImVec2(8, 130.5))
            if imgui.Button("Fix Car") then
                local playerid = select(2,sampGetPlayerIdByCharHandle(PLAYER_PED))
                sampSendChat('/hp ' .. playerid )
            end
            imgui.SetCursorPos(imgui.ImVec2(70, 130.5))
            if imgui.Button("Flip Car") then
                veh = getCarCharIsUsing(PLAYER_PED)
                setVehicleQuaternion(veh, 0, 0, 0, 0)
            end
            imgui.EndTabItem()
        end
        if imgui.BeginTabItem('Skins') then
            if imgui.Button('Open list Skins') then
                imgui.OpenPopup('List Skins')
            end
            if imgui.BeginPopup('List Skins') then
                imgui.BeginChild('FileContent2', imgui.ImVec2(900, 700), true)
                imgui.TextUnformatted(fileContent2)
                imgui.EndChild()
                if imgui.Button('Close', imgui.ImVec2(280, 24)) then
                    imgui.CloseCurrentPopup()
                end
                imgui.EndPopup()
            end
            imgui.InputText("ID Skin", inputField2, 256)
            if imgui.Button("Change Skin") then
                local skinID = charArrayToString(inputField2,256)
                sampSendChat('/skin ' .. skinID)
                
            end
            imgui.EndTabItem()
        end
        if imgui.BeginTabItem('Main') then
            if imgui.Button('Spawn') then
                local id = getCharModel(PLAYER_PED)
                sampSendChat('/skin ' .. '1')
                sampSpawnPlayer()
                sampSendChat('/skin ' .. id)
            end
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.Text('If not work:')
                imgui.Text('1. /re <random player>')
                imgui.Text('2. Leave /re')
                imgui.Text('3. Click Spawn')
                imgui.EndTooltip()
            end
            if imgui.Button('Update') then
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
