import matplotlib.pyplot as pt
import math

dt = [1e-4, 2e-4, 5e-4, 1e-3, 2e-3, 5e-3, 1e-2]
dtl = [math.log(x) for x in dt]
dr = [1e-6, 2e-6, 4e-6, 2e-5, 9e-5, 6e-4, 1e-3]
drl = [math.log(x) for x in dr]

pt.plot(dtl, drl)
pt.xlim((-10, -4))
pt.ylim((-14, -7))
pt.xlabel(r'ln dt')
pt.ylabel(r'ln drift')
pt.show()