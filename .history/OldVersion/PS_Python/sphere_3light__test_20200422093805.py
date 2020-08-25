import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import shape as shape
import render as render
import algrithom as algrithom
import optimize_tf as optimize_tf

### generate simulate shape
mesh_x, mesh_y, mesh_z, mesh_nx, mesh_ny, mesh_nz, mesh_zdx, mesh_zdy\
    = shape.up_sphere(range_x = [0.0,4.0,0.05],
                        range_y = [0.0,4.0,0.05],
                        sphere_r = 1.5, sphere_x = 2.0, sphere_y = 2.0,sphere_z = -1.0,
                        plane_z = 0)
## plot simulate shape
fig = plt.figure()
ax = fig.gca(projection='3d', adjustable='box')
# ax.set_aspect('equal')
# ax = Axes3D(fig)
# surf = ax.plot_surface(mesh_x, mesh_y, mesh_z, linestyles = 'solid',linewidth=0 ,edgecolor = 'white', cmap = plt.get_cmap('gray'), antialiased=False)
# surf = ax.plot_surface(mesh_x, mesh_y, mesh_z, linestyles = 'solid',linewidth=0 ,edgecolor = 'white', color = 'gray'  )#,cmap = plt.get_cmap('gray')
wireframe = ax.plot_wireframe(mesh_x[::4,::4], mesh_y[::4,::4], mesh_z[::4,::4],
                              rstride=1, cstride=1, linestyles = 'solid',linewidth=0.1 ,edgecolor = 'gray')
# scatter = ax.scatter(mesh_x, mesh_y, mesh_z,  marker="o", s=0.5, color = 'black')
quiver = ax.quiver(mesh_x[::4,::4], mesh_y[::4,::4], mesh_z[::4,::4],
                   0.1*mesh_nx[::4,::4], 0.1*mesh_ny[::4,::4], 0.1*mesh_nz[::4,::4])
# ax.set_xticks([])
# ax.set_yticks([])
# ax.set_zticks([])
# ax.axis('off')
ax.grid(False)
ax.auto_scale_xyz([0,4], [0,4], [-1,3])
plt.show()

### render the shape
phy = 45* np.pi/180
thetas = np.array([0, 120, 240])* np.pi/180
light_xyz_1  = np.array([np.cos(phy)*np.cos(thetas[0]), np.cos(phy)*np.sin(thetas[0]), np.sin(phy)])
light_xyz_2  = np.array([np.cos(phy)*np.cos(thetas[1]), np.cos(phy)*np.sin(thetas[1]), np.sin(phy)])
light_xyz_3  = np.array([np.cos(phy)*np.cos(thetas[2]), np.cos(phy)*np.sin(thetas[2]), np.sin(phy)])
image1 = render.render_lambert_gray(shape_nx = mesh_nx,
                                    shape_ny = mesh_ny,
                                    shape_nz = mesh_nz,
                                    light_xyz  = light_xyz_1)
image2 = render.render_lambert_gray(shape_nx = mesh_nx,
                                    shape_ny = mesh_ny,
                                    shape_nz = mesh_nz,
                                    light_xyz  = light_xyz_2)
image3 = render.render_lambert_gray(shape_nx = mesh_nx,
                                    shape_ny = mesh_ny,
                                    shape_nz = mesh_nz,
                                    light_xyz  = light_xyz_3)
### plot rendered shape
# fig = plt.figure()
# plt.subplot(131)
# plt.imshow(image1,cmap='gray')
# plt.axis('off')
# plt.subplot(132)
# plt.imshow(image2,cmap='gray')
# plt.axis('off')
# plt.subplot(133)
# plt.imshow(image3,cmap='gray')
# plt.axis('off')
# plt.show()

