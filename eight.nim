let x="123456789002"

import sequtils
import strutils

let y =  x.mapIt(parseInt $it)
proc cut[T](X:seq[T],d:int):seq[seq[T]]=
  var row:seq[T]
  for x in X:
    row.add x
    if len(row)>=d:
      result.add row
      row= newSeq[T]()
proc finds(X:seq[int],x:int):seq[int]=
  for i,v in X.pairs:
    if x==v: result.add i
proc findmax(X:seq[int]):(int,int)=
  result[0]=X[0]
  for i,v in X.pairs:
    if v>result[0]: result= (v,i)
proc findmin(X:seq[int]):(int,int)=
  result[0]=X[0]
  for i,v in X.pairs:
    if v<result[0]: result= (v,i)


echo findmax cut(y,6).mapIt( len it.finds(0))
let txt= readFile("eight.txt").strip.mapIt(parseInt $it)
let layers = cut(txt,25*6)

let id0= (findmin layers.mapIt( it.count(0)))[1]
echo layers[id0].count(1) * layers[id0].count(2)

proc draw[T](X:seq[T]):T=
  result=X[0]
  for layer in X:
    for i,p in layer.pairs:
        if result[i]==2: result[i]=p
          
proc flat[T](X:seq[T]):T=
  for x in X: result.add x
  
echo layers.draw.cut(25).mapIt(join it).join("\n")
# was BCPZB

