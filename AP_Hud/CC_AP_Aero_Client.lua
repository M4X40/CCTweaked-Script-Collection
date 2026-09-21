-- HUD script by M4X4.
-- Made for CC AdvancedPeripherals Smart Glasses

local CHANNEL = 115

while true do
  -- HUD Setup
  local mod = peripheral.find("modem")
  mod.open(CHANNEL)

  if not smartglasses.modules['advancedperipherals:overlay'] then
    error('No overlay module')
  else
    hud = smartglasses.modules['advancedperipherals:overlay']
  end

  local event, side, channel, replyChannel, message, distance
  repeat
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
  until channel == CHANNEL

  print("Received a reply: " .. tostring(message))

  testText = {
    x = 5,
    y = 5,
    z = 5,
    content = message,
    center = false
  }
  hud.createText(testText)
end