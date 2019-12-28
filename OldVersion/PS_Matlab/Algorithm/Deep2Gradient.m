function [P,Q] = Deep2Gradient(Z,sameHW)
%Version:1.0, Author;WANG lei, Date:2015.5.11
%Debug:OK
%Get depth map of 3D surface
%Inputs:
%   Z ---- Coordinate of surface, X,Y must be gridded in order;
%Outputs
%   P,Q ---- Gradient of surface (matrix in same size of XYZ)

    %Input parameter process
    [hZ,wZ]=size(Z);  
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
        P=[(Z(:,2)-Z(:,1)),0.5*(Z(:,3:wZ)-Z(:,1:wZ-2)),(Z(:,wZ)-Z(:,wZ-1))];
        Q=[(Z(2,:)-Z(1,:));0.5*(Z(3:hZ,:)-Z(1:hZ-2,:));(Z(hZ,:)-Z(hZ-1,:))];
    else
        P=Z(:,2:wZ)-Z(:,1:wZ-1);
        Q=Z(2:hZ,:)-Z(1:hZ-1,:);
    end
end

