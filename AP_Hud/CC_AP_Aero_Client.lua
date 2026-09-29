-- HUD script by M4X4.
-- Made for CC AdvancedPeripherals Smart Glasses

local CHANNEL = 115

function init ()
  mod = peripheral.find("modem")
  mod.open(CHANNEL)

  if not smartglasses.modules['advancedperipherals:overlay'] then
    error('No overlay module')
  else
    hud = smartglasses.modules['advancedperipherals:overlay']
  end
end

function writeText (objName, x, y, content, center)
  if _G[objName] ~= nil then
    print("Updating "..objName)
    _G[objName].setPos(x, y, 1)
    _G[objName].setContent(content)
    _G[objName].setCenter(center)
  else
    print("Creating "..objName)
    local data = {
      x = x,
      y = y,
      z = 1,
      content = content,
      center = center
    }
    _G[objName] = hud.createText(data)
  end
end

function main ()
  while true do
    -- HUD Setup

    local event, side, channel, replyChannel, message, distance
    repeat
      event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == CHANNEL
    -- This is a funny test message

    local screenW, screenH, scale = hud.getGuiSize()
    local w = screenW / scale
    local h = screenH / scale

    -- testText = {
    --   x = w / 2,
    --   y = h / 2,
    --   z = 1,
    --   content = message,
    --   center = true
    -- }
    writeText("testText", w / 2, h / 2, message, true)
    print(testText[content])
    -- hud.setAutoUpdate(true)
    -- hasRun = true
  end
end

init()
main()