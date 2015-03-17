#!/usr/bin/python
from mpl_toolkits.mplot3d import Axes3D
import matplotlib
import numpy as np
import pylab as pl
from pylab import cm
from numpy import pi

step = 0.04
maxval = 1.0

def higgs_potential(R):
    return R**4 - R**2

fig = pl.figure()
ax = fig.add_subplot(111, projection='3d')

# create supporting points in polar coordinates
p0 = 0
p1 = 9.5*pi/6
r = np.linspace(0, 0.98, 50)
p = np.linspace(p0, p1, 50)

R, P = np.meshgrid(r,p)
X, Y = R*np.cos(P), R*np.sin(P)
x0, y0 = r*np.cos(p0), r*np.sin(p0)
x1, y1 = r*np.cos(p1), r*np.sin(p1)

Z = higgs_potential(R)
z = higgs_potential(r)

ax.plot_surface(
    X, Y, Z, alpha=0.6,
    rstride=1, cstride=1,
    linewidth=0.00,
    cmap=cm.YlGnBu_r,
)

ax.set_zlim3d(0, 1)
ax.set_xlabel(r'$\phi_1$', size=25)
ax.set_ylabel(r'$\phi_2$', size=25)
ax.set_zlabel(r'$V(\Phi)$', size=25)
ax.set_xticklabels('')
ax.set_yticklabels('')
ax.set_zticklabels('')
minimum = min([min(z) for z in Z])
maximum = max([max(z) for z in Z])
ax.set_zlim(minimum, maximum)
#cset = ax.contour(X, Y, Z, zdir='y',
                  #offset=0.98,
                  #cmap=cm.gray)
#cset = ax.contour(X, Y, Z, zdir='z',
                  #offset=minimum,
                  #cmap=cm.coolwarm)
ax.plot(x0, y0, z, 'k', linewidth=2)
ax.plot(x1, y1, z, 'k', linewidth=2)
pl.savefig('higgs_potential.pdf')

