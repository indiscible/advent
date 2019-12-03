import strutils
let wire="R8,U5,L5,D3"
echo wire.split(",")
var grid = initTable[int[2],int]

proc line(pos: int[2], dir: int[2], length: int, id: int)=
  for i in 0..length:
    grid[ pos + i*dir ] = id

let dir = { "U": [0,1], "D":[0,-1], "R":[1,0], L:[-1,0]}.toTable    
for cmd in wire:

  line( [0,0], dir[cmd[0]], parseInt(cmd[1]),
  for i in 0..length:
    grid[ pos + i*dir ] = id
  
  case cmd[0]
  of "R": gri
    
