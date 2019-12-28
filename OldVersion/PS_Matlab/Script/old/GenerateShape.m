clear;
clc;
close all;
maxn=10;
maxwidth=2^maxn;
maxheight=2^maxn;
n=5;
width=2^n;
height=2^n;
x=1:maxwidth;
y=1:maxheight;
dstPath=['E:\Files\Paper\´óÂÛÎÄ\Code\Self made\' num2str(2^n) '\'];
if ~exist(dstPath,'dir')
    mkdir(dstPath);
end
%% 
[X,Y] = meshgrid(x,y);
[Z] =20*peaks(maxwidth);
X=int16(X(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Y=int16(Y(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Z=Z(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n));

hpeaks=figure('name','peaks');
figure(hpeaks);
colormap('default');
surf(X,Y,Z,'LineStyle','none'),axis equal;
savefig(hpeaks,[dstPath 'peaks_surf.fig']);
print(hpeaks,'-djpeg',[dstPath 'peaks_surf.jpg']);
mesh(X,Y,Z),axis equal;
savefig(hpeaks,[dstPath 'peaks_mesh.fig']);
print(hpeaks,'-djpeg',[dstPath 'peaks_mesh.jpg']);

save([dstPath 'peaks.mat'],'X');
save([dstPath 'peaks.mat'],'Y','-append');
save([dstPath 'peaks.mat'],'Z','-append');
imwrite(uint8(Reassign(Z,0,255)),[dstPath 'peaks.bmp']);
close all;
%% 
[X,Y,Z] =mountain(x,y,maxwidth/2,maxheight/2,0.005,0.005,500);
X=int16(X(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Y=int16(Y(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Z=Z(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n));

hmountain=figure('name','mountain');
figure(hmountain);
colormap('default');
surf(X,Y,Z,'LineStyle','none'),axis equal;
savefig(hmountain,[dstPath 'mountain_surf.fig']);
print(hmountain,'-djpeg',[dstPath 'mountain_surf.jpg']);
mesh(X,Y,Z),axis equal;
savefig(hmountain,[dstPath 'mountain_mesh.fig']);
print(hmountain,'-djpeg',[dstPath 'mountain_mesh.jpg']);

save([dstPath 'mountain.mat'],'X');
save([dstPath 'mountain.mat'],'Y','-append');
save([dstPath 'mountain.mat'],'Z','-append');
imwrite(uint8(Reassign(Z,0,255)),[dstPath 'mountain.bmp']);
close all;
%% 
[X,Y,Z] =upsphere(x,y,maxwidth/2,maxheight/2,-maxwidth/7,2*maxwidth/5,0);
X=int16(X(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Y=int16(Y(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Z=Z(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n));

hupsphere=figure('name','upsphere');
figure(hupsphere);
colormap('default');
surf(X,Y,Z,'LineStyle','none'),axis equal;
savefig(hupsphere,[dstPath 'upsphere_surf.fig']);
print(hupsphere,'-djpeg',[dstPath 'upsphere_surf.jpg']);
mesh(X,Y,Z),axis equal;
savefig(hupsphere,[dstPath 'upsphere_mesh.fig']);
print(hupsphere,'-djpeg',[dstPath 'upsphere_mesh.jpg']);

save([dstPath 'upsphere.mat'],'X');
save([dstPath 'upsphere.mat'],'Y','-append');
save([dstPath 'upsphere.mat'],'Z','-append');
imwrite(uint8(Reassign(Z,0,255)),[dstPath 'upsphere.bmp']);
%close all;
%% 
[X,Y,Z] =downsphere(x,y,maxwidth/2,maxheight/2,maxwidth/3,maxwidth/2,0);
X=int16(X(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Y=int16(Y(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Z=Z(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n));

hdownsphere=figure('name','downsphere');
figure(hdownsphere);
colormap('default');
surf(X,Y,Z,'LineStyle','none'),axis equal;
savefig(hdownsphere,[dstPath 'downsphere_surf.fig']);
print(hdownsphere,'-djpeg',[dstPath 'downsphere_surf.jpg']);
mesh(X,Y,Z),axis equal;
savefig(hdownsphere,[dstPath 'downsphere_mesh.fig']);
print(hdownsphere,'-djpeg',[dstPath 'downsphere_mesh.jpg']);

save([dstPath 'downsphere.mat'],'X');
save([dstPath 'downsphere.mat'],'Y','-append');
save([dstPath 'downsphere.mat'],'Z','-append');
imwrite(uint8(Reassign(Z,0,255)),[dstPath 'downsphere.bmp']);
close all;
%% 
[X,Y,Z] =plane(x,y,0.1,0.1,0,-1000);
X=int16(X(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Y=int16(Y(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Z=Z(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n));

hplane=figure('name','plane');
figure(hplane);
colormap('default');
surf(X,Y,Z,'LineStyle','none'),axis equal;
savefig(hplane,[dstPath 'plane_surf.fig']);
print(hplane,'-djpeg',[dstPath 'plane_surf.jpg']);
mesh(X,Y,Z),axis equal;
savefig(hplane,[dstPath 'plane_mesh.fig']);
print(hplane,'-djpeg',[dstPath 'plane_mesh.jpg']);

save([dstPath 'plane.mat'],'X');
save([dstPath 'plane.mat'],'Y','-append');
save([dstPath 'plane.mat'],'Z','-append');
imwrite(uint8(Reassign(Z,0,255)),[dstPath 'plane.bmp']);
close all;
%% 
[X,Y,Z] =sinx(x,y,0.01,0,100,0,-1000);
X=int16(X(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Y=int16(Y(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Z=Z(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n));

hsinx=figure('name','sinx');
figure(hsinx);
colormap('default');
surf(X,Y,Z,'LineStyle','none'),axis equal;
savefig(hsinx,[dstPath 'sinx_surf.fig']);
print(hsinx,'-djpeg',[dstPath 'sinx_surf.jpg']);
mesh(X,Y,Z),axis equal;
savefig(hsinx,[dstPath 'sinx_mesh.fig']);
print(hsinx,'-djpeg',[dstPath 'sinx_mesh.jpg']);

save([dstPath 'sinx.mat'],'X');
save([dstPath 'sinx.mat'],'Y','-append');
save([dstPath 'sinx.mat'],'Z','-append');
imwrite(uint8(Reassign(Z,0,255)),[dstPath 'sinx.bmp']);
close all;
%% 
[X,Y,Z] =sinx_y(x,y,0.02,0,50,0.02,0,50,0,-1000);
X=int16(X(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Y=int16(Y(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Z=Z(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n));

hsinx_y=figure('name','sinx_y');
figure(hsinx_y);
colormap('default');
surf(X,Y,Z,'LineStyle','none'),axis equal;
savefig(hsinx_y,[dstPath 'sinx_y_surf.fig']);
print(hsinx_y,'-djpeg',[dstPath 'sinx_y_surf.jpg']);
mesh(X,Y,Z),axis equal;
savefig(hsinx_y,[dstPath 'sinx_y_mesh.fig']);
print(hsinx_y,'-djpeg',[dstPath 'sinx_y_mesh.jpg']);

save([dstPath 'sinx_y.mat'],'X');
save([dstPath 'sinx_y.mat'],'Y','-append');
save([dstPath 'sinx_y.mat'],'Z','-append');
imwrite(uint8(Reassign(Z,0,255)),[dstPath 'sinx_y.bmp']);
close all;
%% 
[X,Y,Z] =sinxy_(x,y,0.02,0.02,0,100,0,-1000);
X=int16(X(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Y=int16(Y(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Z=Z(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n));

hsinxy_=figure('name','sinxy_');
figure(hsinxy_);
colormap('default');
surf(X,Y,Z,'LineStyle','none'),axis equal;
savefig(hsinxy_,[dstPath 'sinxy__surf.fig']);
print(hsinxy_,'-djpeg',[dstPath 'sinxy__surf.jpg']);
mesh(X,Y,Z),axis equal;
savefig(hsinxy_,[dstPath 'sinxy__mesh.fig']);
print(hsinxy_,'-djpeg',[dstPath 'sinxy__mesh.jpg']);

save([dstPath 'sinxy_.mat'],'X');
save([dstPath 'sinxy_.mat'],'Y','-append');
save([dstPath 'sinxy_.mat'],'Z','-append');
imwrite(uint8(Reassign(Z,0,255)),[dstPath 'sinxy_.bmp']);
close all;
%% 
[X,Y,Z] =gauss2d(x,y,300,-pi/6,200,100,-1);
X=int16(X(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Y=int16(Y(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Z=Z(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n));

hgauss2d=figure('name','gauss2d');
figure(hgauss2d);
colormap('default');
surf(X,Y,Z,'LineStyle','none'),axis equal;
savefig(hgauss2d,[dstPath 'gauss2d_surf.fig']);
print(hgauss2d,'-djpeg',[dstPath 'gauss2d_surf.jpg']);
mesh(X,Y,Z),axis equal;
savefig(hgauss2d,[dstPath 'gauss2d_mesh.fig']);
print(hgauss2d,'-djpeg',[dstPath 'gauss2d_mesh.jpg']);

save([dstPath 'gauss2d.mat'],'X');
save([dstPath 'gauss2d.mat'],'Y','-append');
save([dstPath 'gauss2d.mat'],'Z','-append');
imwrite(uint8(Reassign(Z,0,255)),[dstPath 'gauss2d.bmp']);
close all;

%% 
[X,Y,Z] =sinc2d(x,y,300,0.02,0.02,-100);
X=int16(X(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Y=int16(Y(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Z=Z(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n));

hsinc2d=figure('name','sinc2d');
figure(hsinc2d);
colormap('default');
surf(X,Y,Z,'LineStyle','none'),axis equal;
savefig(hsinc2d,[dstPath 'sinc2d_surf.fig']);
print(hsinc2d,'-djpeg',[dstPath 'sinc2d_surf.jpg']);
mesh(X,Y,Z),axis equal;
savefig(hsinc2d,[dstPath 'sinc2d_mesh.fig']);
print(hsinc2d,'-djpeg',[dstPath 'sinc2d_mesh.jpg']);

save([dstPath 'sinc2d.mat'],'X');
save([dstPath 'sinc2d.mat'],'Y','-append');
save([dstPath 'sinc2d.mat'],'Z','-append');
imwrite(uint8(Reassign(Z,0,255)),[dstPath 'sinc2d.bmp']);
%close all;

%% 
% [X,Y,Z] =log2d(x,y,1000000000000,200);
% X=X(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth);
% Y=Y(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth);
% Z=Z(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth);
% 
% hlog2d=figure('name','log2d');
% figure(hlog2d);
% colormap('gray');
% surf(X,Y,Z,'LineStyle','none'),axis equal;
% savefig(hlog2d,[dstPath 'log2d_surf.fig']);
% print(hlog2d,'-djpeg',[dstPath 'log2d_surf.jpg']);
% mesh(X,Y,Z),axis equal;
% savefig(hlog2d,[dstPath 'log2d_mesh.fig']);
% print(hlog2d,'-djpeg',[dstPath 'log2d_mesh.jpg']);
% 
% save([dstPath 'log2d.mat'],'X');
% save([dstPath 'log2d.mat'],'Y','-append');
% save([dstPath 'log2d.mat'],'Z','-append');
% imwrite(uint8(Reassign(Z,0,255)),[dstPath 'log2d.bmp']);
% close all;