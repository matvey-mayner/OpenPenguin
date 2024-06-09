local component = require("component")
local event = require("event")
local filesystem = require("filesystem")
local GUI = require("GUIE")
local computer = require("computer")
local shell = require("shell")
local os = require("os")

-- Видюха КРУТИСЬ!!!

gpu.setResolution(80,25)

-- СООБЩЕНИЯ СООБЩЕСТВА

local function message(str)
  gpu.setForeground(0xFFFFFF)
  gpu.setBackground(0x808080)
  gpu.fill(1, 1, 80, 25, " ")
  gpu.set(1, 1, str)
end

-- КоМАнДиКи ГрУзИтЕсЬ

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
      shell.execute("/init.lua")
    end
  elseif command == "5" then
      shell.execute("Info.lua")
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
  else
    message("Invalid command.")
    os.sleep(2)
  end
end

local function runFlappyBird()
      shell.execute("flappybird.lua")
end

local function runSnake()
      shell.execute("Snake.lua")
end

gpu.setForeground(0xFFFFFF)
gpu.setBackground(0x808080)
gpu.fill(1, 1, 80, 25, " ")

MakeButton(10, 2, 12, 3, "Shutdown", 0xFFFFFF, 0x555555)
MakeButton(24, 2, 12, 3, "Reboot", 0xFFFFFF, 0x555555)
MakeButton(38, 2, 15, 3, "Random Number", 0xFFFFFF, 0x555555)
MakeButton(55, 2, 12, 3, "Exit To OpenOS", 0xFFFFFF, 0x555555)
MakeButton(69, 2, 12, 3, "Info", 0xFFFFFF, 0x555555)
MakeButton(10, 5, 12, 3, "Flappy Bird", 0xFFFFFF, 0x555555)
MakeButton(24, 5, 12, 3, "Snake", 0xFFFFFF, 0x555555)
MakeButton(38, 5, 12, 3, "File Manager", 0xFFFFFF, 0x555555)

-- Ожидаем нажатия кнопки
while true do
  local _, _, x, y = event.pull("touch")
  if y == 2 then
    -- Обработка команд для первого ряда кнопок
    if x >= 10 and x <= 21 then
      handleCommand("1")
    elseif x >= 24 and x <= 35 then
      handleCommand("2")
    elseif x >= 38 and x <= 52 then
      handleCommand("3")
    elseif x >= 55 and x <= 66 then
      handleCommand("4")
    elseif x >= 69 and x <= 80 then
      handleCommand("5")
    end
  elseif y == 5 then
    -- Обработка команд для второго ряда кнопок
    if x >= 10 and x <= 21 then
      shell.execute("flappybird.lua")
    elseif x >= 24 and x <= 35 then
      shell.execute("Snake.lua")
    elseif x >= 38 and x <= 49 then
      shell.execute("files.lua")
      else
    message("Invalid command.")
    os.sleep(2)
  end
end

gpu.setBackground(0xFFFFFF)
gpu.setForeground(0x000000)
gpu.fill(1, 23, 80, 2, " ")
gpu.set(34, 24, "OpenPenguin")
