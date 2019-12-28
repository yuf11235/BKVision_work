function [Z,AlgritomDataOut] = SurfNorm2Deep(Nx, Ny, Nz, Algritom, AlgritomDataIn)
%Version:1.0, Author;WANG lei, Date:2015.5.11
%Debug:OK
%Get depth map of 3D surface
%Inputs:
%   Nx,Ny,Nz ---- Norm vector of surface (matrix in same size of XYZ)
%   Algritom ---- Algritom String {'path integral algorithms'/'PI';
%                                  'multipath integral algorithms'/'MI';
%                                  'iterative optimization algorithms'/'IO';
%                                  'multiscal iterative optimization algorithms'/'MO';
%                                  'wavelet based integral algorithm'/'WI';
%                                  'wavelet based reconstruction algorithm'/'WO';
%                                  }
%   AlgritomDataIn----- Algritom Data
%Outputs
%   Z ---- Depth of surface (matrix in same size of XYZ)

    %Input parameter process
    [hX,wX]=size(Nx);
    [hY,wY]=size(Ny);
    [hZ,wZ]=size(Nz);
    if hX<=0|| hX~=hY ||hX~=hZ || wX<=0|| wX~=wY ||wX~=wZ
        error('Input Martix size not valable!');
    end
    h=hX;
    w=wX;
    %Generate middle value matrix
    %Generate middle value matrix
    %  Table 1:coordinate define of middle value matrix
    %  sameHW==1
    %  z       1       2       3 
    %  1      2-1   (3-1)/2   3-2
    %  2        
    %  sameHW==0
    %  z       1       2       3 
    %  1          2-1     3-2
    %  2
    [P,Q] =SurfNorm2Gradient(Nx, Ny, Nz,1);
    [Z,AlgritomDataOut] = Gradient2Deep(P,Q,Algritom, AlgritomDataIn);
end

