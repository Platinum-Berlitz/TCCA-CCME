import matplotlib.pyplot as e
import math

f = open('13_2_trace.dat', encoding = 'utf-8', mode = 'r')
l = [x.strip().split() for x in f]
f.close()

def p(s):
    if s <= 0:
        return (math.pi**2*2*s**2)
    elif s <= 1:
        return (1-math.cos(2*math.pi*s))
    else:
        return (math.pi**2*2*(s-1)**2)

x = [float(i[0]) for i in l]
y = [float(i[1]) for i in l]
z = [p(x[i]) + y[i]**2/2 for i in range(len(x))]
d = [0 for i in range(100)]
dd = [i/300 for i in range(100)]

for i in z:
    a = int(i * 300)
    if (a < len(d)):
        d[a] = d[a] + 1

dds = [4000*math.exp(-20*i) for i in dd]

# e.scatter(x, y, s = 0.1)
# # e.xlim((-0.01, 0.01))
# # e.ylim((-0.04, 0.04))
# # e.xlim((-0.15, 0.15))
# # e.ylim((-1, 1))
# e.xlim((-0.5, 1.5))
# e.ylim((-3, 3))
# e.xlabel('x')
# e.ylabel('v')
# e.show()

e.plot(dd, d, label = 'Berendsen')
e.plot(dd, dds, label = 'Boltzmann')
e.ylim(0, 2000)
e.xlim(0, 0.35)
e.legend()
e.show()