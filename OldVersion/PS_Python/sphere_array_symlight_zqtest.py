import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import shape as shape
import render as render
import algrithom as algrithom
import optimize_tf as optimize_tf

### generate simulate shape
mesh_x, mesh_y, mesh_z, mesh_nx, mesh_ny, mesh_nz, mesh_zdx, mesh_zdy\
    = shape.down_sphere(range_x = [0.0,4.0,0.2],
                        range_y = [0.0,4.0,0.2],
                        sphere_r = 2.0, sphere_x = 2.0, sphere_y = 2.0,sphere_z = 1.5,
                        plane_z = 0)
array_mesh_x, array_mesh_y, array_mesh_z, array_mesh_nx, array_mesh_ny, array_mesh_nz, array_mesh_zdx, array_mesh_zdy\
    = shape.shape_array(mesh_x, mesh_y, mesh_z, mesh_nx, mesh_ny, mesh_nz, mesh_zdx, mesh_zdy,
                        num_xy = [2,2],
                        step_xy = [4.0,4.0])
### plot simulate shape
fig = plt.figure()
ax = fig.gca(projection='3d', adjustable='box')
ax.set_aspect('equal')
# ax = Axes3D(fig)
wireframe = ax.plot_wireframe(array_mesh_x[::2,::2], array_mesh_y[::2,::2], array_mesh_z[::2,::2],
                              rstride=1, cstride=1, linestyles = 'solid',linewidth=0.1 ,edgecolor = 'gray')
quiver = ax.quiver(array_mesh_x[::2,::2], array_mesh_y[::2,::2], array_mesh_z[::2,::2],
                   0.1*array_mesh_nx[::2,::2], 0.1*array_mesh_ny[::2,::2], 0.1*array_mesh_nz[::2,::2])
ax.grid(False)
ax.auto_scale_xyz([0,8], [0,8], [-3,5])
plt.show()

### render the shape
phy = 60* np.pi/180
thetas = np.array([90, -90])* np.pi/180
light_xyz_1  = np.array([np.cos(phy)*np.cos(thetas[0]), np.cos(phy)*np.sin(thetas[0]), np.sin(phy)])
light_xyz_2  = np.array([np.cos(phy)*np.cos(thetas[1]), np.cos(phy)*np.sin(thetas[1]), np.sin(phy)])
image1 = render.render_lambert_gray(shape_nx = array_mesh_nx,
                                    shape_ny = array_mesh_ny,
                                    shape_nz = array_mesh_nz,
                                    light_xyz  = light_xyz_1)
image2 = render.render_lambert_gray(shape_nx = array_mesh_nx,
                                    shape_ny = array_mesh_ny,
                                    shape_nz = array_mesh_nz,
                                    light_xyz  = light_xyz_2)
### plot rendered shape
fig = plt.figure()
plt.subplot(121)
plt.imshow(image1,cmap='gray')
plt.axis('off')
plt.subplot(122)
plt.imshow(image2,cmap='gray')
plt.axis('off')
plt.show()

### photomatric stereo
phy = 60* np.pi/180
thetas = np.array([90, -90])* np.pi/180
light_xyz_1  = np.array([np.cos(phy)*np.cos(thetas[0]), np.cos(phy)*np.sin(thetas[0]), np.sin(phy)])
light_xyz_2  = np.array([np.cos(phy)*np.cos(thetas[1]), np.cos(phy)*np.sin(thetas[1]), np.sin(phy)])
ps_mesh_p,ps_mesh_q = algrithom.photometric_symlight(image1,image2,phy)
ps_mesh_nx,ps_mesh_ny,ps_mesh_nz=shape.pq_to_n(ps_mesh_p,ps_mesh_q)
### plot photomatric stereo results
fig = plt.figure()
# ax = fig.gca()
# ax.set_aspect('equal')
ax = plt.subplot(121)
# quiver1 = ax.quiver(array_mesh_x[::2,::2], array_mesh_y[::2,::2], array_mesh_nx[::2,::2],array_mesh_ny[::2,::2])
quiver1 = ax.quiver(array_mesh_x, array_mesh_y, array_mesh_nx,array_mesh_ny)
plt.xlim(0.0,16.0)
plt.ylim(0.0,16.0)
plt.axis('equal')
ax = plt.subplot(122)
# quiver2 = ax.quiver(array_mesh_x[::2,::2], array_mesh_y[::2,::2], ps_mesh_nx[::2,::2],ps_mesh_ny[::2,::2])
quiver2 = ax.quiver(array_mesh_x, array_mesh_y, ps_mesh_nx,ps_mesh_ny)
plt.xlim(0.0,16.0)
plt.ylim(0.0,16.0)
plt.axis('equal')
plt.show()

