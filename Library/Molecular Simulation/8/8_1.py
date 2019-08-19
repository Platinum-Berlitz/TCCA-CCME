import matplotlib.pyplot as pt

f = open('8_1.dat', encoding = 'utf-8', mode = 'r')
l = [x.strip().split() for x in f]
f.close()

x = [float(i[0]) for i in l]
y = [float(i[1])/2 for i in l]

y1 = [0.25*(1-i) for i in x]
pt.plot(x, x, label = 'Ideal Gas')
pt.plot(x, y, label = 'Lennard-Jones Gas')
pt.xlim((0, 0.04))
pt.ylim((0, 0.04))
pt.xlabel(r'rho')
pt.ylabel(r'beta p')
pt.legend()
pt.show()