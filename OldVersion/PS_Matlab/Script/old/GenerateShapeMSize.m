clear;
clc;
close all;
maxn=10;
maxwidth=2^maxn;
maxheight=2^maxn;
for n=3:10
    width=2^n;
    height=2^n;
    x=1:maxwidth;
    y=1:maxheight;
    dstPath=['F:\Files\Paper\Fast 3D reconstruction algorithm based on wavelet\Sample\MSize\' num2str(2^n) '\'];
    if ~exist(dstPath,'dir')
        mkdir(dstPath);
    end
    %% 
    [X,Y,Z] =upsphere(x,y,maxwidth/2,maxheight/2,-maxwidth/7,2*maxwidth/5,0);
    X=int16(X(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
    Y=int16(Y(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
    Z=Z(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/((2^(maxn-n)));

    hupsphere=figure('name','upsphere');
    figure(hupsphere);
    colormap('jet');
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
    % %close all;
    % %% 
    % [X,Y,Z] =downsphere(x,y,maxwidth/2,maxheight/2,maxwidth/7,2*maxwidth/5,0);
    % X=int16(X(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
    % Y=int16(Y(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
    % Z=Z(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n));
    % 
    % hdownsphere=figure('name','downsphere');
    % figure(hdownsphere);
    % colormap('jet');
    % surf(X,Y,Z,'LineStyle','none'),axis equal;
    % savefig(hdownsphere,[dstPath 'downsphere_surf.fig']);
    % print(hdownsphere,'-djpeg',[dstPath 'downsphere_surf.jpg']);
    % mesh(X,Y,Z),axis equal;
    % savefig(hdownsphere,[dstPath 'downsphere_mesh.fig']);
    % print(hdownsphere,'-djpeg',[dstPath 'downsphere_mesh.jpg']);
    % 
    % save([dstPath 'downsphere.mat'],'X');
    % save([dstPath 'downsphere.mat'],'Y','-append');
    % save([dstPath 'downsphere.mat'],'Z','-append');
    % imwrite(uint8(Reassign(Z,0,255)),[dstPath 'downsphere.bmp']);
    % close all;
    % %% 
    % [X,Y,Z] =pyramid(x,y,maxwidth/4,3*maxwidth/4,maxheight/4,3*maxheight/4,maxwidth/2,maxheight/2,maxwidth/3,0);
    % X=int16(X(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
    % Y=int16(Y(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
    % Z=Z(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n));
    % 
    % hpyramid=figure('name','pyramid');
    % figure(hpyramid);
    % colormap('jet');
    % surf(X,Y,Z,'LineStyle','none'),axis equal;
    % savefig(hpyramid,[dstPath 'pyramid_surf.fig']);
    % print(hpyramid,'-djpeg',[dstPath 'pyramid_surf.jpg']);
    % mesh(X,Y,Z),axis equal;
    % savefig(hpyramid,[dstPath 'pyramid_mesh.fig']);
    % print(hpyramid,'-djpeg',[dstPath 'pyramid_mesh.jpg']);
    % 
    % save([dstPath 'pyramid.mat'],'X');
    % save([dstPath 'pyramid.mat'],'Y','-append');
    % save([dstPath 'pyramid.mat'],'Z','-append');
    % imwrite(uint8(Reassign(Z,0,255)),[dstPath 'pyramid.bmp']);
    % close all;
    % 
    % %% 
    % [X,Y,Z] =sinc2d(x,y,300,0.02,0.02,-100);
    % X=int16(X(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
    % Y=int16(Y(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
    % Z=Z(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n));
    % 
    % hsinc2d=figure('name','sinc2d');
    % figure(hsinc2d);
    % colormap('jet');
    % surf(X,Y,Z,'LineStyle','none'),axis equal;
    % savefig(hsinc2d,[dstPath 'sinc2d_surf.fig']);
    % print(hsinc2d,'-djpeg',[dstPath 'sinc2d_surf.jpg']);
    % mesh(X,Y,Z),axis equal;
    % savefig(hsinc2d,[dstPath 'sinc2d_mesh.fig']);
    % print(hsinc2d,'-djpeg',[dstPath 'sinc2d_mesh.jpg']);
    % 
    % save([dstPath 'sinc2d.mat'],'X');
    % save([dstPath 'sinc2d.mat'],'Y','-append');
    % save([dstPath 'sinc2d.mat'],'Z','-append');
    % imwrite(uint8(Reassign(Z,0,255)),[dstPath 'sinc2d.bmp']);
    % close all;
end