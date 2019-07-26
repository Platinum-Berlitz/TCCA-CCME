import matplotlib.pyplot as e
import math

x = [-1 + i*0.01 for i in range(300)]
y = []
for i in x:
    if i <= 0:
        y.append(math.pi**2*2*i**2)
    elif i <= 1:
        y.append(1-math.cos(2*math.pi*i))
    else:
        y.append(math.pi**2*2*(i-1)**2)

e.plot(x, y)
e.xlabel('x')
e.ylabel('U')
e.xlim(-0.5, 1.5)
e.ylim(0, 4)
e.show()