### photomatric stereo
phy = 45* np.pi/180
thetas = np.array([0, 120, 240])* np.pi/180 +0.5
light_xyz_1  = np.array([np.cos(phy)*np.cos(thetas[0]), np.cos(phy)*np.sin(thetas[0]), np.sin(phy)])
light_xyz_2  = np.array([np.cos(phy)*np.cos(thetas[1]), np.cos(phy)*np.sin(thetas[1]), np.sin(phy)])
light_xyz_3  = np.array([np.cos(phy)*np.cos(thetas[2]), np.cos(phy)*np.sin(thetas[2]), np.sin(phy)])
ps_mesh_nx,ps_mesh_ny,ps_mesh_nz,ps_mesh_p,ps_mesh_q\
    = algrithom.photometric_3light(image1,light_xyz_1,
                                   image2,light_xyz_2,
                                   image3,light_xyz_3)
### plot photomatric stereo results
fig = plt.figure()
# ax = fig.gca()
# ax.set_aspect('equal')
ax = plt.subplot(121)
quiver1 = ax.quiver(mesh_x[::4,::4], mesh_y[::4,::4], mesh_nx[::4,::4],mesh_ny[::4,::4])
plt.xlim(0.0,4.0)
plt.ylim(0.0,4.0)
plt.axis('equal')
plt.xlim(0,4)
plt.ylim(0,4)
ax = plt.subplot(122)
quiver2 = ax.quiver(mesh_x[::4,::4], mesh_y[::4,::4], ps_mesh_nx[::4,::4],ps_mesh_ny[::4,::4])
plt.xlim(0.0,4.0)
plt.ylim(0.0,4.0)
plt.axis('equal')
plt.show()
iteration_times = 0
### optimize gradients
def plot_pq(mesh_p_, mesh_q_):
    global iteration_times
    iteration_times = iteration_times + 1
    mesh_nx_, mesh_ny_, _ = shape.pq_to_n(mesh_p_, mesh_q_)
    plt.clf()
    plt.subplot(131)
    plt.quiver(mesh_x[::4,::4], mesh_y[::4,::4], mesh_nx[::4,::4], mesh_ny[::4,::4])
    plt.axis('equal')
    plt.suptitle('Surface normal')
    plt.subplot(132)
    plt.quiver(mesh_x[::4,::4], mesh_y[::4,::4], ps_mesh_nx[::4,::4], ps_mesh_ny[::4,::4])
    plt.axis('equal')
    plt.suptitle('With integrability deviation')
    plt.subplot(133)
    plt.quiver(mesh_x[::4,::4], mesh_y[::4,::4], mesh_nx_[::4,::4], mesh_ny_[::4,::4])
    plt.axis('equal')
    plt.suptitle(str(iteration_times)+' times iteration')
    plt.pause(0.001)
ps_mesh_p_,ps_mesh_q_ = optimize_tf.optimize_pq(mesh_q = ps_mesh_q,
                                                mesh_p = ps_mesh_p,
                                                alpha =[0.0001,0.0001,0.9998],
                                                iterations = 10000000,
                                                converge = 0.0000000001,
                                                outputfunc = plot_pq)

### optimize deepth
fig = plt.figure()
# ax = Axes3D(fig)
def plot_z(mesh_z_):
    plt.clf()
    ax = fig.gca(projection='3d', adjustable='box')
    wireframe = ax.plot_wireframe(mesh_x, mesh_y, mesh_z_, rstride=1, cstride=1, linestyles = 'solid',linewidth=0.1 ,edgecolor = 'gray')
    ax.grid(False)
    ax.auto_scale_xyz([0,4], [0,4], [-1,3])
    #ax.set_aspect('equal')
    plt.pause(0.001)

mesh_z_, ps_mesh_p_,ps_mesh_q_ = optimize_tf.optimize_z_if_pq(mesh_q = ps_mesh_q,
                                                              mesh_p = ps_mesh_p,
                                                              step = [0.05,0.05],
                                                              alpha = [0.498,0.498],
                                                              beta = [0.000,0.000],
                                                              gama = [0.000,0.000],
                                                              iterations = 10000000,
                                                              converge = 0.0000000001,
                                                              outputfunc = plot_z)