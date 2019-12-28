function [Nx, Ny, Nz] = Deep2SurfNorm(Z)
%Version:1.0, Author;WANG lei, Date:2015.5.11
%Debug:OK
%Get depth map of 3D surface
%Inputs:
%   Z ---- Coordinate of surface;
%Outputs
%   Nx,Ny,Nz ---- Norm vector of surface (matrix in same size of XYZ)

    %Input parameter process
    
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
    [P,Q] = Deep2Gradient(Z,1);
    [Nx, Ny, Nz] = Gradient2SurfNorm(P,Q);
end

