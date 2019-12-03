

sum = 0
for line in open("input.txt").readlines():
    sum = sum + int((int(line)/3))-2
print(sum)
