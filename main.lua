local component = require("component")
local event = require("event")
local os = require("os")
local gpu = component.gpu

gpu.setResolution(80, 25)

local function drawLoadingBar()
  local barWidth = 50
  local barHeight = 1
  local barX = math.floor((80 - barWidth) / 2)
  local barY = 13

  gpu.setForeground(0xFFFFFF)
  gpu.setBackground(0x000000)
  gpu.fill(barX, barY, barWidth, barHeight, " ")

  local progress = 0
  while progress <= barWidth do
    gpu.setForeground(0xFFFFFF)
    gpu.setBackground(0xFFFFFF)
    gpu.fill(barX, barY, progress, barHeight, " ")
    gpu.setForeground(0x000000)
    gpu.setBackground(0x000000)
    gpu.fill(barX + progress, barY, 1, barHeight, " ")

    os.sleep(0.05)
    progress = progress + 1
  end
end

gpu.setForeground(0xFFFFFF)
gpu.setBackground(0x808080)
gpu.fill(1, 1, 160, 50, " ")

gpu.setBackground(0x808080)
gpu.setForeground(0xFFFFFF)
gpu.set(34, 12, "OpenPenguin")

drawLoadingBar()

local component = require("component")
local event = require("event")
local filesystem = require("filesystem")
local gpu = component.gpu
local computer = require("computer")
local os = require("os")
local mayner = require("MAYNERAPI")
local prog = require("program")

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

gpu.setResolution(80, 25)
gpu.setForeground(0x000000)
gpu.setBackground(0x808080)
gpu.fill(1, 1, 80, 25, " ")


mayner.DrawButton(10, 2, 12, 3, "Shutdown", 0xFFFFFF, 0x555555, function()
    handleCommand("1")
 end)

mayner.DrawButton(24, 2, 12, 3, "Reboot", 0xFFFFFF, 0x555555, function()
    handleCommand("2")
end)

mayner.DrawButton(38, 2, 15, 3, "Random Number", 0xFFFFFF, 0x555555, function()
    handleCommand("3")
end)

mayner.DrawButton(55, 2, 12, 3, "OpenOS", 0xFFFFFF, 0x555555, function()
    handleCommand("4")
end)

mayner.DrawButton(69, 2, 12, 3, "Info", 0xFFFFFF, 0x555555, function()
    handleCommand("5")
end)

mayner.DrawButton(10, 5, 12, 3, "Flappy Bird", 0xFFFFFF, 0x555555, function()
    shell.execute("bin/flappybird.lua")
end)

mayner.DrawButton(24, 5, 12, 3, "Snake", 0xFFFFFF, 0x555555, function()
    shell.execute("bin/Snake.lua")
end)

mayner.DrawButton(38, 5, 12, 3, "File Manager", 0xFFFFFF, 0x555555, function()
    shell.execute("fileman.lua")
end)

mayner.DrawButton(55, 5, 12, 3, "AppShop", 0xFFFFFF, 0x555555, function()
    shell.execute("cls")
    shell.execute("AppShop.lua")
end)

--DrawButton(69, 5, 12, 3, "Settings", 0xFFFFFF, 0x555555, function()
--    shell.execute("bin/Control.lua")
--end)

gpu.setBackground(0xFFFFFF)
gpu.setForeground(0x000000)
gpu.fill(1, 23, 80, 2, " ")
gpu.set(34, 24, "OpenPenguin")

-- Крч Фигня чтобы держать систему в графике, а не в консоле!
while true do
    event.pull("touch")
end
