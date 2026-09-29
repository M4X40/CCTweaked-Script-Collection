-- Replace blocks in a customizable grid
-- by M4X4

-- Argument stuff
local args = { ... }
if #args ~= 4 then
  return
end
local l = args[1]
local w = args[2]
local before = args[3]
local after = args[4]

-- Temp variables for knowing where the turtle is during runtime
local currentL = 0
local currentW = 0
local backward = false

-- Misc functions
function findItem(block)
  for i=1,16 do
    local item = turtle.getItemDetail(i)
    if item ~= nil then
      if item and item.name == after then return i end
      print("Item is "..item.name..", not "..after)
    end
  end
  return 0
end



-- Movement functions
function ground()
  local act = nil
  local err = nil
  while err ~= "Movement obstructed" do
    act,err = turtle.down()
  end
end

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

  ground()
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
  ground()
end

function forwards()
  refuel()

  ground()
  local act,err = turtle.forward()
  if err == "Movement obstructed" then
    hill(false)
  end
  ground()
end

function backwards()
  refuel()

  ground()
  local act,err = turtle.back()
  if err == "Movement obstructed" then
    hill(true)
  end
  ground()
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
    turtle.select(16)
    turtle.refuel(turtle.getItemDetail()["count"])
  end
end



-- Logic functions
function line()
  while currentL < tonumber(l) do
    local isBlock, Block = turtle.inspectDown()

    if isBlock and (Block.name == before or (before == "*" and Block.name ~= after)) then
      local slot = findBlock(after)
      if slot ~= 0 and slot ~= nil then
        turtle.digDown()
        turtle.select(slot)
        turtle.placeDown()
      end
    end
    currentL = currentL + 1

    if currentL ~= tonumber(l) then
      move()
      ground()
    end
  end
end

function main()
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
main()