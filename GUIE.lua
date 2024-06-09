local module = {}

local component = require("component")
local gpu = component.gpu
local event = require("event")

local buttons = {}

module.testButton = function(x, y)
  for id,button in pairs(fgui.buttons) do
      if x >= button.x1 and x <= button.x2 and y >= button.y1 and y <= button.y2 then
          return id
      end
  end
  return nil
end

module.buttonTouch = function(x, y, buttonName)
  return module.testButton(x, y) == buttonName
end

function module.MakeButton(id, x, y, width, height, text, callback, foreground, background)
  gpu.setForeground(foreground)
  gpu.setBackground(background)
  gpu.fill(x, y, width, height, " ")
  local textX = x + math.floor((width - #text) / 2)
  local textY = y + math.floor(height / 2)
  gpu.set(textX, textY, text)
  buttons[id] = { x1 = x, y1 = y, x2 = width, y2 = height}
  local buttonOnTouch = function(_, _, x, y, button, player)
    if module.buttonTouch(x, y, id) then
        callback(id, player, button)
    end
  end
  event.listen("touch", buttonOnTouch)
end

return module
