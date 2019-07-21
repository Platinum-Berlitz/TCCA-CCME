import matplotlib.pyplot as pt

f = open('4_1.dat', encoding = 'utf-8', mode = 'r')
l = [x.strip().split('   ') for x in f]
l1 = l[1:101]
l2 = l[102:202]
l3 = l[203:303]
f.close()

x = [float(z[0]) for z in l1]
y1 = [float(z[1]) for z in l1]
y2 = [float(z[1]) for z in l2]
y3 = [float(z[1]) for z in l3]

pt.plot(y1, x, label = r'Numerical, $10^2$')
pt.plot(x, y2, label = r'Numerical, $10^3$')
pt.plot(x, y3, label = r'Numerical, $10^4$')
pt.plot(x, x, label = 'Theoretical')
pt.legend()
pt.xlim((0, 100))
pt.ylim((0, 100))
pt.show()