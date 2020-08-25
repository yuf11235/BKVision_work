import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import photo_metric_stereo.shape as shape
import photo_metric_stereo.render as render
import photo_metric_stereo.algrithom as algrithom

### generate simulate shape
mesh_x, mesh_y, mesh_z, mesh_nx, mesh_ny, mesh_nz, mesh_zdx, mesh_zdy\
    = shape.down_sphere(range_x = [0.0,4.0,0.2],
                        range_y = [0.0,4.0,0.2],
                        sphere_r = 2.0, sphere_x = 2.0, sphere_y = 2.0,sphere_z = 1.5,
                        plane_z = 0)
array_mesh_x, array_mesh_y, array_mesh_z, array_mesh_nx, array_mesh_ny, array_mesh_nz, array_mesh_zdx, array_mesh_zdy\
    = shape.shape_array(mesh_x, mesh_y, mesh_z, mesh_nx, mesh_ny, mesh_nz, mesh_zdx, mesh_zdy,
                        num_xy = [4,4],
                        step_xy = [4.0,4.0])

### plot simulate shape
fig = plt.figure()
ax = fig.gca(projection='3d', adjustable='box')
ax.set_aspect('equal')
# ax = Axes3D(fig)
# surf = ax.plot_surface(mesh_x, mesh_y, mesh_z, linestyles = 'solid',linewidth=0 ,edgecolor = 'white', cmap = plt.get_cmap('gray'), antialiased=False)
# surf = ax.plot_surface(mesh_x, mesh_y, mesh_z, linestyles = 'solid',linewidth=0 ,edgecolor = 'white', color = 'gray'  )#,cmap = plt.get_cmap('gray')
wireframe = ax.plot_wireframe(array_mesh_x[::2,::2], array_mesh_y[::2,::2], array_mesh_z[::2,::2],
                              rstride=1, cstride=1, linestyles = 'solid',linewidth=0.1 ,edgecolor = 'gray')
# scatter = ax.scatter(mesh_x, mesh_y, mesh_z,  marker="o", s=0.5, color = 'black')
quiver = ax.quiver(array_mesh_x[::2,::2], array_mesh_y[::2,::2], array_mesh_z[::2,::2],
                   0.1*array_mesh_nx[::2,::2], 0.1*array_mesh_ny[::2,::2], 0.1*array_mesh_nz[::2,::2])
# ax.set_xticks([])
# ax.set_yticks([])
# ax.set_zticks([])
# ax.axis('off')
ax.grid(False)
ax.auto_scale_xyz([0,16], [0,16], [-7,9])
plt.show()

### render the shape
phy = 60* np.pi/180
thetas = np.array([0, 120, 240])* np.pi/180
light_xyz_1  = np.array([np.cos(phy)*np.cos(thetas[0]), np.cos(phy)*np.sin(thetas[0]), np.sin(phy)])
light_xyz_2  = np.array([np.cos(phy)*np.cos(thetas[1]), np.cos(phy)*np.sin(thetas[1]), np.sin(phy)])
light_xyz_3  = np.array([np.cos(phy)*np.cos(thetas[2]), np.cos(phy)*np.sin(thetas[2]), np.sin(phy)])

image1 = render.render_lambert_gray(shape_nx = array_mesh_nx,
                                    shape_ny = array_mesh_ny,
                                    shape_nz = array_mesh_nz,
                                    light_xyz  = light_xyz_1)
image2 = render.render_lambert_gray(shape_nx = array_mesh_nx,
                                    shape_ny = array_mesh_ny,
                                    shape_nz = array_mesh_nz,
                                    light_xyz  = light_xyz_2)
image3 = render.render_lambert_gray(shape_nx = array_mesh_nx,
                                    shape_ny = array_mesh_ny,
                                    shape_nz = array_mesh_nz,
                                    light_xyz  = light_xyz_3)

### plot rendered shape
fig = plt.figure()
plt.subplot(131)
plt.imshow(image1,cmap='gray')
plt.axis('off')
plt.subplot(132)
plt.imshow(image2,cmap='gray')
plt.axis('off')
plt.subplot(133)
plt.imshow(image3,cmap='gray')
plt.axis('off')
plt.show()

### photomatric stereo
phy = 45* np.pi/180
thetas = np.array([0, 120, 240])* np.pi/180
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
quiver1 = ax.quiver(array_mesh_x[::2,::2], array_mesh_y[::2,::2], array_mesh_nx[::2,::2],array_mesh_ny[::2,::2])
plt.xlim(0.0,16.0)
plt.ylim(0.0,16.0)
plt.axis('equal')
ax = plt.subplot(122)
quiver2 = ax.quiver(array_mesh_x[::2,::2], array_mesh_y[::2,::2], ps_mesh_nx[::2,::2],ps_mesh_ny[::2,::2])
plt.xlim(0.0,16.0)
plt.ylim(0.0,16.0)
plt.axis('equal')
plt.show()