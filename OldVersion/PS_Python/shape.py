import numpy as np
def n_to_pq(nx:'2d np.array',
            ny:'2d np.array',
            nz:'2d np.array'):
    p = -np.divide(nx,nz)
    q = -np.divide(ny,nz)
    return p, q

def pq_to_n(p:'2d np.array',
            q:'2d np.array'):
    nz = np.ones_like(p)
    nx = p.copy()
    ny = q.copy()
    n = np.sqrt(np.square(nz) + np.square(nx) + np.square(ny))
    nx = -np.divide(nx,n)
    ny = -np.divide(ny,n)
    nz = np.divide(nz,n)
    return nx, ny, nz

def z_to_pq(z:'2d np.array'):
    height = len(z)
    width = len(z[0])
    p = -0.5*z[0:height-1,0:width-1]+0.5*z[0:height-1,1:width]-0.5*z[1:height,0:width-1]+0.5*z[1:height,1:width]
    q = -0.5*z[0:height-1,0:width-1]-0.5*z[0:height-1,1:width]+0.5*z[1:height,0:width-1]+0.5*z[1:height,1:width]
    return p, q

def up_sphere(range_x:'[xmin, xmax, xtic]' = [0.0,4.0,0.2],
              range_y:'[ymin, ymax, ytic]' = [0.0,4.0,0.2],
              sphere_r = 1.5, sphere_x = 2.0, sphere_y = 2.0,sphere_z = -1.0,
              plane_z = 0):
    xarange = np.arange(range_x[0],range_x[1],range_x[2])
    yarange = np.arange(range_y[0],range_y[1],range_y[2])
    mesh_x, mesh_y = np.meshgrid(xarange, yarange)
    mesh_z = np.zeros_like(mesh_x)
    mesh_zdx = np.zeros_like(mesh_x)
    mesh_zdy = np.zeros_like(mesh_x)
    mesh_nx = np.zeros_like(mesh_x)
    mesh_ny = np.zeros_like(mesh_x)
    mesh_nz = np.zeros_like(mesh_x)
    for j, (rows_x, rows_y) in enumerate(zip(mesh_x,mesh_y)):
        for i, (x, y) in enumerate(zip(rows_x, rows_y)):
            # mesh_z=max(plane_z,())
            r = np.square(sphere_r) - np.square(x-sphere_x) - np.square(y-sphere_y)
            if r>0:
                surf_z = sphere_z + np.sqrt(r)
                if surf_z>plane_z:
                    mesh_z[j,i] = surf_z
                    mesh_nx[j, i] = (x - sphere_x)/sphere_r
                    mesh_ny[j, i] = (y - sphere_y)/sphere_r
                    mesh_nz[j, i] = (surf_z - sphere_z)/sphere_r
                    mesh_zdx[j, i] = (x - sphere_x)/(sphere_z - surf_z)
                    mesh_zdy[j, i] = (y - sphere_y)/(sphere_z - surf_z)
                else:
                    mesh_z[j,i] = plane_z
                    mesh_nz[j, i] = 1
            else:
                mesh_z[j,i] = plane_z
                mesh_nz[j, i] = 1
    return mesh_x, mesh_y, mesh_z, mesh_nx, mesh_ny, mesh_nz, mesh_zdx, mesh_zdy

def down_sphere(range_x:'[xmin, xmax, xtic]' = [0.0,4.0,0.2],
                range_y:'[ymin, ymax, ytic]' = [0.0,4.0,0.2],
                sphere_r = 1.5, sphere_x = 2.0, sphere_y = 2.0,sphere_z = 1.0,
                plane_z = 0):
    xarange = np.arange(range_x[0],range_x[1],range_x[2])
    yarange = np.arange(range_y[0],range_y[1],range_y[2])
    mesh_x, mesh_y = np.meshgrid(xarange, yarange)
    mesh_z = np.zeros_like(mesh_x)
    mesh_zdx = np.zeros_like(mesh_x)
    mesh_zdy = np.zeros_like(mesh_x)
    mesh_nx = np.zeros_like(mesh_x)
    mesh_ny = np.zeros_like(mesh_x)
    mesh_nz = np.zeros_like(mesh_x)
    for j, (rows_x, rows_y) in enumerate(zip(mesh_x,mesh_y)):
        for i, (x, y) in enumerate(zip(rows_x, rows_y)):
            # mesh_z=max(plane_z,())
            r = np.square(sphere_r) - np.square(x-sphere_x) - np.square(y-sphere_y)
            if r>0:
                surf_z = sphere_z - np.sqrt(r)
                if surf_z<plane_z:
                    mesh_z[j,i] = surf_z
                    mesh_nx[j, i] = -(x - sphere_x)/sphere_r
                    mesh_ny[j, i] = -(y - sphere_y)/sphere_r
                    mesh_nz[j, i] = -(surf_z - sphere_z)/sphere_r
                    mesh_zdx[j, i] = (x - sphere_x)/(sphere_z - surf_z)
                    mesh_zdy[j, i] = (y - sphere_y)/(sphere_z - surf_z)
                else:
                    mesh_z[j,i] = plane_z
                    mesh_nz[j, i] = 1
            else:
                mesh_z[j,i] = plane_z
                mesh_nz[j, i] = 1
    return mesh_x, mesh_y, mesh_z, mesh_nx, mesh_ny, mesh_nz, mesh_zdx, mesh_zdy

def shape_array(mesh_x, mesh_y, mesh_z, mesh_nx, mesh_ny, mesh_nz, mesh_zdx, mesh_zdy,
                num_xy:'[num_x, num_y]' = [2,2],
                step_xy:'[step_x, step_y]' = [4.0,4.0]):
    height = len(mesh_x)
    width = len(mesh_x[0])
    array_mesh_x = np.zeros((height*num_xy[1],width*num_xy[0]),mesh_x.dtype)
    array_mesh_y = np.zeros_like(array_mesh_x)
    array_mesh_z = np.zeros_like(array_mesh_x)
    array_mesh_nx = np.zeros_like(array_mesh_x)
    array_mesh_ny = np.zeros_like(array_mesh_x)
    array_mesh_nz = np.zeros_like(array_mesh_x)
    array_mesh_zdx = np.zeros_like(array_mesh_x)
    array_mesh_zdy = np.zeros_like(array_mesh_x)
    for num_y in range(num_xy[1]):
        for num_x in range(num_xy[0]):
            array_mesh_x[num_y*height:num_y*height+height, num_x*width:num_x*width+width] = mesh_x+(num_x*step_xy[0])
            array_mesh_y[num_y*height:num_y*height+height, num_x*width:num_x*width+width] = mesh_y+(num_y*step_xy[1])
            array_mesh_z[num_y*height:num_y*height+height, num_x*width:num_x*width+width] = mesh_z
            array_mesh_nx[num_y*height:num_y*height+height, num_x*width:num_x*width+width] = mesh_nx
            array_mesh_ny[num_y*height:num_y*height+height, num_x*width:num_x*width+width] = mesh_ny
            array_mesh_nz[num_y*height:num_y*height+height, num_x*width:num_x*width+width] = mesh_nz
            array_mesh_zdx[num_y*height:num_y*height+height, num_x*width:num_x*width+width] = mesh_zdx
            array_mesh_zdy[num_y*height:num_y*height+height, num_x*width:num_x*width+width] = mesh_zdy
    return array_mesh_x, array_mesh_y, array_mesh_z, array_mesh_nx, array_mesh_ny, array_mesh_nz, array_mesh_zdx, array_mesh_zdy