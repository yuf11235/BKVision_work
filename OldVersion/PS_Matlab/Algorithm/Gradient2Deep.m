function [Z,AlgritomDataOut] = Gradient2Deep(P,Q,Algritom, AlgritomDataIn)
%Version:1.0, Author;WANG lei, Date:2015.5.11 
%Debug:Undone
%Get depth map of 3D surface
%Inputs:
%   P,Q ---- Gradient of surface (matrix in same size of XYZ)
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
    sameHW=-1;
    [hP,wP]=size(P);
    [hQ,wQ]=size(Q);
    if hP<=0|| wP<=0|| hQ<=0|| wQ<=0
        error('Input Martix size not valable!');        
    end
    if  hP==hQ ||wP==wQ
        sameHW=1;
    elseif  hP==hQ+1 ||wP+1==wQ
        sameHW=0;
    else
        error('Input Martix size not valable!'); 
    end
    h=max(hP,hQ);
    w=max(wP,wQ);
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
    else 
        P=[P(:,1),(P(:,1:wP-1)+P(:,2:wP))/2,P(:,wP)];
        Q=[Q(1,:),(Q(1:wQ-1,:)+P(2:wQ,:))/2,Q(wQ,:)];
    end
    I=ones(h,w,'double');
    norm=P.*P+P.*P+I;
    norm=sqrt(norm);
    Nx=P./norm;
    Ny=Q./norm;
    Nz=I./norm;
end

%   Algritom ---- Algritom String {'path integral algorithms'/'PI';
%                                  'multipath integral algorithms'/'MI';
%                                  'iterative optimization algorithms'/'IO';
%                                  'multiscal iterative optimization algorithms'/'MO';
%                                  'wavelet based integral algorithm'/'WI';
%                                  'wavelet based reconstruction algorithm'/'WO';
%                                  }
function [Z,AlgritomDataOut] = PathIntegral(P,Q, AlgritomDataIn)
%Version:1.0, Author;WANG lei, Date:2015.5.11 
%Debug:Undone
%Get depth map of 3D surface
%Inputs:
%   P,Q ---- Gradient of surface (matrix in same size of XYZ)
%   AlgritomDataIn----- Algritom Data{ }
%Outputs
%   Z ---- Depth of surface (matrix in same size of XYZ)

end

