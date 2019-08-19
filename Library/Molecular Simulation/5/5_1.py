import matplotlib.pyplot as pt

f = open('5_1.dat', encoding = 'utf-8', mode = 'r')
l = [x.strip() for x in f]
f.close()

x = []
y = []
z = []

for i in range(10):
    ac = float(l[i*102][18:].strip())
    theta = float(l[i*102+1][23:].strip())
    da = l[i*102+101].split()
    x1 = float(da[1])
    x2 = float(da[2])
    D = (x1 + x2) / 400
    x.append(theta)
    y.append(D)
    z.append(ac)

y1 = [0.25*(1-i) for i in x]
pt.plot(x, y, label = 'Numerical')
pt.plot(x, y1, label = 'Theoretical')
pt.legend()
pt.xlim((0, 0.1))
pt.ylim((0.22, 0.26))
pt.show()