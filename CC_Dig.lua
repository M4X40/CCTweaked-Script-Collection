-- Dig out blocks in a customizable grid
-- by M4X4

-- Argument stuff
local args = { ... }
if #args ~= 3 then
  return
end
local l = args[1]
local w = args[2]
local d = args[3]

-- Temp variables for knowing where the turtle is during runtime
local currentL = 0
local currentW = 0
local currentD = 0
local backward = false

function findItem(it)
  for i=1,16 do
    local item = turtle.getItemDetail(i)
    if item ~= nil then
      if item and item.name == it then
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
    while currentD < tonumber(d) do
      local isBlock, Block = turtle.inspectDown()
      if isBlock then
        turtle.digDown()
        currentD = currentD + 1
        if currentD ~= tonumber(d) then
          refuel()
          turtle.down()
        end
      elseif currentD == 0 then
        break
      end
    end
    currentL = currentL + 1

    -- while currentD - 1 ~= 0 do
    --   turtle.up()
    --   currentD = currentD - 1
    -- end

    currentD = 0

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
    currentD = 0
    currentW = currentW + 1
    if currentW ~= tonumber(w) then
      turtle.turnRight()
      forwards()
      turtle.turnLeft()
    end
    backward = not backward
    -- move()
  end
end

-- Init
print("Running DIG with Length="..l..", Width="..w..", Depth="..d)
main()