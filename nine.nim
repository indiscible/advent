import computer
 
proc run(code:seq[int],inout: seq[int]= @[0], debug:bool=false):State=
   run((code, 0, 0, inout),debug)

let t0= parse("109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99")
assert(run(t0).inout==t0)

let t1= parse("1102,34915192,34915192,7,4,7,99,0")
echo run(t1)
let t2= parse("104,1125899906842624,99")
assert( t2[1]== run(t2).inout[0])
import strutils
let t3= parse(readFile("nine.txt").strip())
echo run(t3,@[1]).inout #2406950601
echo run(t3,@[2]).inout #83239

