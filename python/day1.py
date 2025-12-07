
lines = []
with open("./input/day1.txt", "r") as inf:
    lines = inf.readlines()

pos = 50
cnt = 0
cnt2 = 0
for line in lines:
    dir = line[0]
    amt = int(line[1:])

    if dir=='L':
        pos -= amt
    else:
        pos += amt

    around = pos//100
    if around<0:
        around = -around
    cnt2 += around
    pos = pos % 100
    if pos==0:
        cnt += 1

    print(f"{dir}{amt} -> pos={pos} cnt={cnt} pt2={cnt2}")


print("Answer is wrong for pt2. Just was easier to hit in asm")
