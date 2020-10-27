# %matplotlib inline
import numpy as np
from math import sqrt
import matplotlib.pyplot as plt

from matplotlib import animation, rc
from IPython.display import HTML

# nparticles = 2
# ntimes = int(5e3)
# nout = 1
# x = np.zeros((nparticles, 3))
# v = np.zeros((nparticles, 3))
# vel = 0.5
# x[0], v[0] = (-1, 0, 0), (0, vel, 0)
# x[1], v[1] = (1, 0, 0), (0, -vel, 0)

nparticles = 10
ntimes = int(3e4)
nout = 100   	# plot every nout timesteps
courant = 1e-3  # effectively a Courant number
eps = 0.001     # min distance to prevent very small timesteps
x = 2*np.random.random(size=(nparticles, 3)) - 1
v = np.zeros((nparticles, 3))
v[:, 0] = 2.*x[:, 1]
v[:, 1] = -x[:, 0]/x[:, 1]*v[:, 0]

fig = plt.figure(figsize=(8, 8))
ax = fig.add_subplot(111)
ax.set_xlim(-2, 2)
ax.set_ylim(-2, 2)
points, = ax.plot([], [], 'bo')

# initialization function: plot the background of each frame
def init():
    points.set_data([], [])
    return (points, )

# animation function, called sequentially
def animate(i):
    x = history[i, :, 0]
    y = history[i, :, 1]
    points.set_data(x, y)
    return (points, )

xnew, vnew = np.zeros((nparticles, 3)), np.zeros((nparticles, 3))
vhalf = np.zeros((nparticles, 3))
# dt = 0.001 works well; dt = 0.01 produces inaccurate solution
history = np.zeros((int(ntimes/nout) + 1, nparticles, 3))
history[0] = x
for t in range(ntimes):
    force = np.zeros((nparticles, 3))
    tmin = 1.e10   # some large number
    for i in range(nparticles):
        for j in range(nparticles):
            if i != j:
                distSquared = sum((x[i]-x[j])**2)
                force[i] -= (x[i]-x[j]) / distSquared**1.5
                tmin = min(tmin, sqrt((distSquared+eps) / sum((v[i]-v[j])**2)))
    dt = tmin * courant
    for i in range(nparticles):
        # forward Euler
        xnew[i] = x[i] + v[i]*dt
        vnew[i] = v[i] + force[i]*dt
        # better approach would be https://en.wikipedia.org/wiki/Leapfrog_integration
    x = xnew
    v = vnew
    if (t+1)%nout == 0:
        history[int(t/nout)+1] = x

# fig = plt.figure(figsize=(12, 12))
# ax = fig.add_subplot(111)
# ax.set_xlim(-2, 2)
# ax.set_ylim(-2, 2)
# plt.plot(history[:, 0, 0], history[:, 0, 1], "bo-")
# plt.plot(history[:, 1, 0], history[:, 1, 1], "ro-")

# call the animator; blit=True means only re-draw the parts that have changed
anim = animation.FuncAnimation(fig, animate, init_func=init,
                               frames=int(ntimes/nout), interval=30, blit=True)
HTML(anim.to_html5_video())
