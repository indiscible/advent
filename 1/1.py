
def fuel(m):
    return max(0,int(m/3)-2)
    
sum = 0
for line in open("input.txt").readlines():
    sum = sum + fuel(int(line))
print(sum)

sum = 0
for line in open("input.txt").readlines():
    mass = int(int(line))
    f = fuel(mass) 
    while f>0:
        sum = sum + f
        f = fuel(f)
print(sum)


