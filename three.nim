import tables
import strutils
import algorithm
type X = tuple[x:int,y:int]
type Grid = Table[X,tuple[c:char,t:int]]
proc run(wire: string):Grid=
  let
    dir = { 'R':(1,0), 'L':(-1,0), 'U':(0,1), 'D':(0,-1)}.toTable
    sig = { 'R':'-', 'L':'-', 'U':'|', 'D':'|' }.toTable
  var
    p= (x:0,y:0)
    time= 0
  result = initTable[X, (char,int)]()
  for cmd in wire.split(","):
    let
      d= dir[cmd[0]]
      l= parseInt cmd[1..^1]
    for i in 0..l-1:
      p[0] = p[0] + d[0]
      p[1] = p[1] + d[1]
      time = time + 1
      result[p]= (sig[cmd[0]],time)
    result[p]=('+',time)

import sequtils,sugar
proc draw(g: Table[X,char])=
  let
    ks = toSeq(g.keys)
    (xs, ys)= (ks.mapIt(it.x), ks.mapIt(it.y))
    (xmin, ymin) = (min(xs)-2, min(ys)-2)
    (xlen, ylen) = (max(xs) - xmin + 2, max(ys) - ymin + 2)
  var m = newSeqWith(ylen, repeat('.',xlen))
  m[-ymin][-xmin]= 'O'
  for k,v in g:
    m[k.y-ymin][k.x-xmin]=v
  echo m.join("\n")

import Sets

proc cross(w1: string, w2: string):int=
  let
    (p1,p2) = (run(w1),run(w2))
    (k1,k2) = (toSeq p1.keys, toSeq p2.keys)
  #draw(p1)
  var inter = toSeq intersection(toHashSet k1, toHashSet k2)
  proc dist(p:tuple[x:int,y:int]):int=abs(p.x)+abs(p.y)
  sort(inter, (x,y)=>dist(x)>dist(y))
  let spot= inter[0]
  echo spot, " dist:" , dist(spot)
  var timings= inter.map(k=>(p1[k].t+p2[k].t,k))
  sort(timings, (x,y)=>x[0]>y[0])
  echo timings[0]
  return timings[0][0]

var p = run("R8,U5,L5,D3")
echo toSeq(p.keys).mapIt(it.x)
echo cross("R8,U5,L5,D3","U7,R6,D4,L4")
echo cross("R75,D30,R83,U83,L12,D49,R71,U7,L72","U62,R66,U55,R34,D71,R55,D58,R83")
echo cross("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51","U98,R91,D20,R16,D67,R40,U7,R15,U6,R7")

var wires=toSeq lines("three.txt")
echo cross(wires[0], wires[1])



