-- Стырил эту годноту из HIPOSAV это просто рил топ прога

local image = require("image")
local ecs = require("ECSAPI")
local c = require("component")
local unicode = require("unicode")
local computer = require("computer")
local event = require("event")
local context = require("context")
local screen = c.screen
local gpu = c.gpu

-- Define colors
local colors = {
    topBar = 0xdddddd,
    main = 0xffffff,
    closes = {cross = 0xCC4C4C, hide = 0xDEDE6C, full = 0x57A64E},
    topText = 0x262626,
    topButtons = 0xffffff,
    topButtonsText = 0x262626,
}

-- Top bar buttons
local topButtons = {"О системе", "Диски"}
local spaceBetweenTopButtons, offsetTopButtons = 2, 2
local currentMode = 1

-- Load images
local hddIcon = image.load("/bin/HDD.pic")
local floppyIcon = image.load("/bin/Floppy.pic")
local updateIcon = image.load("/bin/Update.pic")

-- Set initial coordinates and dimensions
local x, y = "auto", "auto"
local width, height = 68, 22
x, y = ecs.correctStartCoords(x, y, width, height)
local heightOfTopBar = 3

-- Get RAM info
local ram = {}
ram.free, ram.total, ram.used = ecs.getInfoAboutRAM()

-- Set initial HDD display
local drawHDDFrom = 1
local HDDs
local bootAddress = computer.getBootAddress()

-- Variables for updates
local updates, oldApps
local drawUpdatesFrom = 1
local xUpdatesList, yUpdatesList
local countOfChoses

-- Create objects table
local obj = {}
local function newObj(class, name, ...)
    obj[class] = obj[class] or {}
    obj[class][name] = {...}
end

-- Draw the top bar close buttons
local function drawCloses()
    local symbol = "▓"
    gpu.setBackground(colors.topBar)
    local yPos = y
    ecs.colorText(x + 1, yPos, colors.closes.cross, symbol)
    ecs.colorText(x + 3, yPos, colors.closes.hide, symbol)
    ecs.colorText(x + 5, yPos, colors.closes.full, symbol)
    newObj("Closes", 1, x + 1, yPos, x + 1, yPos)
    newObj("Closes", 2, x + 3, yPos, x + 3, yPos)
    newObj("Closes", 3, x + 5, yPos, x + 5, yPos)
end

-- Draw the top bar
local function drawTopBar()
    -- Draw the top bar itself
    ecs.square(x, y, width, heightOfTopBar, colors.topBar)
    -- Draw the close buttons
    drawCloses()
    -- Draw the title
    -- local text = topButtons[currentMode]
    -- ecs.colorText(x + math.floor(width / 2 - unicode.len(text) / 2), y, colors.topText, text)
    -- Draw the top buttons
    local widthOfButtons = 0
    for i = 1, #topButtons do
        widthOfButtons = widthOfButtons + unicode.len(topButtons[i]) + spaceBetweenTopButtons + offsetTopButtons * 2
    end
    local xPos, yPos = x + math.floor(width / 2 - widthOfButtons / 2), y + 1
    for i = 1, #topButtons do
        local color1, color2 = colors.topButtons, colors.topButtonsText
        if i == currentMode then color1, color2 = ecs.colors.blue, 0xffffff end
        newObj("TopButtons", i, ecs.drawAdaptiveButton(xPos, yPos, offsetTopButtons, 0, topButtons[i], color1, color2))
        xPos = xPos + unicode.len(topButtons[i]) + spaceBetweenTopButtons + offsetTopButtons * 2
        color1, color2 = nil, nil
    end
end

-- Draw the updates list
local function drawUpdatesList()
    local selectSymbol, nonSelectSymbol = "✔", "  "
    local limit = 40
    local xPos, yPos = xUpdatesList, yUpdatesList

    -- Clear the list area
    ecs.square(xPos, yPos, limit + 2, 15, colors.main)

    for i = drawUpdatesFrom, (drawUpdatesFrom + 4) do
        if not updates[i] then break end
        -- Draw the checkbox
        ecs.border(xPos, yPos, 5, 3, colors.main, 0x262626)
        -- Draw the checkmark
        if updates[i].needToUpdate then
            ecs.colorText(xPos + 2, yPos + 1, 0x880000, selectSymbol)
            countOfChoses = countOfChoses + 1
        end
        -- Draw the update text
        local text = "§f" .. (fs.name(updates[i].name) or updates[i].name) .. (function() if updates[i].needToUpdate then return "§e, версия ".. updates[i].version .." (новее)" else return "§8, версия ".. updates[i].version end end)()
        ecs.smartText(xPos + 6, yPos + 1, ecs.stringLimit("end", text, limit))
        text = nil
        yPos = yPos + 3
    end

    -- Draw the scrollbar
    ecs.srollBar(x + width - 3, y + heightOfTopBar + 2, 1, 15, #updates, drawUpdatesFrom, 0xdddddd, ecs.colors.blue)
end

-- Draw the main content
local function drawMain()
    ecs.square(x, y + heightOfTopBar, width, height - heightOfTopBar, colors.main)
    local xPos, yPos
    if currentMode == 1 then
        xPos, yPos = x + 1, y + heightOfTopBar + 1
        ecs.colorTextWithBack(xPos, yPos, 0x000000, colors.main, "OpenPenguin"); yPos = yPos + 1
        ecs.colorText(xPos, yPos, ecs.colors.lightGray, "Версия 1.2"); yPos = yPos + 2

        ecs.smartText(xPos, yPos, "§fСистемный блок §8(Нормальный)"); yPos = yPos + 1
        ecs.smartText(xPos, yPos, "§fПроцессор §8(Для серьезных задач)"); yPos = yPos + 1
        ecs.smartText(xPos, yPos, "§fПамять §8(DDR5 с охлаждением "..ram.total.." KB)"); yPos = yPos + 1
        ecs.smartText(xPos, yPos, "§fГрафика §8(Для работ и игр)"); yPos = yPos + 1
        ecs.smartText(xPos, yPos, "§fСерийный номер §8"..ecs.stringLimit("end", computer.address(), 30)); yPos = yPos + 1
    elseif currentMode == 2 then
        obj["HDDControls"] = {}
        yPos = y + heightOfTopBar + 1
        HDDs = ecs.getHDDs()
        for i = drawHDDFrom, (drawHDDFrom + 3) do
            if not HDDs[i] then break end
            xPos = x + 2
            -- Draw the correct disk image
            if HDDs[i].isFloppy == true then image.draw(xPos, yPos, floppyIcon) else image.draw(xPos, yPos, hddIcon) end
            -- Draw the text
            xPos = xPos + 10
            gpu.setBackground(colors.main)
            local load = ""
            if bootAddress == HDDs[i].address then load = " §eзагрузочный§8," end
            ecs.smartText(xPos, yPos, ecs.stringLimit("end", "§f" .. (HDDs[i].label or "Безымянный диск") .. "§8,"..load.." " .. HDDs[i].address, 58)); yPos = yPos + 2
            -- Draw the progress bar
            local percent = math.ceil(HDDs[i].spaceUsed / HDDs[i].spaceTotal * 100)
            ecs.progressBar(xPos, yPos, 40, 1, 0xdddddd, ecs.colors.blue, percent)
            yPos = yPos + 1
            ecs.colorTextWithBack(xPos + 10, yPos, 0xaaaaaa, colors.main, HDDs[i].spaceUsed.." из "..HDDs[i].spaceTotal.." KB использовано"); yPos = yPos + 1
            ecs.separator(x, yPos, width - 1, colors.main, 0xdddddd)
           
