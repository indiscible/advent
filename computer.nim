import strutils
import sequtils
import strformat

type Instr = tuple[a:int,b:int,c:int,op:int]

proc decode(m: int): Instr =
  var n = m
  result.c= int(n/10000)
  n.dec(result.c*10000)
  result.b= int(n/1000)
  n.dec(result.b*1000)
  result.a= int(n/100)
  n.dec(result.a*100)
  result.op= n
#  echo (n,result)

proc translate(mem: var seq[int], val: int, mode: int, base: int):int=
  var val2= val
  if mode==2: val2.inc base
  if val2>=len(mem):
    echo "resizing to ", 2*val2
    setLen(mem,2*val2)
  return val2

proc write(mem: var seq[int], where: int, mode: int, base: int, what: int)=
  if mode==1: raiseAssert(fmt"writing in immediate mode!!")
  let val2 = translate(mem, where, mode, base)
  mem[val2]= what
  
proc read(mem: var seq[int], val: int, mode: int, base: int):int=
  if mode==1: return val
  let val2= translate(mem, val, mode, base)
  return mem[val2]

import algorithm

type State* = tuple[p:seq[int],pc:int,base:int,inout:seq[int]]
  
proc run*(s:State, debug: bool=false):State =
  var
    p= s.p
    pc = s.pc
    input = reversed s.inout
    base = s.base
    output : seq[int]
  while p[pc]!=99:
    let
      instr = decode(p[pc])
      a = p[pc+1]
      pa = read(p, a, instr.a, base)
    var pb,c:int
    if not (instr.op in [3,4]):
        pb = read(p, p[pc+2], instr.b, base)
    if instr.op in [1, 2, 7, 8]:
        c = p[pc+3]
#    if debug: echo (p,pc,instr,a,pa,pb,c,p[c])
    case instr.op
     of 1:
       write(p, c, instr.c, base, pa + pb)
       if debug: echo fmt" {c} <- {pa} + {pb} = {p[c]}" 
     of 2:
       write(p, c, instr.c, base, pa * pb)
       if debug: echo fmt" {c} <- {pa} * {pb} = {p[c]}" 
     of 3:
       if len(input)>0:
         write(p, a, instr.a, base, input.pop)
         if debug: echo fmt"{a} <-  {p[a]}"
       else:
         return (p,pc,base,output)
     of 4:
       if debug: echo fmt"out= {pa}"
       output.add pa
     of 5:
       if pa>0: pc = pb - 3
     of 6:
       if pa==0: pc = pb - 3
     of 7:
       if pa<pb: write(p, c, instr.c, base, 1)
       else: write(p, c, instr.c, base, 0)
     of 8:
       if pa==pb: write(p, c, instr.c, base, 1)
       else: write(p, c, instr.c, base, 0)
     of 9:
       if debug: echo fmt"{base} <- {base} + {pa} = {base+pa}"
       base = base + pa
     else: raiseAssert(fmt"code {p[pc]} line {pc}: invalid op {instr}")
    pc += [0, 4, 4, 2, 2, 3, 3, 4, 4, 2][int(instr.op)]
#    if debug: echo (pc,p,a, pb, c)
  return (p,-1,base,output)

proc parse*(code:string):seq[int]= strip(code).split(",").map(parseInt)

proc runSeq*(code:string, input: seq[int], debug:bool):int=
  var state:State= run((parse(code), 0, 0, input),debug)
  return state.inout.pop

proc run(code:string, ID:int=1, debug:bool=false):int= runSeq(code, @[ID], debug)

assert(23423 == run("3,0,4,0,99",23423))
#echo "five:", run(readFile("five.txt"))
assert(run("3,9,8,9,10,9,4,9,99,-1,8",8)==1)
assert(run("3,9,7,9,10,9,4,9,99,-1,8",7)==1)
assert(run("3,3,1108,-1,8,3,4,3,99",8)==1)
assert(run("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9")==1)
assert(run("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99",80)==1001)

#echo "five: ", run(readFile("five.txt"),5)
