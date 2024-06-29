local component = require("component")
local event = require("event")
local filesystem = require("filesystem")
local gpu = component.gpu
local ecs = require("ECSAPI")
local computer = require("computer")
local shell = require("shell")
local os = require("os")

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

local function message(str)
    gpu.setForeground(0x000000)
    gpu.setBackground(0x000000)
    gpu.fill(1, 1, 80, 25, " ")
    gpu.set(1, 1, str)
end

local function handleCommand(command)
    if command == "1" then
        message("Shutting down...")
        os.sleep(2)
        computer.shutdown()
    elseif command == "2" then
        message("Rebooting...")
        os.sleep(2)
        computer.shutdown(true)
    elseif command == "3" then
        message("Random number: " .. tostring(math.random(1, 100)))
    elseif command == "4" then
        shell.execute("cls")
        os.exit()
    elseif command == "5" then
        shell.execute("cls")
        print("OpenPenguin made by matveymayner and DanXvoIsMe")
    elseif command == "6" then
        message("Are you sure you want to shutdown the computer? (y/n)")
        while true do
            local _, _, _, _, _, response = event.pull("key_down")
            if response == 21 then
                message("Shutting down...")
                os.sleep(2)
                computer.shutdown()
            elseif response == 49 then
                message("Shutdown aborted.")
                os.sleep(2)
                break
            end
        end
    elseif command == "Flappy Bird" then
        message("Starting Flappy Bird...")
        os.sleep(2)
        runFlappyBird()
    elseif command == "Snake" then
        message("Starting Snake...")
        os.sleep(2)
        runSnake()
    elseif command == "Settings" then
        message("Starting Settings...")
        os.sleep(2)
        runSettings()
    else
        message("Invalid command.")
        os.sleep(2)
    end
end

local function runFlappyBird()
    shell.execute("bin/flappybird.lua")
end

local function runSnake()
    shell.execute("bin/Snake.lua")
end

local function runSettings()
    shell.execute("bin/Control.lua")
end

-----------    Делаем только под видюхи 3-тего уровня  ---------------

--gpu.setResolution(80, 25)
gpu.setForeground(0x000000)
gpu.setBackground(0x808080)
gpu.fill(1, 1, 160, 50, " ")

-----------------------------------------------------------------------

DrawButton(10, 2, 12, 3, "Shutdown", 0xFFFFFF, 0x555555, function()
    handleCommand("1")
 end)

DrawButton(24, 2, 12, 3, "Reboot", 0xFFFFFF, 0x555555, function()
    handleCommand("2")
end)

DrawButton(38, 2, 15, 3, "Random Number", 0xFFFFFF, 0x555555, function()
    handleCommand("3")
end)

DrawButton(55, 2, 12, 3, "OpenOS", 0xFFFFFF, 0x555555, function()
    handleCommand("4")
end)

DrawButton(69, 2, 12, 3, "Info", 0xFFFFFF, 0x555555, function()
    handleCommand("5")
end)

DrawButton(10, 5, 12, 3, "Flappy Bird", 0xFFFFFF, 0x555555, function()
    shell.execute("bin/flappybird.lua")
end)

DrawButton(24, 5, 12, 3, "Snake", 0xFFFFFF, 0x555555, function()
    shell.execute("bin/Snake.lua")
end)

DrawButton(38, 5, 12, 3, "File Manager", 0xFFFFFF, 0x555555, function()
    shell.execute("fileman.lua")
end)

DrawButton(55, 5, 12, 3, "AppShop", 0xFFFFFF, 0x555555, function()
    shell.execute("cls")
    shell.execute("AppShop.lua")
end)

DrawButton(69, 5, 12, 3, "Settings", 0xFFFFFF, 0x555555, function()
    shell.execute("bin/Control.lua")
end)

gpu.setBackground(0xFFFFFF)
gpu.setForeground(0x000000)
gpu.fill(1, 78, 160, 2, " ")
gpu.set(34, 24, "OpenPenguin")

-- Крч Фигня чтобы держать систему в графике, а не в консоле!
while true do
    event.pull("touch")
end
