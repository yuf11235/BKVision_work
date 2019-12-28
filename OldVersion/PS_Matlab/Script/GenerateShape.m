x=0:31;
y=0:31;
[X,Y,Z,P,Q,N_x,N_y,N_z] = gaussian2d(x,y,16,16,4,2,2,5*pi/180);

% hmountain=figure('name','mountain');
% figure(hmountain);
% colormap('default');
subplot1 = subplot(2,3,1);imagesc(Z),axis equal,xlim(subplot1,[1 32]),ylim(subplot1,[1 32]);
subplot2 = subplot(2,3,2),quiver(X,Y,N_x,N_y),axis equal,xlim(subplot2,[0 31]),ylim(subplot2,[0 31]);
subplot3 = subplot(2,3,3),quiver3(X,Y,Z,N_x,N_y,N_z),axis equal;
subplot4 = subplot(2,3,4);imagesc(P),axis equal,xlim(subplot4,[1 32]),ylim(subplot4,[1 32]);
subplot5 = subplot(2,3,5);imagesc(Q),axis equal,xlim(subplot5,[1 32]),ylim(subplot5,[1 32]);
% subplot6 = subplot(2,3,6);imagesc(Q),axis equal,xlim(subplot6,[1 32]),ylim(subplot6,[1 32]);
% mesh(X,Y,Z),axis equal;


% clc;
% close all;
% maxn=10;
% maxwidth=2^maxn;
% maxheight=2^maxn;
% n=5;
% width=2^n;
% height=2^n;
% x=1:maxwidth;
% y=1:maxheight;
% dstPath=['E:\Files\Paper\´óÂÛÎÄ\Code\Self made\' num2str(2^n) '\'];
% if ~exist(dstPath,'dir')
%     mkdir(dstPath);
% end
% %% 
% [X,Y,Z] =mountain(x,y,maxwidth/2,maxheight/2,0.005,0.005,500);
% X=int16(X(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
% Y=int16(Y(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
% Z=Z(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n));
% 
% hmountain=figure('name','mountain');
% figure(hmountain);
% colormap('default');
% surf(X,Y,Z,'LineStyle','none'),axis equal;
% savefig(hmountain,[dstPath 'mountain_surf.fig']);
% print(hmountain,'-djpeg',[dstPath 'mountain_surf.jpg']);
% mesh(X,Y,Z),axis equal;
% savefig(hmountain,[dstPath 'mountain_mesh.fig']);
% print(hmountain,'-djpeg',[dstPath 'mountain_mesh.jpg']);
% 
% save([dstPath 'mountain.mat'],'X');
% save([dstPath 'mountain.mat'],'Y','-append');
% save([dstPath 'mountain.mat'],'Z','-append');
% imwrite(uint8(Reassign(Z,0,255)),[dstPath 'mountain.bmp']);
% close all;