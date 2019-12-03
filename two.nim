import strutils
import sequtils
import strformat
proc parse(code:string):seq[int] = strip(code).split(",").map(parseInt)

proc run(pp:seq[int]):int =
  var p = pp
  var pc = 0
  while p[pc]!=99:
    let
      op = p[pc]
      a = p[pc+1]
      b = p[pc+2]
      c = p[pc+3]
    case op
     of 1: p[c] = p[a] + p[b]
     of 2: p[c] = p[a] * p[b]
     else: raiseAssert(fmt"line {pc}: invalid op {op}")
    pc += 4
#  echo p
  return p[0]


echo run(parse("1,9,10,3,2,3,11,0,99,30,40,50"))
echo run(parse("1,0,0,0,99"))
echo run(parse("2,3,0,3,99"))
echo run(parse("2,4,4,5,99,0"))
echo run(parse("1,1,1,4,99,5,6,0,99"))

let code= parse readFile "two.txt"
block main:
  for noun in 0..99:
    for verb in 0..99:
      var c= code
      c[1]= noun
      c[2]= verb
      let r = run(c)
      #echo [noun, verb, r]
      if r==19690720:
        echo fmt"yeah!!! {noun} {verb} {100 * noun + verb}"
        break main
              
