----------------------------------------------   Установщик взят из MineOS спасибо ECS'у   ----------------------------------------------
local fs = require("filesystem")
local component = require("component")
local computer = require("computer")
local unicode = require("unicode")
local shell = require("shell")
local gpu = component.gpu
local screen = component.screen

local reasons = {}

if not _G._OSVERSION or tonumber(_G._OSVERSION:sub(8, 10)) < 1.5 then
	table.insert(reasons, "Old version of OpenComputers mod detected: OpenPenguin requires OpenComputers 1.5 or newer to work properly.")
end

if component.isAvailable("tablet") then
	table.insert(reasons, "Tablet PC detected: OpenPenguin can't be installed on tablets.")
end

if screen.setPrecise and screen.setPrecise(false) == nil then
	table.insert(reasons, "Low-tier screen detected: OpenPenguin requires Tier 3 screen to work properly.")
else
	if gpu.maxResolution() < 160 then
		table.insert(reasons, "Low-tier GPU detected: OpenPenguin requires Tier 3 GPU to work properly.")
	end
end

if computer.totalMemory() < 2097152 then
	table.insert(reasons, "Not enough RAM: OpenPenguin requires at least 2MB (2x Tier 3.5 RAM modules) to work properly.")
end

if #reasons > 0 and not options.skiphardwarecheck and not options.s then
	print(" ")
	for i = 1, #reasons do
		print(reasons[i])
		print(" ")
	end
	
	return
end

-------------------------------------------------   Дальше Уже Сам Делаю!   ---------------------------------------------------------------

local buttonW = 20
local buttonH = 1

local function isWithinButton(x, y, bx, by, bw, bh)
    return x >= bx and x < bx + bw and y >= by and y < by + bh
end

function DrawButton(x1, y1, width, height, text, foreground, background, callback)
    gpu.setForeground(foreground)
    gpu.setBackground(background)
    gpu.fill(x1, y1, width, height, " ")
    local textX = x1 + math.floor((width - #text) / 2)
    local textY = y1 + math.floor(height / 2)
    gpu.set(textX, textY, text)
    
    local function check(_, _, x2, y2)
        if isWithinButton(x2, y2, x1, y1, width, height) then
            callback()
        end
    end
    
    event.listen("touch", check)
end

--------------   ЭКСперементируем   --------------
--gpu.setResolution(80, 25)
gpu.setForeground(0x000000)
gpu.setBackground(0x808080)
gpu.fill(1, 1, 160, 50, " ")
---------------------------------------------------

DrawButton(2, 12, 3, "Установить - Install", 0xFFFFFF, 0x555555, function()
shell.execute("pastebin run yERLsQNq")
 end)

while true do
    event.pull("touch")
end
