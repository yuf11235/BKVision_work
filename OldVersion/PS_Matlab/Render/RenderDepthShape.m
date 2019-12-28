function O = RenderDepthShape(C,D,dy,dx,L)
%UNTITLED2 Summary of this function goes here,Light
%   Detailed explanation goes here,depthMat
[height,width] = size(C);
[X,Y] = meshgrid(1:width-1,1:height-1);
X=X.*dx;
Y=Y.*dy;
C=double(C);
Ci=0.25*(+C(1:height-1,1:width-1)+C(1:height-1,2:width)...
        +C(2:height,1:width-1)+C(2:height,2:width));
D=double(D);
Di=0.25*(D(1:height-1,1:width-1)+D(1:height-1,2:width)...
        +D(2:height,1:width-1)+D(2:height,2:width));
Qi=(0.5/dy)*(-D(1:height-1,1:width-1)-D(1:height-1,2:width)...
        +D(2:height,1:width-1)+D(2:height,2:width));
Pi=(0.5/dx)*(-D(1:height-1,1:width-1)+D(1:height-1,2:width)...
        -D(2:height,1:width-1)+D(2:height,2:width));
Nxi=-Pi;
Nyi=-Qi;
Nzi=ones(height-1,width-1);
Ni=sqrt(Nxi.*Nxi + Nyi.*Nyi + 1);
Nxi=Nxi./Ni;
Nyi=Nyi./Ni;
Nzi=Nzi./Ni;
% quiver3(X(1:4:height-1,1:4:width-1),...
%     Y(1:4:height-1,1:4:width-1),...
%     Di(1:4:height-1,1:4:width-1),...
%     Nxi(1:4:height-1,1:4:width-1),...
%     Nyi(1:4:height-1,1:4:width-1),...
%     Nzi(1:4:height-1,1:4:width-1)),axis equal;
% surf(X(1:4:height-1,1:4:width-1),...
%     Y(1:4:height-1,1:4:width-1),...
%     Di(1:4:height-1,1:4:width-1)),axis equal;

O=zeros(height-1,width-1);
for h=1:height-1
    for w=1:width-1
        O(h,w)=Ci(h,w)*[Nxi(h,w),Nyi(h,w),Nzi(h,w)]*L;
    end
end

% height=height;
% width=width;
% [X,Y] = meshgrid(2:width-1,2:height-1);
% [Xe,Ye] = meshgrid(1:width,1:height);
% [Xi,Yi] = meshgrid(1.5:width-0.5,1.5:height-0.5);
% for h=1:height
%     for w=1:width
%         
%     end
% end

end

