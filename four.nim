let input = 138307..654504


proc splat(n: int):array[6,int]=
    var
      x = n
      d = 100000
    for i in 0..5:
      result[i] = int(x/d)
      x = x - result[i]*d
      d = int(d/10)

proc valid(n: int):bool =
  let x = splat(n)
  var zero = false
  for i in 0..4:
    let d = x[i+1] - x[i]
    if d<0: return false
    zero = zero or d==0
  return zero

echo 111111, " ", valid(111111)
echo 223450, " ", valid(223450)
echo 123789, " ", valid(123789)
  
var count = 0
for n in input:
  count = count + int(valid(n))
echo count

proc valid2(n: int):bool =
  let x = splat(n)
  var z: array[5,bool]
  for i in 0..4:
    let d = x[i+1] - x[i]
    if d<0: return false
    z[i] = d==0
  if z[0] and not z[1]: return true
  if z[4] and not z[3]: return true
  for i in 1..3:
      if z[i] and (not z[i-1]) and (not z[i+1]):
        return true
  return false

block:
  var count = 0
  for n in input:
    count = count + int(valid2(n))
  echo count

echo 112233, " ", valid2(112233)
echo 123444, " ", valid2(123444)
echo 112222, " ", valid2(112222)
