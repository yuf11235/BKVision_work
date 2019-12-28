import numpy as np
def photometric_3light(image1:'2d np.array',light1:'[l1x, l1y, l1z]',
                       image2:'2d np.array',light2:'[l2x, l2y, l2z]',
                       image3:'2d np.array',light3:'[l3x, l3y, l3z]'):
    mesh_nx = np.zeros_like(image1)
    mesh_ny = np.zeros_like(image1)
    mesh_nz = np.zeros_like(image1)
    mesh_zdx = np.zeros_like(image1)
    mesh_zdy = np.zeros_like(image1)
    L_1=np.mat([light1,light2,light3]).I
    for j, (rows_i1, rows_i2, rows_i3) in enumerate(zip(image1,image2,image3)):
        for i, (i1, i2, i3) in enumerate(zip(rows_i1, rows_i2, rows_i3)):
            n = -L_1*np.mat([[i1], [i2], [i3]])
            n = n/np.sqrt(n.T*n)
            mesh_nx[j,i] = n[0,0]
            mesh_ny[j,i] = n[1,0]
            mesh_nz[j,i] = n[2,0]
            mesh_zdx[j,i] = -n[0,0]/n[2,0]
            mesh_zdy[j,i] = -n[1,0]/n[2,0]
    return mesh_nx,mesh_ny,mesh_nz,mesh_zdx,mesh_zdy

def photometric_mlight(images:'3d np.array',lights:'[[l1x, l1y, l1z],[]...]'):
    mesh_nx = np.zeros_like(images[:,:,0])
    mesh_ny = np.zeros_like(images[:,:,0])
    mesh_nz = np.zeros_like(images[:,:,0])
    mesh_zdx = np.zeros_like(images[:,:,0])
    mesh_zdy = np.zeros_like(images[:,:,0])
    L_1=np.mat(lights).I
    for j in range(len(images)):
        for i in range(len(images[0])):
            n = -L_1*np.mat(images[j,i,:])####
            n = n/np.sqrt(n.T*n)
            mesh_nx[j,i] = n[0,0]
            mesh_ny[j,i] = n[1,0]
            mesh_nz[j,i] = n[2,0]
            mesh_zdx[j,i] = -n[0,0]/n[2,0]
            mesh_zdy[j,i] = -n[1,0]/n[2,0]
    return mesh_nx,mesh_ny,mesh_nz,mesh_zdx,mesh_zdy

def photometric_symlight(image1:'2d np.array',
                         image2:'2d np.array',
                         angle:'light angle'):
    # mesh_nx = np.zeros_like(image1)
    # mesh_ny = np.zeros_like(image1)
    # mesh_nz = np.zeros_like(image1)
    mesh_zdx = np.zeros_like(image1)
    mesh_zdy = np.zeros_like(image1)
    cot= 1/np.tan(angle*np.pi/180)
    for j, (rows_i1, rows_i2) in enumerate(zip(image1,image2)):
        for i, (i1, i2) in enumerate(zip(rows_i1, rows_i2)):
            mesh_zdy[j,i] = cot*(i2-i1)/(i2+i1)
            # mesh_ny[j,i] = mesh_zdy[j,i]/np.sqrt(mesh_zdy[j,i]*mesh_zdy[j,i]+1)
            # mesh_nz[j,i] = 1/np.sqrt(mesh_zdy[j,i]*mesh_zdy[j,i]+1)
    return mesh_zdx,mesh_zdy # mesh_nx,mesh_ny,mesh_nz,