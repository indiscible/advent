import strutils
import sequtils
import strformat

type Instr = tuple[a:bool,b:bool,c:bool,op:int]

proc decode(n: var int): Instr =
  result.c= bool(n/10000)
  if (result.c): n.dec(10000)
  result.b= bool(n/1000)
  if (result.b): n.dec(1000)
  result.a= bool(n/100)
  if (result.a): n.dec(100)
  result.op= n
#  echo (n,result)

proc read(mem:seq[int], val: int, imm: bool):int=
  if (imm):
    return val
  return mem[val]


  
proc run(code: string, ID: int=1, debug: bool=false):int =
#  let delta= [0, 4, 4, 
  var p = strip(code).split(",").map(parseInt)
  var pc = 0
  while p[pc]!=99:
    let
      instr = decode(p[pc])
      a = p[pc+1]
      pa = read(p, a, instr.a)
    var pb,c:int
    if not (instr.op in [3,4]):
        pb = read(p, p[pc+2], instr.b)
    if instr.op in [1, 2, 7, 8]:
        c = p[pc+3]
    case instr.op
     of 1: p[c] = pa + pb
     of 2: p[c] = pa * pb
     of 3: p[a] = ID
     of 4: result = pa
     of 5:
       if pa>0: pc = pb - 3
     of 6:
       if pa==0: pc = pb - 3
     of 7:
       if pa<pb: p[c]= 1
       else: p[c]= 0
     of 8:
       if pa==pb: p[c]= 1
       else: p[c]= 0
     else: raiseAssert(fmt"code {p[pc]} line {pc}: invalid op {instr}")
    pc += [0, 4, 4, 2, 2, 3, 3, 4, 4][int(instr.op)]
    if debug: echo (pc,p,a, pb, c)

assert(23423 == run("3,0,4,0,99",23423))
assert(0== run("1002,4,3,4,33"))
assert(0 == run("1101,100,-1,4,0"))
echo "five:", run(readFile("five.txt"))
assert(run("3,9,8,9,10,9,4,9,99,-1,8",8)==1)
assert(run("3,9,7,9,10,9,4,9,99,-1,8",7)==1)
assert(run("3,3,1108,-1,8,3,4,3,99",8)==1)
assert(run("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9")==1)
assert(run("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99",80)==1001)

echo "five: ", run(readFile("five.txt"),5)
