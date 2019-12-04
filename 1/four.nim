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
  var
    z: array[5,bool]
  for i in 0..4:
    let d = x[i+1] - x[i]
    if d<0: return false
    z[i] = d==0
  for i in 1..3
    yero = yero or d==0
  return zero

  
