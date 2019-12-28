import numpy as np
def render_lambert_gray(shape_nx: '2d np.array',
                        shape_ny:'2d np.array',
                        shape_nz:'2d np.array',
                        rho_gray:'2d np.array' = None,
                        light_xyz:'[lx, ly, lz]' = [0.0,0.707,0.707],
                        light_gray:'luminance' = 0.8):
    image = np.zeros_like(shape_nx)
    if rho_gray is None:
        rho_gray = np.ones_like(shape_nx)
    for j, (rows_nx, rows_ny, rows_nz) in enumerate(zip(shape_nx,shape_ny,shape_nz)):
        for i, (nx, ny, nz) in enumerate(zip(rows_nx, rows_ny, rows_nz)):
            image[j,i] = -rho_gray[j,i]*light_gray*(light_xyz[0]*nx+light_xyz[1]*ny+light_xyz[2]*nz)
    return image

def lambert_render_color(shape_nx:'2d np.array',
                         shape_ny:'2d np.array',
                         shape_nz:'2d np.array',
                         rho_r:'2d np.array' = None,
                         rho_g:'2d np.array' = None,
                         rho_b:'2d np.array' = None,
                         light_xyz:'[lx, ly, lz]' = [0.0,0.707,0.707],
                         light_rgb:'[lr, lg, lb]' = [0.0,0.707,0.707]):
    if rho_r is None:
        rho_r = np.ones_like(shape_nx)
    if rho_g is None:
        rho_g = np.ones_like(shape_nx)
    if rho_b is None:
        rho_b = np.ones_like(shape_nx)
    image_r = render_lambert_gray(shape_nx, shape_ny, shape_nz,
                                  rho_gray = rho_r,
                                  light_xyz = light_xyz,
                                  light_gray = light_rgb[0])
    image_g = render_lambert_gray(shape_nx, shape_ny, shape_nz,
                                  rho_gray = rho_g,
                                  light_xyz = light_xyz,
                                  light_gray = light_rgb[1])
    image_b = render_lambert_gray(shape_nx, shape_ny, shape_nz,
                                  rho_gray = rho_b,
                                  light_xyz = light_xyz,
                                  light_gray = light_rgb[2])
    return image_r, image_g, image_b