import matplotlib.pyplot as pt
import math
f = open('3_1.dat', encoding = 'utf-8', mode = 'r')
l = [x.strip() for x in f]
f.close()
f = open('3_2.dat', encoding = 'utf-8', mode = 'r')
m = [x.strip() for x in f]
f.close()
NVT = [float(x.split('   ')[1]) for x in m[3:]]
data = []
for i in range(10):
    g = l[25*i + 4:25*i + 25]
    data.append([[float(i) for i in x.split('   ')] for x in g])

for i in range(9,10):
    l1 = data[i]
    x = [s[0] for s in l1]
    y = [s[1] for s in l1]
    pt.plot(x, y, label = (str((i + 1)*3) + ' Oscillators'), color = 'red')


beta = math.log(1 + (1 / 10))
print(beta)
Bolt = [math.exp(-beta * i)*data[9][0][1] for i in range(21)]
pt.xlim((0, 20))
pt.ylim((0, 0.1))
pt.plot(range(21), Bolt, label = 'Boltzmann', color = 'black', linestyle = '--')
pt.plot(range(21), NVT, label = 'NVT Simulation', color = 'blue')
pt.legend()
pt.show()