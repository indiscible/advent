import tables
import strutils
let wire="R8,U5,L5,D3"
#var grid = { (0,0):1, (0,1):2 }.toTable
#echo grid
var grid = initTable[(int,int), char]()
let dir = { 'R':(1,0), 'L':(-1,0), 'U':(0,1), 'D':(0,-1)}.toTable
let sig = { 'R':'-', 'L':'-', 'U':'|', 'D':'|' }.toTable
var p= (0,0)
for cmd in wire.split(","):
  let
    d= dir[cmd[0]]
    l= parseInt cmd[1..1]
  grid[p]='+'
  for i in 0..l:
    p[0] = p[0] + d[0]
    p[1] = p[1] + d[1]
    grid[p]= sig[cmd[0]]

const x0 = 32
var v = (1,2)
var x: array[3,int] = [1, 2, 3]
var y: seq[int]
import sequtils,sugar

proc bbox(x: seq[int]):(int,int)= (min(x), max(x)-min(x))
block:
  let
    ks = toSeq(grid.keys)
    (xs, ys)= (ks.map(x => x[0]), ks.map(x => x[1]))
    (xmin, ymin) = (min(xs), min(ys))
    (xlen, ylen) = (max(xs) - xmin, max(ys) - ymin)
  var m = newSeqWith(ylen, repeat('.',xlen))
  echo (xmin, ymin)
  m[-xmin][-ymin]= 'O'
  echo m.join("\n")

type Coord = array[2,int]
proc `+` (a: Coord, b: Coord): Coord = [a[0]+b[0], a[1] + b[1]]
      
