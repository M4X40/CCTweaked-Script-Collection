-- HUD script by M4X4.
-- Made for CC AdvancedPeripherals Smart Glasses

function roundUp (num)
  return math.ceil(num)
end

function round3 (num)
  return string.format("%.3f",num)
end

function clamp (num, min, max)
  return math.max(math.min(num, max), min)
end

local mod = peripheral.find("modem")

local alt = peripheral.find("altitude_sensor")
local nav = peripheral.find("navigation_table")
local vel = peripheral.find("velocity_sensor")
local gim = peripheral.find("gimbal_sensor")

-- hud.setSize(160, 90)
-- hud.setHudFit("cover")

while true do
  sleep(0.01)
  local height = alt.getHeight()
  local pressure = alt.getAirPressure()
  local ySpeed = alt.getVerticalSpeed()

  local dist = nav.getDistanceToTarget()
  local xSpeed = nav.getClosureRate()

  local velo = math.abs(vel.getVelocity())

  local pitch = roundUp(gim.getAngles()[1])
  local roll = roundUp(gim.getAngles()[2])
  local rollRad = gim.getAnglesRad()[2]

  local eta = roundUp(dist/xSpeed)
  if tonumber(eta) == math.huge or (velo == 0 and ySpeed == 0) then
    eta = 0
  end

  local posText = "Height: "..roundUp(height).." | Pressure: "..round3(pressure)
  local velText = "Horizonal Speed: "..roundUp(velo).."b/s | Vertical Speed: "..roundUp(ySpeed).."b/s"
  local navText = "Distance: "..roundUp(dist).." | ETA: "..eta.."s"

  -- local w, h = hud.getSize()

  local posTextX = math.floor((w - #posText) / 2)
  local posTextY = math.floor((h / 2)) - 24
  local velTextX = math.floor((w - #velText) / 2)
  local velTextY = math.floor((h / 2)) - 23
  local navTextX = math.floor((w - #navText) / 2)
  local navTextY = math.floor((h / 2)) - 22

  -- hud.setBackgroundColour(0)
  -- hud.setTextColour(colors.cyan)
  -- hud.clear()
  
  -- hud.setCursorPos(posTextX, posTextY)
  -- hud.write(posText)
  
  -- hud.setCursorPos(velTextX, velTextY)
  -- hud.write(velText)

  if nav.hasTarget() then
    -- hud.setCursorPos(navTextX, navTextY)
    -- hud.write(navText)
  end

  local orientationBaseY = 60

  -- ROLL LINE
  local rollPad = 95
  local rollLength = w - 2 * rollPad
  local rollRadius = rollLength / 2

  local cx = w / 2
  local cy = h / 2

  local dx = rollRadius * math.cos(rollRad)
  local dy = rollRadius * math.sin(rollRad)

  local rollStartX = math.floor(cx - dx + 0.5)
  local rollEndX = math.floor(cx + dx + 0.5)
  local rollStartY = clamp((math.floor(cy - dy + 10.5)), orientationBaseY - 11, orientationBaseY + 1)
  local rollEndY = clamp((math.floor(cy + dy + 10.5)), orientationBaseY - 11, orientationBaseY + 1)

  local oldTerm = term.redirect(hud)
  paintutils.drawLine(rollStartX, rollStartY, rollEndX, rollEndY, colors.green)

  -- PITCH LINE
  local pitchStartX = (w / 2) - 10
  local pitchEndX = (w / 2) + 10
  local pitchOffset = math.floor(((clamp(pitch, -90, 90) + 90) / 18) + 0.5)
  -- paintutils.drawLine(pitchStartX, orientationBaseY + 1, pitchEndX, orientationBaseY + 1, colors.red)
  -- paintutils.drawLine(pitchStartX, orientationBaseY - pitchOffset, pitchEndX, orientationBaseY - pitchOffset, colors.lime)
  -- paintutils.drawLine(pitchStartX, orientationBaseY - 11, pitchEndX, orientationBaseY - 11, colors.red)
  term.redirect(oldTerm)

  -- DEBUG TEXT
  -- hud.setBackgroundColour(0)
  -- hud.setTextColour(colors.cyan)
  local debugText = "Debug: "..nav.getTargetType()
  local debugTextX = 1
  local debugTextY = math.floor(h / 2) + 5
  -- hud.setCursorPos(debugTextX, debugTextY)
  -- hud.write(debugText)
end