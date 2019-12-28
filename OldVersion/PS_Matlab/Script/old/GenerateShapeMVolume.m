clear;
clc;
close all;
maxn=10;
maxwidth=2^maxn;
maxheight=2^maxn;
for n=6
    for Volume=1:32
        width=2^n;
        height=2^n;
        x=1:maxwidth;
        y=1:maxheight;
        dstPath=['F:\Files\Paper\Fast 3D reconstruction algorithm based on wavelet\Sample\MVolume3\' num2str(2^n) '\' num2str(Volume)  '\'];
        if ~exist(dstPath,'dir')
            mkdir(dstPath);
        end
        %% 
%          [X,Y,Z] =upsphere(x,y,maxwidth/2,maxheight/2,-Volume*2*maxwidth/(32*5),2*maxwidth/5,0);
        [X,Y,Z] =pyramid(x,y,1,maxwidth,1,maxheight,maxwidth/2,maxheight/2,8*maxwidth/16,0);        
        Z=Z-Volume*double(maxwidth)/64;
        for j=1:maxheight
            for i=1:maxwidth
                if Z(j,i)<0
                    Z(j,i)=0;
                end
            end
        end
        %[X,Y,Z] =pyramid(x,y,maxwidth/4,3*maxwidth/4,maxheight/4,3*maxheight/4,maxwidth/2,maxheight/2,Volume*maxwidth/16,0);

        X=int16(X(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
        Y=int16(Y(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
        Z=Z(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n));
        
        hpyramid=figure('name','pyramid');
        figure(hpyramid);
        colormap('jet');
        surf(X,Y,Z,'LineStyle','none'),axis equal;
        savefig(hpyramid,[dstPath 'pyramid_surf.fig']);
        print(hpyramid,'-djpeg',[dstPath 'pyramid_surf.jpg']);
        mesh(X,Y,Z),axis equal;
        savefig(hpyramid,[dstPath 'pyramid_mesh.fig']);
        print(hpyramid,'-djpeg',[dstPath 'pyramid_mesh.jpg']);
        
        save([dstPath 'pyramid.mat'],'X');
        save([dstPath 'pyramid.mat'],'Y','-append');
        save([dstPath 'pyramid.mat'],'Z','-append');
        imwrite(uint8(Reassign(Z,0,255)),[dstPath 'pyramid.bmp']);
        close all;
        
    end
end