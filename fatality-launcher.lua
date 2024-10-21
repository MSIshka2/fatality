script_version '1.3.3'

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
local notify = import 'imgui_notf.lua'
local effil = require("effil")
local inicfg = require('inicfg')
local ffi = require('ffi')
local bitex = require 'bitex'
local memory = require 'memory'
local IniFilename = 'fatalitytg.ini'
local ini = inicfg.load({
    telegramtc = {
        token = 'token',
        chat_id = 'chat_id',
        theme = 4,
        style = 1,
        hp = false
    }
}, IniFilename)
inicfg.save(ini, IniFilename)

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
local activation = new.bool()
local password = new.char[256]()
local dostup = new.bool()
local savedCoordinates = {x = nil, y = nil, z = nil}
local hp = new.bool()
local status = false
local status1 = false
local tokenbuffer = new.char[256]()
local chatidbuffer = new.char[256]()
local colorList = {'Красная', 'Зелёная','Бело-синяя','Чёрно-фиолетовая','Дефолт', 'CS 1.6'}
local colorListNumber = new.int()
local colorListBuffer = new['const char*'][#colorList](colorList)
local styleList = {'Дефолт', 'Стиль 1','Стиль2', 'CS 1.6'}
local styleListNumber = new.int()
local styleListBuffer = new['const char*'][#styleList](styleList)

theme = {
    {
        change = function()
            local ImVec4 = imgui.ImVec4
            imgui.SwitchContext()
            imgui.GetStyle().Colors[imgui.Col.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
            imgui.GetStyle().Colors[imgui.Col.WindowBg]               = ImVec4(0.10, 0.06, 0.06, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ChildBg]                = ImVec4(1.00, 1.00, 1.00, 0.00)
            imgui.GetStyle().Colors[imgui.Col.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
            imgui.GetStyle().Colors[imgui.Col.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
            imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBg]                = ImVec4(0.48, 0.16, 0.16, 0.54)
            imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = ImVec4(0.98, 0.26, 0.26, 0.40)
            imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = ImVec4(0.98, 0.26, 0.26, 0.67)
            imgui.GetStyle().Colors[imgui.Col.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = ImVec4(0.48, 0.16, 0.16, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
            imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
            imgui.GetStyle().Colors[imgui.Col.CheckMark]              = ImVec4(0.98, 0.26, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = ImVec4(0.88, 0.26, 0.24, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = ImVec4(0.98, 0.26, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Button]                 = ImVec4(0.98, 0.26, 0.26, 0.40)
            imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = ImVec4(0.98, 0.26, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = ImVec4(0.98, 0.06, 0.06, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Header]                 = ImVec4(0.98, 0.26, 0.26, 0.31)
            imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = ImVec4(0.98, 0.26, 0.26, 0.80)
            imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = ImVec4(0.98, 0.26, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Separator]              = ImVec4(0.43, 0.43, 0.50, 0.50)
            imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = ImVec4(0.75, 0.10, 0.10, 0.78)
            imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = ImVec4(0.75, 0.10, 0.10, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = ImVec4(0.98, 0.26, 0.26, 0.25)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = ImVec4(0.98, 0.26, 0.26, 0.67)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = ImVec4(0.98, 0.26, 0.26, 0.95)
            imgui.GetStyle().Colors[imgui.Col.Tab]                    = ImVec4(0.98, 0.26, 0.26, 0.40)
            imgui.GetStyle().Colors[imgui.Col.TabHovered]             = ImVec4(0.98, 0.26, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabActive]              = ImVec4(0.98, 0.06, 0.06, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = ImVec4(0.98, 0.26, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = ImVec4(0.98, 0.26, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = ImVec4(0.98, 0.26, 0.26, 0.35)
        end
    },
    {
        change = function()
            local ImVec4 = imgui.ImVec4
            imgui.SwitchContext()
            imgui.GetStyle().Colors[imgui.Col.Text]                   = ImVec4(0.90, 0.90, 0.90, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = ImVec4(0.60, 0.60, 0.60, 1.00)
            imgui.GetStyle().Colors[imgui.Col.WindowBg]               = ImVec4(0.08, 0.10, 0.08, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ChildBg]                = ImVec4(0.10, 0.10, 0.10, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Border]                 = ImVec4(0.70, 0.70, 0.70, 0.40)
            imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBg]                = ImVec4(0.15, 0.15, 0.15, 1.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = ImVec4(0.19, 0.19, 0.19, 0.71)
            imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = ImVec4(0.34, 0.34, 0.34, 0.79)
            imgui.GetStyle().Colors[imgui.Col.TitleBg]                = ImVec4(0.00, 0.69, 0.33, 0.80)
            imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = ImVec4(0.00, 0.74, 0.36, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = ImVec4(0.00, 0.69, 0.33, 0.50)
            imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = ImVec4(0.00, 0.80, 0.38, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = ImVec4(0.16, 0.16, 0.16, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = ImVec4(0.00, 0.69, 0.33, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = ImVec4(0.00, 0.82, 0.39, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = ImVec4(0.00, 1.00, 0.48, 1.00)
            imgui.GetStyle().Colors[imgui.Col.CheckMark]              = ImVec4(0.00, 0.69, 0.33, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = ImVec4(0.00, 0.69, 0.33, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = ImVec4(0.00, 0.77, 0.37, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Button]                 = ImVec4(0.00, 0.69, 0.00, 0.40)
            imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = ImVec4(0.00, 0.16, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = ImVec4(0.00, 0.60, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Header]                 = ImVec4(0.00, 0.69, 0.33, 1.00)
            imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = ImVec4(0.00, 0.76, 0.37, 0.57)
            imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = ImVec4(0.00, 0.88, 0.42, 0.89)
            imgui.GetStyle().Colors[imgui.Col.Separator]              = ImVec4(1.00, 1.00, 1.00, 0.40)
            imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = ImVec4(1.00, 1.00, 1.00, 0.60)
            imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = ImVec4(1.00, 1.00, 1.00, 0.80)
            imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = ImVec4(0.00, 0.69, 0.33, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = ImVec4(0.00, 0.76, 0.37, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = ImVec4(0.00, 0.86, 0.41, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Tab]                    = ImVec4(0.00, 0.69, 0.00, 0.40)
            imgui.GetStyle().Colors[imgui.Col.TabHovered]             = ImVec4(0.00, 0.16, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabActive]              = ImVec4(0.00, 0.60, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = ImVec4(0.00, 0.76, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = ImVec4(0.00, 0.76, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLines]              = ImVec4(0.00, 0.69, 0.33, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = ImVec4(0.00, 0.74, 0.36, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = ImVec4(0.00, 0.69, 0.33, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = ImVec4(0.00, 0.80, 0.38, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = ImVec4(0.00, 0.69, 0.33, 0.72)
        end
    },
    {
        change = function()
            local ImVec4 = imgui.ImVec4
            imgui.SwitchContext()
            imgui.GetStyle().Colors[imgui.Col.FrameBg]                = ImVec4(0.66, 0.66, 0.66, 1.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = ImVec4(0.26, 0.59, 0.98, 0.40)
            imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = ImVec4(0.26, 0.59, 0.98, 0.67)
            imgui.GetStyle().Colors[imgui.Col.TitleBg]                = ImVec4(0.16, 0.29, 0.48, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = ImVec4(0.16, 0.29, 0.48, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
            imgui.GetStyle().Colors[imgui.Col.CheckMark]              = ImVec4(0.26, 0.59, 0.98, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = ImVec4(0.24, 0.52, 0.88, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = ImVec4(0.26, 0.59, 0.98, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Button]                 = ImVec4(0.00, 0.49, 1.00, 0.59)
            imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = ImVec4(0.00, 0.49, 1.00, 0.71)
            imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = ImVec4(0.00, 0.49, 1.00, 0.78)
            imgui.GetStyle().Colors[imgui.Col.Header]                 = ImVec4(0.26, 0.59, 0.98, 0.31)
            imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = ImVec4(0.26, 0.59, 0.98, 0.80)
            imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = ImVec4(0.26, 0.59, 0.98, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Separator]              = ImVec4(0.43, 0.43, 0.50, 0.50)
            imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = ImVec4(0.26, 0.59, 0.98, 0.78)
            imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = ImVec4(0.26, 0.59, 0.98, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = ImVec4(0.26, 0.59, 0.98, 0.25)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = ImVec4(0.26, 0.59, 0.98, 0.67)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = ImVec4(0.26, 0.59, 0.98, 0.95)
            imgui.GetStyle().Colors[imgui.Col.Tab]                    = ImVec4(0.26, 0.59, 0.98, 0.80)
            imgui.GetStyle().Colors[imgui.Col.TabHovered]             = ImVec4(0.26, 0.59, 0.78, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabActive]              = ImVec4(0.00, 0.29, 0.50, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = ImVec4(0.00, 0.00, 0.40, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = ImVec4(0.00, 0.00, 0.40, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = ImVec4(0.26, 0.59, 0.98, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Text]                   = ImVec4(0.00, 0.00, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = ImVec4(0.00, 0.00, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.WindowBg]               = ImVec4(1.00, 1.00, 1.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ChildBg]                = ImVec4(0.67, 0.67, 0.67, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PopupBg]                = ImVec4(0.06, 0.53, 0.68, 0.80)
            imgui.GetStyle().Colors[imgui.Col.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
            imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
            imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = ImVec4(0.00, 0.59, 1.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
        end
    
    },
    {
        change = function()
            local ImVec4 = imgui.ImVec4
            imgui.SwitchContext()
            imgui.GetStyle().Colors[imgui.Col.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
            imgui.GetStyle().Colors[imgui.Col.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ChildBg]                = ImVec4(1.00, 1.00, 1.00, 0.00)
            imgui.GetStyle().Colors[imgui.Col.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
            imgui.GetStyle().Colors[imgui.Col.Border]                 = ImVec4(0.35, 0.06, 0.35, 0.50)
            imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBg]                = ImVec4(0.35, 0.06, 0.25, 1.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = ImVec4(0.50, 0.06, 0.50, 1.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = ImVec4(0.50, 0.06, 0.50, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = ImVec4(0.50, 0.06, 0.50, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
            imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
            imgui.GetStyle().Colors[imgui.Col.CheckMark]              = ImVec4(0.70, 0.06, 0.70, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = ImVec4(0.88, 0.26, 0.24, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = ImVec4(0.98, 0.26, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Button]                 = ImVec4(0.35, 0.06, 0.25, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = ImVec4(0.50, 0.06, 0.50, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = ImVec4(0.50, 0.06, 0.50, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Header]                 = ImVec4(0.50, 0.06, 0.50, 1.00)
            imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = ImVec4(0.45, 0.06, 0.45, 1.00)
            imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = ImVec4(0.98, 0.26, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Separator]              = ImVec4(0.43, 0.43, 0.50, 0.50)
            imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = ImVec4(0.75, 0.10, 0.10, 0.78)
            imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = ImVec4(0.75, 0.10, 0.10, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = ImVec4(0.98, 0.26, 0.26, 0.25)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = ImVec4(0.98, 0.26, 0.26, 0.67)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = ImVec4(0.98, 0.26, 0.26, 0.95)
            imgui.GetStyle().Colors[imgui.Col.Tab]                    = ImVec4(0.35, 0.06, 0.25, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabHovered]             = ImVec4(0.50, 0.06, 0.50, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabActive]              = ImVec4(0.45, 0.06, 0.46, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = ImVec4(0.98, 0.26, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = ImVec4(0.98, 0.26, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = ImVec4(0.98, 0.26, 0.26, 0.35)
        end
    },
    {
        change = function()
            local ImVec4 = imgui.ImVec4
            imgui.SwitchContext()
            imgui.GetStyle().Colors[imgui.Col.Text]                   = ImVec4(0.90, 0.90, 0.93, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = ImVec4(0.40, 0.40, 0.45, 1.00)
            imgui.GetStyle().Colors[imgui.Col.WindowBg]               = ImVec4(0.12, 0.12, 0.14, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ChildBg]                = ImVec4(0.18, 0.20, 0.22, 0.30)
            imgui.GetStyle().Colors[imgui.Col.PopupBg]                = ImVec4(0.13, 0.13, 0.15, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Border]                 = ImVec4(0.30, 0.30, 0.35, 1.00)
            imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBg]                = ImVec4(0.18, 0.18, 0.20, 1.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = ImVec4(0.25, 0.25, 0.28, 1.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = ImVec4(0.30, 0.30, 0.34, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBg]                = ImVec4(0.15, 0.15, 0.17, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = ImVec4(0.10, 0.10, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = ImVec4(0.15, 0.15, 0.17, 1.00)
            imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = ImVec4(0.12, 0.12, 0.14, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = ImVec4(0.12, 0.12, 0.14, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = ImVec4(0.30, 0.30, 0.35, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = ImVec4(0.40, 0.40, 0.45, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = ImVec4(0.50, 0.50, 0.55, 1.00)
            imgui.GetStyle().Colors[imgui.Col.CheckMark]              = ImVec4(0.70, 0.70, 0.90, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = ImVec4(0.70, 0.70, 0.90, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = ImVec4(0.80, 0.80, 0.90, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Button]                 = ImVec4(0.18, 0.18, 0.20, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = ImVec4(0.60, 0.60, 0.90, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = ImVec4(0.28, 0.56, 0.96, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Header]                 = ImVec4(0.20, 0.20, 0.23, 1.00)
            imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = ImVec4(0.25, 0.25, 0.28, 1.00)
            imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = ImVec4(0.30, 0.30, 0.34, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Separator]              = ImVec4(0.40, 0.40, 0.45, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = ImVec4(0.50, 0.50, 0.55, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = ImVec4(0.60, 0.60, 0.65, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = ImVec4(0.20, 0.20, 0.23, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = ImVec4(0.25, 0.25, 0.28, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = ImVec4(0.30, 0.30, 0.34, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLines]              = ImVec4(0.61, 0.61, 0.64, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = ImVec4(0.70, 0.70, 0.75, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = ImVec4(0.61, 0.61, 0.64, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = ImVec4(0.70, 0.70, 0.75, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = ImVec4(0.30, 0.30, 0.34, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = ImVec4(0.10, 0.10, 0.12, 0.80)
            imgui.GetStyle().Colors[imgui.Col.Tab]                    = ImVec4(0.18, 0.20, 0.22, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabHovered]             = ImVec4(0.60, 0.60, 0.90, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabActive]              = ImVec4(0.28, 0.56, 0.96, 1.00)
        end
    },
    {
        change = function()
            local ImVec4 = imgui.ImVec4
            imgui.SwitchContext()
            imgui.GetStyle().Colors[imgui.Col.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
            imgui.GetStyle().Colors[imgui.Col.WindowBg]               = ImVec4(0.29, 0.34, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ChildBg]                = ImVec4(0.29, 0.34, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PopupBg]                = ImVec4(0.24, 0.27, 0.20, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Border]                 = ImVec4(0.54, 0.57, 0.51, 0.50)
            imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = ImVec4(0.14, 0.16, 0.11, 0.52)
            imgui.GetStyle().Colors[imgui.Col.FrameBg]                = ImVec4(0.24, 0.27, 0.20, 1.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = ImVec4(0.27, 0.30, 0.23, 1.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = ImVec4(0.00, 0.00, 0.00, 0.51)
            imgui.GetStyle().Colors[imgui.Col.TitleBg]                = ImVec4(0.24, 0.27, 0.20, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = ImVec4(0.29, 0.34, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
            imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = ImVec4(0.24, 0.27, 0.20, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = ImVec4(0.35, 0.42, 0.31, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = ImVec4(0.28, 0.32, 0.24, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = ImVec4(0.25, 0.30, 0.22, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = ImVec4(0.23, 0.27, 0.21, 1.00)
            imgui.GetStyle().Colors[imgui.Col.CheckMark]              = ImVec4(0.59, 0.54, 0.18, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = ImVec4(0.35, 0.42, 0.31, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = ImVec4(0.54, 0.57, 0.51, 0.50)
            imgui.GetStyle().Colors[imgui.Col.Button]                 = ImVec4(0.29, 0.34, 0.26, 0.40)
            imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = ImVec4(0.35, 0.42, 0.31, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = ImVec4(0.54, 0.57, 0.51, 0.50)
            imgui.GetStyle().Colors[imgui.Col.Header]                 = ImVec4(0.35, 0.42, 0.31, 1.00)
            imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = ImVec4(0.35, 0.42, 0.31, 0.6)
            imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = ImVec4(0.54, 0.57, 0.51, 0.50)
            imgui.GetStyle().Colors[imgui.Col.Separator]              = ImVec4(0.14, 0.16, 0.11, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = ImVec4(0.54, 0.57, 0.51, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = ImVec4(0.59, 0.54, 0.18, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = ImVec4(0.19, 0.23, 0.18, 0.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = ImVec4(0.54, 0.57, 0.51, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = ImVec4(0.59, 0.54, 0.18, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Tab]                    = ImVec4(0.35, 0.42, 0.31, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabHovered]             = ImVec4(0.54, 0.57, 0.51, 0.78)
            imgui.GetStyle().Colors[imgui.Col.TabActive]              = ImVec4(0.59, 0.54, 0.18, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = ImVec4(0.24, 0.27, 0.20, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = ImVec4(0.35, 0.42, 0.31, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = ImVec4(0.59, 0.54, 0.18, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = ImVec4(1.00, 0.78, 0.28, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = ImVec4(0.59, 0.54, 0.18, 1.00)
        end
    }
    
    
}

style = {
    {
        change = function()
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
            style.WindowBorderSize = 1
            style.ChildBorderSize = 1
            style.PopupBorderSize = 1
            style.FrameBorderSize = 1
            style.TabBorderSize = 1
        end
    },
    {
        change = function()
            imgui.SwitchContext()
            local style = imgui.GetStyle()
            style.WindowPadding = imgui.ImVec2(15, 15)
            style.WindowRounding = 3.0
            style.ChildRounding = 3.0
            style.FramePadding = imgui.ImVec2(8, 7)
            style.FrameRounding = 3.0
            style.ItemSpacing = imgui.ImVec2(8, 8)
            style.ItemInnerSpacing = imgui.ImVec2(10, 6)
            style.IndentSpacing = 25.0
            style.ScrollbarSize = 13.0
            style.ScrollbarRounding = 1.0
            style.GrabMinSize = 10.0
            style.GrabRounding = 3.0
            style.PopupRounding = 3
            style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
            style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
            style.WindowBorderSize = 1
            style.ChildBorderSize = 1
            style.PopupBorderSize = 1
            style.FrameBorderSize = 1
            style.TabBorderSize = 1
        end
    },
    {
        change = function()
            imgui.SwitchContext()
            local style = imgui.GetStyle()
            style.WindowPadding = imgui.ImVec2(15, 15)
            style.WindowRounding = 20.0
            style.ChildRounding = 12.0
            style.FramePadding = imgui.ImVec2(8, 7)
            style.FrameRounding = 16.0
            style.ItemSpacing = imgui.ImVec2(8, 8)
            style.ItemInnerSpacing = imgui.ImVec2(10, 6)
            style.IndentSpacing = 25.0
            style.ScrollbarSize = 13.0
            style.ScrollbarRounding = 24.0
            style.GrabMinSize = 10.0
            style.GrabRounding = 12.0
            style.PopupRounding = 16
            style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
            style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
            style.WindowBorderSize = 1
            style.ChildBorderSize = 1
            style.PopupBorderSize = 1
            style.FrameBorderSize = 1
            style.TabBorderSize = 1
        end
    },
    {
        change = function()
            imgui.SwitchContext()
            local style = imgui.GetStyle()
            style.ItemSpacing = imgui.ImVec2(5, 5)
            style.ItemInnerSpacing = imgui.ImVec2(2, 2)
            style.TouchExtraPadding = imgui.ImVec2(0, 0)
            style.IndentSpacing = 0
            style.ScrollbarSize = 10
            style.GrabMinSize = 10
            style.WindowBorderSize = 1
            style.ChildBorderSize = 1
            style.PopupBorderSize = 1
            style.FrameBorderSize = 1
            style.TabBorderSize = 1
            style.WindowRounding = 0
            style.ChildRounding = 0
            style.FrameRounding = 0
            style.PopupRounding = 0
            style.ScrollbarRounding = 0
            style.GrabRounding = 0
            style.TabRounding = 0
            style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
            style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
        end
    }
}


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
local commands4 = {
    "/gifts - Просмотр логов подарков",
    "/addgift - Выдача подарков",
    "/testmp - Мероприятие 'Угадай цифру'",
    "/abanip - Быстрый BanIP",
    "/nosave - Заморозить аккаунт",
    "/rip - Выдать вечный бан",
    "/unrip - Снять вечный бан",
    "/glist - Игроки с G.Auth",
    "/gdelete - Удалить G.Auth у игрока",
    "/asms - Предупреждение от модератора",
    "/remont - Ремонт в квартире",
    "/asetint - Изменить INT игрока",
    "/asetvw - Изменить виртуальный мир игрока",
    "/inter - ТП в интерьеры",
    "/pmall - Ответ от админа всем игрокам",
    "/savemans - Игроки с запретом на сохранение аккаунта",
    "/userdelete - Очистить игрока в таблице gifts",
    "/usluga - Услуга 'Анти-снятие'",
    "/allusluga - Пакет услуг",
    "/neusluga - Снять услугу 'Анти-снятие'",
    "/jailusluga - Услуга 'Анти-jail'",
    "/nejailusluga - Снять услугу 'Анти-Jail'",
    "/arep - Выдать понизить репутацию(БЛАТ ЗАПРЕЩЕН)",
    "/neallusluga - Снять все услуги"
}
local commands5 = {
    "/setduel - Изменить настройки дуэля у игрока",
    "/present2 - Поставить пикап с подарком (/time)",
    "/present1 - Изменить таймер подарка (/time)",
    "/giveblow - Выдача салюта игроку",
    "/givepoints - Выдача баллов ATOP (БЛАТ ЗАПРЕЩЕН)",
    "/competition - Настройка голосования",
    "/afk - Список AFK-игроков",
    "/break - Установить ограждение",
    "/akick - Выгнать из любой семьи",
    "/fbanlist - Список ограниченных семей",
    "/fban - Ограничить семью",
    "/unfban - Снять ограничение семьи",
    "/afamily - Вкл/выкл 'галочку' семьи",
    "/virus - Настроить заражение игрока",
    "/startvirus - Начать зомби-апокалипсис",
    "/zombieoff - Закончить зомби-апокалипсис",
    "/alogs - Логирование наказаний",
    "/repedit - Изменение кол-ва репутации (БЛАТ ЗАПРЕЩЕН)",
    "/inviteclub - Изменение кол-ва часов для вступления в семью через /mm",
    "/offrepedit - изменение оффлайн репутации (БЛАТ ЗАПРЕЩЕН)"
}
local commands6 = {
    "/unvigall - Снять всем выговоры",
    "/offgivepoints - Изменение оффлайн кол-ва /atops",
    "/module - Вкл/откл модулей сервера(обновления)",
    "/aip - Список Online основателей с их IP's",
    "/spt - Написать текст от имени игрока",
    "/spdo - Использовать /do от имени игрока",
    "/spme - Использовать /me от имени игрока",
    "/testkick - Кикнуть игрока по 'шутке'",
    "/testban - Забанить игрока по 'шутке'",
    "/gocord - Телепортация по координатам",
    "/v - Будущий 'Админ' чат",
    "/lego - Включить режим 'Лего'",
    "/ohelp - Список команд для режима 'Лего'",
    "/newobj - Создание объекта",
    "/delast - Удалить последний созданный объект",
    "/editobj - Редактирование объекта",
    "/newactor - Создание актёра",
    "/editactor - Редактирование актёра",
    "/hbject - Создание объектов на игроке",
    "/hbjectedit - Редактирование объектов на игроке",
    "/offleaders - Просмотр оффлайн лидеров",
    "/eplayers - Список игроков с непройденной регистрацией",
    "/offadmins - Просмотр оффлайн админов 15+ уровня",
    "/tempfamily - Вступить в любую семью",
    "/allfamily - Список всех семей",
    "/giveday - Изменить кол-во бонусных дней (БЛАТ ЗАПРЕЩЕН)",
    "/offgiveday - Изменить оффлайн кол-во бонусных дней",
    "/abonus - Получение бонусов без ограничения времени",
    "/asetsex - Изменение пола игрока",
    "/addzone - Изменение ZZ (ограничить /veh /aveh /acar)",
    "/temproom - Вступить в приватную комнату"
}
local commands7 = {
    "/act - Настройки рейтингов",
    "/offosnova - Команда /osnova, но оффлайн",
    "/setklass - Установить класс дому",
    "/asetpos - Сменить позицию пикапа дома",
    "/setposcar - Сменить позицию спавна машин в доме",
    "/setcena - Изменить цену дома",
    "/delpos - Удалить позицию пикапа дома",
    "/asellhouse - Продать дом",
    "/savehouse - Сохранение дома"
}
local commands8 = {
    "/addexp - Добавление опыта в семью",
    "/oi - Мини-троллинг",
    "/uptop - Принудительно обновить рейтинги",
    "/gpci - Бан по железу (/gpci [id] [2]) - опасно!",
    "/addbiz - Создать бизнес",
    "/klad - Телепорт к кладу",
    "/squest - Изменить прогресс заданий у игрока",
    "/alogs - Версия 2.0",
    "/captchalog - Логирование ввода капчи",
    "/server - Статистика сервера + мини-настройки",
    "/settings - Настройки цен и прочего для /donate (опасно)"
}
local commands9 = {
    "/fixmysql - Исправление чтения базы данных при '?????'",
    "/reloadnews - Принудительная загрузка новостей сервера",
    "/unawarn - Снятие выговоров администратором",
    "/arip - Полная блокировка разом (IP,аккаунт,железо) ОПАСНО!",
    "/addquest - Всеобщая доступность квестов(/quest) ОПАСНО!",
    "/age - Установка даты рождения игроков",
    "/oi - Тролинг игрока который приведет к кику через 5 минут",
    "/gzcolor - Возможность перекрашивать гетто",
    "/mtest - Взаимодействие на расстоянии (замена ALT+ПКМ)",
    "/prizeyear - Чисто прикол",
    "/addbiz - Создание бизнесов ОПАСНО!",
    "/aobj2 - Выдача уникальных предметов самому себе",
    "/iinfo - Узнать название любого предмета по номеру (от 311 до 645)",
    "/bank - Использовать возможности банка на расстоянии",
    "/setsale - Открыть/закрыть распродажу на админки",
    "/finditem - Найди название предмета по словам"
}


local updateid
function threadHandle(runner, url, args, resolve, reject)
    local t = runner(url, args)
    local r = t:get(0)
    while not r do
        r = t:get(0)
        wait(0)
    end
    local status = t:status()
    if status == 'completed' then
        local ok, result = r[1], r[2]
        if ok then resolve(result) else reject(result) end
    elseif err then
        reject(err)
    elseif status == 'canceled' then
        reject(status)
    end
    t:cancel(0)
end

function requestRunner()
    return effil.thread(function(u, a)
        local https = require 'ssl.https'
        local ok, result = pcall(https.request, u, a)
        if ok then
            return {true, result}
        else
            return {false, result}
        end
    end)
end

function async_http_request(url, args, resolve, reject)
    local runner = requestRunner()
    if not reject then reject = function() end end
    lua_thread.create(function()
        threadHandle(runner, url, args, resolve, reject)
    end)
end

function encodeUrl(str)
    str = str:gsub(' ', '%+')
    str = str:gsub('\n', '%%0A')
    return u8:encode(str, 'CP1251')
end

function sendTelegramNotification(msg) -- функция для отправки сообщения юзеру
    msg = msg:gsub('{......}', '') --тут типо убираем цвет
    msg = encodeUrl(msg) -- ну тут мы закодируем строку
    async_http_request('https://api.telegram.org/bot' .. ini.telegramtc.token .. '/sendMessage?chat_id=' .. ini.telegramtc.chat_id .. '&text='..msg,'', function(result) end) -- а тут уже отправка
end

function get_telegram_updates() -- функция получения сообщений от юзера
    while not updateid do wait(1) end -- ждем пока не узнаем последний ID
    local runner = requestRunner()
    local reject = function() end
    local args = ''
    while true do
        url = 'https://api.telegram.org/bot'..ini.telegramtc.token..'/getUpdates?chat_id='..ini.telegramtc.chat_id..'&offset=-1' -- создаем ссылку
        threadHandle(runner, url, args, processing_telegram_messages, reject)
        wait(0)
    end
end

function processing_telegram_messages(result) -- функция проверОчки того что отправил чел
    if result then
        -- тута мы проверяем все ли верно
        local proc_table = decodeJson(result)
        if proc_table.ok then
            if #proc_table.result > 0 then
                local res_table = proc_table.result[1]
                if res_table then
                    if res_table.update_id ~= updateid then
                        updateid = res_table.update_id
                        local message_from_user = res_table.message.text
                        if message_from_user then
                            -- и тут если чел отправил текст мы сверяем
                            local text = u8:decode(message_from_user) .. ' ' --добавляем в конец пробел дабы не произошли тех. шоколадки с командами(типо чтоб !q не считалось как !qq)
                            if text:match('^!qq') then
                                sendTelegramNotification(u8:decode('Ку'))
                            elseif text:match('^!q') then
                                sendTelegramNotification(u8:decode('Привет!'))
                            elseif text:match('^!online') then
                                online = sampGetPlayerCount(false)
                                sendTelegramNotification(u8:decode('Онлайн на сервере: '..online))
                                for g = 0, online+1 do
                                    wait(100)
                                        nickp = sampGetPlayerNickname(g)
                                        if (sampIsPlayerConnected(id)) then
                                            sendTelegramNotification(u8:decode('Игрок: '..nickp..'['..g..']'))
                                        else
                                            sendTelegramNotification(u8:decode('Игрок с идом ['..g..'] не найден'))
                                        end
                                end
                            elseif text:match('^!send') then
                                local arg = text:gsub('!send%s','',1) -- вот так мы получаем аргумент команды
                                    if #arg > 0 then
                                    sampSendChat(arg)
                                end
                            else -- если же не найдется ни одна из команд выше, выведем сообщение
                                sendTelegramNotification(u8:decode('Неизвестная команда!'))
                            end
                        end
                    end
                end
            end
        end
    end
end

function getLastUpdate() -- тут мы получаем последний ID сообщения, если же у вас в коде будет настройка токена и chat_id, вызовите эту функцию для того чтоб получить последнее сообщение
    async_http_request('https://api.telegram.org/bot'..ini.telegramtc.token..'/getUpdates?chat_id='..ini.telegramtc.chat_id..'&offset=-1','',function(result)
        if result then
            local proc_table = decodeJson(result)
            if proc_table.ok then
                if #proc_table.result > 0 then
                    local res_table = proc_table.result[1]
                    if res_table then
                        updateid = res_table.update_id
                    end
                else
                    updateid = 1 -- тут зададим значение 1, если таблица будет пустая
                end
            end
        end
    end)
end


function sampev.onServerMessage(color, text)
    if act then
        local playerid2 = select(2,sampGetPlayerIdByCharHandle(PLAYER_PED))
        local name = sampGetPlayerNickname(playerid2)
        if text:find(u8:decode("к%s") .. name ) then
            table.insert(messages, u8(text))
            notify.addNotification(string.format(u8:decode("Новое сообщение\n\n %s"), text), 30)
            sendTelegramNotification(text)
            addOneOffSound(0.0, 0.0, 0.0, 1054)
        end
        if text:find(u8:decode("@") .. name ) then
            sendTelegramNotification(text)
        end
        if text:find(u8:decode("для%s".. name)) then
            sendTelegramNotification(text)
        end
        if text:find(u8:decode("Администратор%s".. "Svyatik_Mironov%s".. "кикнул")) or text:find(u8:decode("Администратор%s".. "svyatik_mironov".. "кикнул")) then
            sendTelegramNotification(text)
        end
        if text:find(u8:decode("Администратор%s".. "Svyatik_Mironov%s".. "забанил")) or text:find(u8:decode("Администратор%s".. "svyatik_mironov".. "забанил")) then
            sendTelegramNotification(text)
        end
        if text:find(u8:decode("Администратор%s".. "Devin_Martynov%s".. "кикнул")) or text:find(u8:decode("Администратор%s".. "devin_martynov".. "кикнул")) then
            sendTelegramNotification(text)
        end
        if text:find(u8:decode("Администратор%s".. "Devin_Martynov%s".. "забанил")) or text:find(u8:decode("Администратор%s".. "devin_martynov%s".. "забанил")) then
            sendTelegramNotification(text)
        end
        if text:find(u8:decode("Администратор%s".. "Ywo_Legend%s".. "кикнул")) or text:find(u8:decode("Администратор%s".. "ywo_legend%s".. "кикнул")) then
            sendTelegramNotification(text)
        end
        if text:find(u8:decode("Администратор%s".. "Ywo_Legend%s".. "забанил")) or text:find(u8:decode("Администратор%s".. "ywo_legend%s".. "забанил")) then
            sendTelegramNotification(text)
        end
    end
end

function sampGetListboxItemText(str, item)
    local num_ = 0
    for str in string.gmatch(str, "[^\r\n]+") do
        if item == num_ then return str end
        num_ = num_ + 1
    end
    return false
end
function sampGetListboxItemsCount(text2)
    local i = 0
    for _ in text2:gmatch(".-\n") do
        i = i + 1
    end
    return i
end

function sampev.onShowDialog(id, s, t, b1, b2 ,text2)
    if status then
        lua_thread.create(function()
        for i=1, sampGetListboxItemsCount(text2)-1 do
            if sampGetListboxItemText(text2, i):find(u8:decode('Охлаждающая')) then
                sampSendDialogResponse(id, 1, i-1, _)
                sampSendDialogResponse(sampGetCurrentDialogId(), 1, nil, nil)
                wait(1000)
                sampSendDialogResponse(sampGetCurrentDialogId(), 1, nil, nil)
                sampCloseCurrentDialogWithButton(0)
            end
            status = false
        end
    end)
    end
    if status1 then
        lua_thread.create(function()
            for i=1, sampGetListboxItemsCount(text2)-1 do
                if sampGetListboxItemText(text2, i):find(u8:decode('Смазка')) then
                    sampSendDialogResponse(id, 1, i-1, _)
                    sampSendDialogResponse(sampGetCurrentDialogId(), 1, nil, nil)
                    wait(1000)
                    sampSendDialogResponse(sampGetCurrentDialogId(), 1, nil, nil)
                    sampCloseCurrentDialogWithButton(0)
                end
                status1 = false
            end
        end)
    end
end

function fatality()
    local i = select(2,sampGetPlayerIdByCharHandle(PLAYER_PED))
    local fatality = string.format(sampGetPlayerNickname(i) .. sampGetPlayerScore(i) .. i)
    return fatality
end

function getPlayerCoordinatesFixed()
    local x, y, z = getCharCoordinates(PLAYER_PED)
    if not x or not y or not z then return false end
    requestCollision(x, y)
    loadScene(x, y, z)
    local x, y, z = getCharCoordinates(PLAYER_PED)
    return true, x, y, z
end

function imgui.TextQuestion(label, description)
    imgui.TextDisabled(label)

    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
            imgui.PushTextWrapPos(600)
                imgui.TextUnformatted(description)
            imgui.PopTextWrapPos()
        imgui.EndTooltip()
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

function sampev.onSetPlayerHealth(health)
    local playerid = select(2,sampGetPlayerIdByCharHandle(PLAYER_PED))
    health = 8000100-8000000
    if health < 8000030 and hp == true then
        sampSendChat('/hp ' .. playerid)
    end
    if health ~= 8000000 and hp == true then
        lua_thread.create(function()
        hp = false
        wait(6000)
        hp = true
        end)
    end
end

imgui.OnInitialize(function()
    SoftBlueTheme()
    if ini.telegramtc.theme == 0 then
        theme[colorListNumber[0]+1].change()
    end
    if ini.telegramtc.theme == 1 then
        theme[colorListNumber[0]+2].change()
    end
    if ini.telegramtc.theme == 2 then
        theme[colorListNumber[0]+3].change()
    end
    if ini.telegramtc.theme == 3 then
        theme[colorListNumber[0]+4].change()
    end
    if ini.telegramtc.theme == 4 then
        theme[colorListNumber[0]+5].change()
    end
    if ini.telegramtc.theme == 5 then
        theme[colorListNumber[0]+6].change()
    end
    if ini.telegramtc.style == 0 then
        style[styleListNumber[0]+1].change()
    end
    if ini.telegramtc.style == 1 then
        style[styleListNumber[0]+2].change()
    end
    if ini.telegramtc.style == 2 then
        style[styleListNumber[0]+3].change()
    end
    if ini.telegramtc.style == 3 then
        style[styleListNumber[0]+4].change()
    end
    if ini.telegramtc.hp == false then
        checkboxone[0] = false
        hp = false
    end
    if ini.telegramtc.hp == true then
        checkboxone[0] = true
        hp = true
    end

end)

imgui.OnFrame(function() return WinState[0] end, function(player)
    imgui.Begin('Fatality', WinState, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoBringToFrontOnFocus)
    if imgui.BeginTabBar('Tabs') then
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
            imgui.SameLine()
            imgui.SetCursorPos(imgui.ImVec2(155, 80.0))
            imgui.Checkbox('Авто-ХП', checkboxone)
            if checkboxone[0] == true then
                ini.telegramtc.hp = true
                inicfg.save(ini,IniFilename)
                hp = true
            else
                ini.telegramtc.hp = false
                inicfg.save(ini,IniFilename)
                hp = false
            end
            if imgui.IsItemHovered() then
                imgui.BeginTooltip()
                imgui.Text('Восполняет хп, если у вас меньше 30 хп')
                imgui.EndTooltip()
            end
            if imgui.Combo('Темы',colorListNumber,colorListBuffer, #colorList) then
                theme[colorListNumber[0]+1].change()
                ini.telegramtc.theme = colorListNumber[0]
                inicfg.save(ini, IniFilename)
            end
            if imgui.Combo('Стили',styleListNumber,styleListBuffer, #styleList) then
                style[styleListNumber[0]+1].change()
                ini.telegramtc.style = styleListNumber[0]
                inicfg.save(ini, IniFilename)
            end
            if imgui.Button('Обновить скрипт') then
                update()
            end
                imgui.BeginChild("ChatLog", imgui.ImVec2(checkx[0], checky[0]), true)      
                for _, msg in ipairs(messages) do
                    imgui.TextWrapped(msg)
                end
                imgui.EndPopup()
                imgui.SetCursorPos(imgui.ImVec2(checkx[0]-485, checky[0]+230))
            if imgui.Button('Очистить') then
                messages = {}
            end
            imgui.SetCursorPos(imgui.ImVec2(checkx[0]-400, checky[0]+230.5))
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
            imgui.SameLine()
            imgui.SetCursorPos(imgui.ImVec2(210, 377))
            imgui.TextQuestion("(?)", "Author: Harry_Pattersone")
            imgui.EndTabItem()
        end
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
                if imgui.Button('Закрыть', imgui.ImVec2(280, 30)) then
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
                if imgui.Button('Закрыть', imgui.ImVec2(280, 30)) then
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
            if imgui.Button('Очистить аксы') then
                sampSendChat('/reset')
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
                imgui.EndPopup()
            end
            imgui.EndTabItem()
        end
        if imgui.BeginTabItem('Команды') then
            if dostup[0] == false then
                imgui.InputText('Пароль', password,256)
                local inputp = charArrayToString(password,256)
                if imgui.Button('Принять') then
                    if inputp == fatality() then
                        dostup[0] = true
                    end
                end
            else
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
                imgui.SameLine()
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
                imgui.SameLine()
                if imgui.Button('4 АКЛ') then
                    imgui.OpenPopup('4 ACL')
                end
                if imgui.BeginPopup('4 ACL') then
                    imgui.BeginChild('CommandList', imgui.ImVec2(500, 350), true)
                    for i, command in ipairs(commands4) do
                        imgui.TextUnformatted(command)
                    end
                    imgui.EndChild()
                    if imgui.Button('Закрыть', imgui.ImVec2(280, 24)) then
                        imgui.CloseCurrentPopup()
                    end
                    imgui.EndPopup()
                end
                if imgui.Button('5 АКЛ') then
                    imgui.OpenPopup('5 ACL')
                end
                if imgui.BeginPopup('5 ACL') then
                    imgui.BeginChild('CommandList', imgui.ImVec2(500, 350), true)
                    for i, command in ipairs(commands5) do
                        imgui.TextUnformatted(command)
                    end
                    imgui.EndChild()
                    if imgui.Button('Закрыть', imgui.ImVec2(280, 24)) then
                        imgui.CloseCurrentPopup()
                    end
                    imgui.EndPopup()
                end
                imgui.SameLine()
                if imgui.Button('6 АКЛ') then
                    imgui.OpenPopup('6 ACL')
                end
                if imgui.BeginPopup('6 ACL') then
                    imgui.BeginChild('CommandList', imgui.ImVec2(500, 350), true)
                    for i, command in ipairs(commands6) do
                        imgui.TextUnformatted(command)
                    end
                    imgui.EndChild()
                    if imgui.Button('Закрыть', imgui.ImVec2(280, 24)) then
                        imgui.CloseCurrentPopup()
                    end
                    imgui.EndPopup()
                end
                if imgui.Button('7 АКЛ') then
                    imgui.OpenPopup('7 ACL')
                end
                if imgui.BeginPopup('7 ACL') then
                    imgui.BeginChild('CommandList', imgui.ImVec2(500, 350), true)
                    for i, command in ipairs(commands7) do
                        imgui.TextUnformatted(command)
                    end
                    imgui.EndChild()
                    if imgui.Button('Закрыть', imgui.ImVec2(280, 24)) then
                        imgui.CloseCurrentPopup()
                    end
                    imgui.EndPopup()
                end
                imgui.SameLine()
                if imgui.Button('8 АКЛ') then
                    imgui.OpenPopup('8 ACL')
                end
                if imgui.BeginPopup('8 ACL') then
                    imgui.BeginChild('CommandList', imgui.ImVec2(500, 350), true)
                    for i, command in ipairs(commands8) do
                        imgui.TextUnformatted(command)
                    end
                    imgui.EndChild()
                    if imgui.Button('Закрыть', imgui.ImVec2(280, 24)) then
                        imgui.CloseCurrentPopup()
                    end
                    imgui.EndPopup()
                end
                if imgui.Button('9 АКЛ') then
                    imgui.OpenPopup('9 ACL')
                end
                if imgui.BeginPopup('9 ACL') then
                    imgui.BeginChild('CommandList', imgui.ImVec2(500, 350), true)
                    for i, command in ipairs(commands9) do
                        imgui.TextUnformatted(command)
                    end
                    imgui.EndChild()
                    if imgui.Button('Закрыть', imgui.ImVec2(280, 24)) then
                        imgui.CloseCurrentPopup()
                    end
                    imgui.EndPopup()
                end
        
            end
            imgui.EndTabItem()
        end
        if imgui.BeginTabItem('Телеграм') then
            imgui.InputText('Token', tokenbuffer, 256)
            token = charArrayToString(tokenbuffer,256)
            imgui.InputText('chatid', chatidbuffer, 256)
            chat_id = charArrayToString(chatidbuffer,256)
            if imgui.Button('Сохранить') then
                ini.telegramtc.token = token
                ini.telegramtc.chat_id = chat_id
                sampAddChatMessage('Token: ' .. ini.telegramtc.token,-1)
                sampAddChatMessage('Chat_Id: ' .. ini.telegramtc.chat_id,-1)
                sampAddChatMessage('Путь: ' .. IniFilename,-1)
                inicfg.save(ini, IniFilename)
            end
            imgui.Text('Команды:')
            imgui.Text('В TG:\n!send - отправит в чат ваше сообщение. (Например !send /pm 5 q)\n!online - отобразит онлайн на сервере,\nа также выведет всех игроков с их идом(БЕТА, может крашить скрипт)')
            imgui.Text('В игре:\nПри любом упоминание(/pm, /ans, /sms, @Ваш_ник) прийдёт уведомление в телеграмм')
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
end

function main()
    sampRegisterChatCommand('savec',function()
        local bool, x, y, z = getPlayerCoordinatesFixed()
            if bool then
                savedCoordinates.x = x
                savedCoordinates.y = y
                savedCoordinates.z = z
            end
    end)
    sampRegisterChatCommand('tpc', function()
        if savedCoordinates.x and savedCoordinates.y and savedCoordinates.z then
            setCharCoordinates(PLAYER_PED, savedCoordinates.x, savedCoordinates.y, savedCoordinates.z)
        end
    end)
    sampRegisterChatCommand('vd',function()
        status = not status
        if status then
            sampSendChat('/i')
        end
    end)
    sampRegisterChatCommand('vd1',function()
        status1 = not status1
        if status1 then
            sampSendChat('/i')
        end
    end)


    lua_thread.create(get_telegram_updates)
        getLastUpdate()

    while true do
        wait(0)
        if wasKeyPressed(VK_R) and not sampIsCursorActive() then
            WinState[0] = not WinState[0]
        end
    end
end
