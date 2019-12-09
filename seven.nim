import computer
import sequtils

proc run(code:string,phase:openArray[int],debug=false):int=
  foldl(phase, runSeq(code,@[b,a],debug), 0)

let tests=[
  ("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0",@[4,3,2,1,0],43210),
  ("3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0",@[0,1,2,3,4],54321),
  ("3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0",@[1,0,4,3,2],65210)
]

for (c,p,o) in tests:
  echo c," ",p," ",o,"==",run(c,p)
  assert(run(c,p,true)==o)
    
proc splat(n: int):array[5,int]=
    var
      x = n
      d = 10000
    for i in 0..4:
      result[i] = int(x/d)
      x = x - result[i]*d
      d = int(d/10)

let code= tests[0][0]

proc maxfirst[T](x:seq[(int,T)]):(int,T)=
  var
    idx= 0
    m= x[idx]
  for (i,v) in x.pairs:
    if v[0]>m[0]:
      idx=i
      m=v
  return m
  
import Sets
  
proc optim(code:string):(int,array[5,int])=
  let r = toHashSet [0, 1, 2, 3, 4]
  var x:seq[(int,array[5,int])]
  for a in r:
    for b in r-([a].toHashSet):
      for c in r-([a,b].toHashSet):
        for d in r-([a,b,c].toHashSet):
          for e in r-([a,b,c,d].toHashSet):
            x.add (run(code,[a,b,c,d,e]), [a,b,c,d,e])
  return maxfirst(x)

for (c,p,o) in tests:
  echo optim(c)

echo optim(readFile("seven.txt"))

let t1=("3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5",[9,8,7,6,5],139629729)
let t2=("3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10",[9,7,8,5,6],18216)

proc feedback(code:seq[int],phases:seq[int]):int=
  var c= code
  var amps:seq[State]
  for p in phases:
    amps.add (c,0,0,@[p])  

  # phases
  for amp in amps.mitems:
    amp = run(amp)

  #boot
  var prevout=0
  while true:
    var dead= 0
    for i in 0..4:
      amps[i].inout= @[prevout]
      if amps[i].pc>=0:
        amps[i] = run( amps[i])
        prevout= amps[i].inout.pop
      else:
        dead.inc
#    echo amps
    if dead==5: break
  return prevout

assert(t1[2]== feedback(parse(t1[0]),@(t1[1])))
assert(t2[2]== feedback(parse(t2[0]),@(t2[1])))

proc optim2(code:string):(int,array[5,int])=
  let r = toHashSet [5, 6, 7, 8, 9]
  var x:seq[(int,array[5,int])]
  var ccc= parse(code)
  for a in r:
    for b in r-([a].toHashSet):
      for c in r-([a,b].toHashSet):
        for d in r-([a,b,c].toHashSet):
          for e in r-([a,b,c,d].toHashSet):
            x.add (feedback(ccc,@[a,b,c,d,e]), [a,b,c,d,e])
  return maxfirst(x)

echo optim2(t1[0])
echo optim2(t2[0])
echo optim2(readFile("seven.txt"))
