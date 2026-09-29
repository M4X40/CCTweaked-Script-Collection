-- Place blocks in a customizable grid
-- by M4X4

-- Argument stuff
local args = { ... }
if #args ~= 3 then
  return
end
local l = args[1]
local w = args[2]
local block = args[3]

-- Temp variables for knowing where the turtle is during runtime
local currentL = 0
local currentW = 0
local backward = false

function findItem(it)
  for i=1,16 do
    local item = turtle.getItemDetail(i)
    if item ~= nil then
      if item and item.name:find("^"..it) ~= nil then
        print("Found "..it)
        return i
      end
    end
  end
  return 0
end

-- Movement functions
function hill(isBackward)
  local act = nil
  local err = nil

  if isBackward == nil then
    isBackward = backward
  end

  if isBackward then
    refuel()
    act,err = turtle.back()
  else
    refuel()
    act,err = turtle.forward()
  end

  while err == "Movement obstructed" do
    turtle.up()
    if isBackward then
      refuel()
      act,err = turtle.back()
    else
      refuel()
      act,err = turtle.forward()
    end
  end
end

function move()
  refuel()

  local act = nil
  local err = nil
  if backward then
    act,err = turtle.back()
  else
    act,err = turtle.forward()
  end
  if err ~= nil and err == "Movement obstructed" then
    hill()
  end
end

function forwards()
  refuel()

  local act,err = turtle.forward()
  if err == "Movement obstructed" then
    hill(false)
  end
end

function backwards()
  refuel()

  local act,err = turtle.back()
  if err == "Movement obstructed" then
    hill(true)
  end
end

function toStart()
  turtle.turnLeft()
  for i=1,w-1 do
    forwards()
  end
  turtle.turnRight()
  if w % 2 ~= 0 then
    for i=1,l-1 do
      backwards()
    end
  else
    backward = false
  end
end

function refuel()
  if turtle.getFuelLevel() == 0 then
    local slot = 0
    print("Waiting for coal")
    while slot == 0 do
      slot = findItem("minecraft:coal")
    end
    turtle.select(slot)
    turtle.refuel(1)
  end
end

-- Logic functions
function line()
  while currentL < tonumber(l) do
    local isBlock, Block = turtle.inspectDown()
    if not isBlock then
      local slot = findItem(block)
      repeat
        slot = findItem(block)
      until slot ~= 0 and slot ~= nil
      turtle.select(slot)
      turtle.placeDown()
    end
    currentL = currentL + 1

    if currentL ~= tonumber(l) then
      move()
    end
  end
end

function main()
  refuel()
  while currentW < tonumber(w) do
    line(backward)
    currentL = 0
    currentW = currentW + 1
    if currentW ~= tonumber(w) then
      turtle.turnRight()
      forwards()
      turtle.turnLeft()
    end
    backward = not backward
    -- move()
  end
  toStart()
end

-- Init
print("Running PLACE with Length="..l..", Width="..w..", Placing \""..block.."\"")
main()