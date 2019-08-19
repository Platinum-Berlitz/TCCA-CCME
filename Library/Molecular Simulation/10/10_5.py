import matplotlib.pyplot as pt
import math

dt = [1e-4, 2e-4, 5e-4, 1e-3, 2e-3, 5e-3, 1e-2]
dtl = [math.log(x) for x in dt]
dr = [1e-6, 2e-6, 4e-6, 2e-5, 9e-5, 6e-4, 1e-3]
dr2 = [2e-2, 7e-2, 1e-1, 5e-1, 1e0, 1e9, 1e9]
dr3 = [3e-1, 7e-1, 2e0, 8e0, 1.3e1, 1e9, 1e9]
drl = [math.log(x) for x in dr]
drl2 = [math.log(x) for x in dr2]
drl3 = [math.log(x) for x in dr3]

pt.plot(dtl, drl, label = 'Verlet')
pt.plot(dtl, drl2, label = 'velocity Verlet')
pt.plot(dtl, drl3, label = 'Euler')
pt.xlim((-10, -4))
pt.ylim((-14, 4))
pt.xlabel(r'ln dt')
pt.ylabel(r'ln drift')
pt.legend()
pt.show()