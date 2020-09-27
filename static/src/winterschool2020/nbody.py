import numpy as np
import matplotlib.pyplot as plt

nparticles = 2

x = np.zeros((nparticles, 3))
v = np.zeros((nparticles, 3))

# vel = 1./np.sqrt(2*radius)
vel = 0.5

x[0], v[0] = (-1, 0, 0), (0, vel, 0)
x[1], v[1] = (1, 0, 0), (0, -vel, 0)

xnew, vnew = np.zeros((nparticles, 3)), np.zeros((nparticles, 3))

dt = 0.001

# ntimes = 5000
ntimes = int(1e4)

history = np.zeros((ntimes+1, nparticles, 3))

history[0] = x

for t in range(ntimes):
    for i in range(nparticles):
        force = np.zeros(3)
        for j in range(nparticles):
            if i != j:
                distSquared = sum((x[i]-x[j])**2)
                force -= (x[i]-x[j]) / distSquared**1.5
        xnew[i] = x[i] + v[i]*dt
        vnew[i] = v[i] + force*dt
        # better approach would be
        # https://en.wikipedia.org/wiki/Leapfrog_integration
    x = xnew
    v = vnew
    history[t+1] = x

print("final: 1>", x[0], " 2>", x[1])

fig = plt.figure(figsize=(12, 12))

ax = fig.add_subplot(111)

ax.set_xlim(-2, 2)
ax.set_ylim(-2, 2)

plt.plot(history[:, 0, 0], history[:, 0, 1], "bo-")
plt.plot(history[:, 1, 0], history[:, 1, 1], "ro-")

plt.show()
