local component = require("component")
local event = require("event")
local filesystem = require("filesystem")
local GUI = require("GUIE")
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

-- ВИДЮХА!!! паси свиней)))

gpu.setResolution(80,25)

local function drawButton(x, y, width, height, text, foreground, background)
  gpu.setForeground(foreground)
  gpu.setBackground(background)
  gpu.fill(x, y, width, height, " ")
  local textX = x + math.floor((width - #text) / 2)
  local textY = y + math.floor(height / 2)
  gpu.set(textX, textY, text)
end

-- Функция для вывода КАКОВАТА ГАДА
local function message(str)
  gpu.setForeground(0xFFFFFF)
  gpu.setBackground(0x000000)
  gpu.fill(1, 1, 80, 25, " ")
  gpu.set(1, 1, str)
end

-- ФуНкЦиЯ ДлЯ ПоСеДеЛоК
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
    print "OpenPenguin maded by matveymayner and DanXvoIsMe"
  elseif command == "5" then
   -- error for exit to ТаК НаЗЫВАЕМЫЙ ДОССС С ЧЁРНО. Ой не туда пошло
   shell.execute("cls")
    return
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

-- Функция для запуска игры Flappy Bird
local function runFlappyBird()
      shell.execute("flappybird.lua")
end

-- Функция для запуска игры Snake
local function runSnake()
      shell.execute("Snake.lua")
end

-- Очищаем экран
gpu.setForeground(0xFFFFFF)
gpu.setBackground(0x0000FF)
gpu.fill(1, 1, 80, 25, " ")

MakeButton(10, 2, 12, 3, "Shutdown", 0xFFFFFF, 0x555555)
MakeButton(24, 2, 12, 3, "Reboot", 0xFFFFFF, 0x555555)
MakeButton(38, 2, 15, 3, "Random Number", 0xFFFFFF, 0x555555)
MakeButton(55, 2, 12, 3, "OpenOS", 0xFFFFFF, 0x555555)
MakeButton(69, 2, 12, 3, "Info", 0xFFFFFF, 0x555555)

MakeButton(10, 5, 12, 3, "Flappy Bird", 0xFFFFFF, 0x555555)
MakeButton(24, 5, 12, 3, "Snake", 0xFFFFFF, 0x555555)

MakeButton(38, 5, 12, 3, "File Manager", 0xFFFFFF, 0x555555)

MakeButton(55, 5, 12, 3, "AppShop", 0xFFFFFF, 0x555555)




-- ОЖИДАЕМ НАЖАТИЯ КОЖЕНОГО
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
    if x >= 10 and x <= 21 then
      shell.execute("flappybird.lua")
    elseif x >= 24 and x <= 35 then
      shell.execute("Snake.lua")
    elseif x >= 38 and x <= 49 then
      shell.execute("fileman.lua")
     elseif x >= 55 and x <= 66 then
      -- Запустить AppЖоп
      shell.execute("AppShop.lua")
    end
  elseif y == 24 and x >= 1 and x <= 9 then
    -- Обработка команд для нижней полоски
    message("Choose an option:\n1. Create Folder\n2. Create File\n3. Rename Item\n4. Edit File")
    local _, _, _, _, _, option = event.pull("key_down")
    if option == 2 then
      createFolder()
    elseif option == 3 then
      createFile()
    elseif option == 4 then
      renameItem()
    elseif option == 5 then
      editFile()
    end
  elseif y == 24 and x >= 69 and x <= 80 then
    openCommandLine()
  end
end
