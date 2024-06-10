local component = require("component")
local event = require("event")
local gpu = component.gpu

os.execute("wget -f https://raw.githubusercontent.com/matvey-mayner/OpenPenguin/main/autorun.lua")
os.execute("wget -f https://raw.githubusercontent.com/matvey-mayner/OpenPenguin/main/SYS32.lua")
shell.execute("cls")

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
gpu.fill(1, 1, 80, 25, " ")

gpu.setBackground(0x808080)
gpu.setForeground(0xFFFFFF)
gpu.set(34, 12, "OpenPenguin")

drawLoadingBar()

dofile("SYS32.lua")
