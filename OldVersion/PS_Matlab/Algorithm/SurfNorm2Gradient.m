function [P,Q] = SurfNorm2Gradient(Nx, Ny, Nz,sameHW)
%Version:1.0, Author;WANG lei, Date:2015.5.11
%Debug:OK
%Get depth map of 3D surface
%Inputs:
%   Nx,Ny,Nz ---- Norm vector of surface (matrix in same size of XYZ)
%Outputs
%   P,Q ---- Gradient of surface (matrix in same size of XYZ)

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
    if sameHW==1
        P=Nx./Nz;
        Q=Ny./Nz;
    else
        P=Nx./Nz;
        Q=Ny./Nz;  
        P=(P(:,1:w-1)+P(:,2:w))/2;
        Q=(Q(1:h-1,:)+Q(2:h,:))/2;
    end
end

