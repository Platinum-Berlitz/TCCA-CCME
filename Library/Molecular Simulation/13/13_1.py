import matplotlib.pyplot as e
import math

f = open('13_1_trace.dat', encoding = 'utf-8', mode = 'r')
l = [x.strip().split() for x in f]
f.close()

x = [float(i[0]) for i in l]
y = [float(i[1]) for i in l]

e.scatter(x, y, s = 0.1)
# e.xlim((-0.01, 0.01))
# e.ylim((-0.04, 0.04))
# e.xlim((-0.15, 0.15))
# e.ylim((-1, 1))
e.xlim((-0.5, 1.5))
e.ylim((-3, 3))
e.xlabel('x')
e.ylabel('v')
e.show()