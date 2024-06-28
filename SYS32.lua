local component = require("component")
local event = require("event")
local filesystem = require("filesystem")
local GUI = require("GUIE")
local ECS = require("ECSAPI")
local image = require("image")
--local oboii = image.load("bin/oboi.png")
local gpu = component.gpu
local computer = require("computer")
local shell = require("shell")
local os = require("os")

local buttonW = 20
local buttonH = 1
local keysConvertTable = {
    rcontrol = "ctrl",
    lcontrol = "ctrl",
}
local hotkeys = {
    ["delete"] = {
        action = {"DELETE"},
    },
    ["ctrl"] = {
        ["e"] = {
            action = {"EDIT"},
            ["delete"] = {
                action = {"DELETE","EDIT"},
            }
        }
    }
}

-- Устанавливаем разрешение экрана
gpu.setResolution(80, 25)

--pcall(proxy.setLabel, "OpenPenguin")

local function isWithinButton(x, y, bx, by, bw, bh)
    return x >= bx and x < bx + bw and y >= by and y < by + bh
end

-- Function to draw the button and set up the event listener
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
    print "OpenPenguin maded by matveymayner and DanXvoIsMe"
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

gpu.setForeground(0x000000)
gpu.setBackground(0x808080)
gpu.fill(1, 1, 80, 25, " ")
--image.draw(0, 0, oboii)

--DrawButton(10, 2, 12, 3, "Shutdown", 0xFFFFFF, 0x555555)
--DrawButton(24, 2, 12, 3, "Reboot", 0xFFFFFF, 0x555555)
--DrawButton(38, 2, 15, 3, "Random Number", 0xFFFFFF, 0x555555)
--DrawButton(55, 2, 12, 3, "OpenOS", 0xFFFFFF, 0x555555)
--DrawButton(69, 2, 12, 3, "Info", 0xFFFFFF, 0x555555)

--DrawButton(10, 5, 12, 3, "Flappy Bird", 0xFFFFFF, 0x555555)
--DrawButton(24, 5, 12, 3, "Snake", 0xFFFFFF, 0x555555)
--DrawButton(38, 5, 12, 3, "File Manager", 0xFFFFFF, 0x555555)
--DrawButton(55, 5, 12, 3, "AppShop", 0xFFFFFF, 0x555555)
--DrawButton(69, 5, 12, 3, "Settings", 0xFFFFFF, 0x555555)

gpu.setBackground(0xFFFFFF)
gpu.setForeground(0x000000)
gpu.fill(1, 23, 80, 2, " ")
gpu.set(34, 24, "OpenPenguin")

local function isWithinButton(x, y, bx, by, bw, bh)
  return x >= bx and x < bx + bw and y >= by and y < by + bh
end

 DrawButton(10, 2, 12, 3, "Shutdown", 0xFFFFFF, 0xFF00FF, function()
    handleCommand("1")
 end)

DrawButton(24, 2, 12, 3, "Reboot", 0xFFFFFF, 0xFF00FF, function()
    handleCommand("2")
end)

DrawButton(38, 2, 15, 3, "Random Number", 0xFFFFFF, 0xFF00FF, function()
    handleCommand("3")
end)

DrawButton(55, 2, 12, 3, "OpenOS", 0xFFFFFF, 0xFF00FF, function()
    handleCommand("4")
end)

DrawButton(69, 2, 12, 3, "Info", 0xFFFFFF, 0xFF00FF, function()
    handleCommand("5")
end)

DrawButton(10, 5, 12, 3, "Flappy Bird", 0xFFFFFF, 0xFF00FF, function()
    shell.execute("bin/flappybird.lua")
end)

DrawButton(24, 5, 12, 3, "Snake", 0xFFFFFF, 0xFF00FF, function()
    shell.execute("bin/Snake.lua")
end)

DrawButton(38, 5, 12, 3, "File Manager", 0xFFFFFF, 0xFF00FF, function()
    shell.execute("fileman.lua")
end)

DrawButton(55, 5, 12, 3, "AppShop", 0xFFFFFF, 0xFF00FF, function()
    shell.execute("cls")
    shell.execute("AppShop.lua")
end)

DrawButton(69, 5, 12, 3, "AppShop", 0xFFFFFF, 0xFF00FF, function()
    shell.execute("bin/Control.lua")
end)

while True then
    event.pull("touch")
end
