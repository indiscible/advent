import strutils

proc Fuel(mass: int): int = max(0,int(mass/3) - 2)

echo [Fuel(12), Fuel(14), Fuel(1969), Fuel(100756)]

var sum=0
for line in lines "1.txt":
  sum = sum + Fuel(parseInt(line))
echo sum


sum=0
for line in lines "1.txt":
  var mass = Fuel(parseInt(line))
  while mass>0:
    sum = sum + mass
    mass = Fuel(mass)
echo sum



