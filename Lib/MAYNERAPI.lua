local component = require("component")
local event = require("event")
local gpu = component.gpu
local screen = component.screen
local computer = require("computer")

MAYNERAPI = {}

local buttonW = 20
local buttonH = 1

local function isWithinButton(x, y, bx, by, bw, bh)
    return x >= bx and x < bx + bw and y >= by and y < by + bh
end

function MAYNERAPI.DrawButton(x1, y1, width, height, text, foreground, background, callback)
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
    
   while true do
    event.pull("touch")
   end
end

function MAYNERAPI.Message(title, message, oldcolor) ----Добавил Мой Друг)
    local width = math.max(30, #message + 10)
    local height = 7  -- Fixed height for simplicity
    local x = math.floor((gpu.getResolution() - width) / 2)
    local y = math.floor((25 - height) / 2)
    
    gpu.setBackground(0x333333)
    gpu.fill(x, y, width, height, " ")

    -- Calculate text position
    local titleX = x + math.floor((width - #title) / 2)
    local titleY = y + 1
    local messageX = x + math.floor((width - #message) / 2)
    local messageY = y + 3

    gpu.setForeground(0xFFFFFF)  -- White text
    gpu.set(titleX, titleY, title)
    gpu.set(messageX, messageY, message)

    local buttonWidth = width - 4
    local buttonHeight = 1
    local buttonX = x + 2
    local buttonY = y + height - 2
    gpu.setBackground(0x333333) 
    gpu.setForeground(0xFFFFFF)
    gpu.fill(buttonX, buttonY, buttonWidth, buttonHeight, " ")
    gpu.set(buttonX + (buttonWidth - 6) / 2, buttonY, "OK")

    -- Event handler for closing the message box
    local function check(_, _, x2, y2)
        if x2 >= buttonX and x2 < buttonX + buttonWidth and y2 == buttonY then
            gpu.setBackground(oldcolor)
            gpu.fill(x, y, width, height, " ")
            event.ignore("touch", check)
        end
    end

while true do
    event.pull("touch")
   end
end
return MAYNERAPI
