let input="""
B)C
COM)B
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L"""
import strutils
import Tables
import seqUtils

proc readChildrens(s:string):Table[string,seq[string]]=
  for line in s.splitLines():
    let a=line.split(")")
    if len(a)>1: result.mgetorput(a[0],newSeq[string]()).add a[1]
  
proc Depth(orbits:OrderedTable[string,string]) :OrderedTable[string,int]= 
  result["COM"]=0
  for k,v in orbits: result.mgetorput(k,0)= result[v] + 1

proc sum[T](X:openarray[T]):T=
  result = 0
  for x in X: result.inc x

proc flatten(X:seq[seq[string]]):seq[string]=
   for x in X: result.add x

import Sets

proc Orbits(satelite:Table[string,seq[string]]):OrderedTable[string,string]=
  var childs= toSet flatten toSeq values satelite
  var parents= toSet toSeq keys satelite
  while len(parents)>0:
    for p in parents:
      if not (p in childs):
        for c in satelite[p]: result[c]=p
        parents.excl p
        childs.excl toSet satelite[p]


   
proc CountOrbits(s:string):int= sum toSeq Depth( Orbits readChildrens s).values

echo CountOrbits(input)
echo CountOrbits(readFile("six.txt"))


proc Parents(parent:OrderedTable[string,string], n:string):seq[string]=
  var p= parent[n]
  while (p in parent):
    result.add p
    p = parent[p]
  return result
  
let satelite= readChildrens(input)
var parents= Orbits satelite
parents["YOU"]="K"
parents["SAN"]="I"
echo Parents(parents,"YOU")
echo Parents(parents,"SAN")

proc longestSuffix(a:seq[string], b: seq[string]):int=
  var i=1
  while i<len(a) and i<len(b) and a[^i]==b[^i]:
#    echo (a[0..^i],b[0..^i],i)
    i.inc
  echo (a[0..^i],b[0..^i],i)
  return len(a[0..^i]) + len(b[0..^i])

proc dist(parents:OrderedTable[string,string]):int=
  return longestSuffix(Parents(parents,"YOU"), Parents(parents,"SAN"))

echo dist(parents)
echo dist(Orbits readChildrens readFile "six.txt")
#not 813  not 807 not 269
