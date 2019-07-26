import matplotlib.pyplot as pt

f = open('4_2.dat', encoding = 'utf-8', mode = 'r')
l = [x.strip().split('   ') for x in f]
l1 = l[1:101]
f.close()

x = [float(z[0]) for z in l1]
y = [float(z[1]) for z in l1]

pt.plot(x, y, label = r'Numerical, $10^4$')
pt.legend()
pt.xlim((0, 100))
pt.ylim((0, 4000))
pt.show()