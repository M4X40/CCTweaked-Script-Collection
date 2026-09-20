core = peripheral.find("end_automata")

success, msg = core.savePoint("test1")
print(success)
print(msg)

local i = 1
repeat
  turtle.forward()
  i = i + 1
until i == 20

success, msg = core.warpToPoint("test1")
print(success)
print(msg)