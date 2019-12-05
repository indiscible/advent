import strutils
import sequtils
import algorithm
import tables
import sugar
var words= readFile("C:\\Users\\gilles\\Documents\\english-words-master\\english-words-master\\words.txt").splitLines()[100..1100]
for w in words.mitems: sort(w)

proc group(ws:seq[string]):Table[string,seq[int]]=
  for w in words.mpairs:
    result.mgetOrPut(w[1], newSeq[int]()).add(w[0])

echo (toSeq (group words).values).mapIt(it.len).find(x=>x>1)
