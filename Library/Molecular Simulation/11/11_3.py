import matplotlib.pyplot as pt
import math
f = open('11_3.dat', encoding = 'utf-8', mode = 'r')
l = [line.strip().split() for line in f]
f.close()

l1 = l[1:11]
l2 = l[12:22]

x1 = [float(x[0]) for x in l1]
y1 = [float(x[1]) for x in l1]
x2 = [float(x[0]) for x in l2]
y2 = [float(x[1]) for x in l2]

# pt.plot(x1, y1)
# pt.xlim((0, 0.01))
# pt.ylim((0, 1))
# pt.xlabel(r'maximum displacement in ln V')
# pt.ylabel(r'acceptance')
# pt.show()
pt.plot(x2, y2)
pt.xlim((0, 10))
pt.ylim((0, 1))
pt.xlabel(r'maximum displacement in V')
pt.ylabel(r'acceptance')
pt.show()