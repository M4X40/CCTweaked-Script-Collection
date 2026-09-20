core = peripheral.find("end_automata")

success, msg = core.savePoint("test1")

local i = 1
repeat
  turtle.forward()
  i = i + 1
until i = 20
