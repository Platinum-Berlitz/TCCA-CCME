import matplotlib.pyplot as plt
import numpy as np

l1 = []
l2 = []
l3 = []
lx = []

path = "1.out"
linenu = 43
steps = 5000

fp = open("1.out", "r")

for i in range(linenu):
    fp.readline()

for i in range(steps):
    lx.append(i + 1)
    s = fp.readline().split()
    l1.append(float(s[0]))
    l2.append(float(s[1]))
    l3.append(float(s[2]))

plt.title("Leap Frog Algorithm")
plt.xlabel("Timestep")
plt.ylabel("Energy")
plt.plot(lx,l1,color='blue',linestyle='-',label='kinetic')
plt.plot(lx,l2,color='orange',linestyle='-',label='potential')
plt.plot(lx,l3,color='green',linestyle='--',label='total')
plt.legend(loc="center right")
plt.savefig("LF.png")