### optimize gradients
def plot_pq(mesh_p_, mesh_q_):
    mesh_nx, mesh_ny, _ = shape.pq_to_n(mesh_p_, mesh_q_)
    plt.clf()
    plt.quiver(array_mesh_x, array_mesh_y, mesh_nx, mesh_ny)
    plt.axis('equal')
    plt.pause(0.001)

height = len(array_mesh_x)
width = len(array_mesh_x[0])
array_mesh_x_ = +0.25*array_mesh_x[0:height-1,0:width-1]\
                +0.25*array_mesh_x[0:height-1,1:width] \
                +0.25*array_mesh_x[1:height,0:width-1]\
                +0.25*array_mesh_x[1:height,1:width]
array_mesh_y_ = +0.25*array_mesh_y[0:height-1,0:width-1] \
                +0.25*array_mesh_y[0:height-1,1:width]\
                +0.25*array_mesh_y[1:height,0:width-1]\
                +0.25*array_mesh_y[1:height,1:width]
def plot_zpq(mesh_z_):
    mesh_p_, mesh_q_ = shape.z_to_pq(mesh_z_)
    mesh_nx, mesh_ny, _ = shape.pq_to_n(mesh_p_, mesh_q_)
    plt.clf()
    plt.quiver(array_mesh_x_, array_mesh_y_, mesh_nx, mesh_ny)
    plt.axis('equal')
    plt.pause(0.001)

# fig = plt.figure()
# ax = fig.gca(projection='3d', adjustable='box')
# ax.set_aspect('equal')
# ax.grid(False)
# plt.pause(0.001)
# def plot_z(mesh_z_):
#     plt.cla()
#     ax.set_aspect('equal')
#     wireframe = ax.plot_wireframe(array_mesh_x, array_mesh_y, mesh_z_,
#                                   rstride=1, cstride=1, linestyles='solid', linewidth=0.1, edgecolor='gray')
#     ax.grid(False)
#     plt.pause(0.001)

ps_mesh_z_,ps_mesh_p_,ps_mesh_q_ = optimize_tf.optimize_z_if_pq(mesh_q = ps_mesh_q,
                                                mesh_p = ps_mesh_p*0,
                                                step=[0.2,0.2],
                                                alpha=[0.00,0.98],
                                                beta=[0.01,0.01],
                                                gama=[0.01,0.01],
                                                iterations = 10000000,
                                                converge = 0.0000000001,
                                                outputfunc = plot_zpq)

# ### plot photomatric stereo results
# fig = plt.figure()
# # ax = fig.gca()
# ax.set_aspect('equal')
# ax = plt.subplot(121)
# # quiver1 = ax.quiver(array_mesh_x[::2,::2], array_mesh_y[::2,::2], array_mesh_nx[::2,::2],array_mesh_ny[::2,::2])
# quiver1 = ax.quiver(array_mesh_x, array_mesh_y, array_mesh_nx,array_mesh_ny)
# plt.xlim(0.0,16.0)
# plt.ylim(0.0,16.0)
# plt.axis('equal')
# ax = plt.subplot(122)
# # quiver2 = ax.quiver(array_mesh_x[::2,::2], array_mesh_y[::2,::2], ps_mesh_nx[::2,::2],ps_mesh_ny[::2,::2])
# quiver2 = ax.quiver(array_mesh_x, array_mesh_y, ps_mesh_nx,ps_mesh_ny)
# plt.xlim(0.0,16.0)
# plt.ylim(0.0,16.0)
# plt.axis('equal')
# plt.show()