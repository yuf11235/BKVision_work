% Lamda=(-60:1:60)*pi/180;
% % I = BRDF_TS(Lamda,30*pi/180,0.5,0.5,0.001);
% subplot(2,2,1),plot(Lamda,BRDF_TS(Lamda,30*pi/180,0.1,0.1,0.1));
% subplot(2,2,2),plot(Lamda,BRDF_TS(Lamda,30*pi/180,0.0,1.0,0.1));
% subplot(2,2,3),plot(Lamda,BRDF_TS(Lamda,30*pi/180,0.1,0.1,0.2));
% subplot(2,2,4),plot(Lamda,BRDF_TS(Lamda,30*pi/180,0.0,1.0,0.2));

img=imread('E:\Files\Paper\´óÂÛÎÄ\Code\sample\3_in_001.bmp');

x=0:127;
y=0:127;
[X,Y,Z,P,Q,N_x,N_y,N_z] = gaussian2d(x,y,64,64,12,6,1,5*pi/180);
height=length(y);
width=length(x);
% C= double(ones(height,width));
CR= double(img(:,:,1))/255;
CG= double(img(:,:,2))/255;
IR = RenderShapeLinerLight(CR,Q,@(gamma)BRDF_TS(gamma,20*pi/180,1.2,0.4,0.2));
IG = RenderShapeLinerLight(CG,Q,@(gamma)BRDF_TS(gamma,-20*pi/180,1.2,0.4,0.2));
IRGB = uint8(zeros(height,width,3));
IRGB(:,:,1)=uint8(IR*255);
IRGB(:,:,2)=uint8(IG*255);
II=(IR-IG)./(IR+IG);
subplot1 = subplot(2,3,1),imagesc(Z),axis equal,axis off,xlim(subplot1,[1 width]),ylim(subplot1,[1 height]);
subplot2 = subplot(2,3,2),imagesc(Q),axis equal,axis off,xlim(subplot2,[1 width]),ylim(subplot2,[1 height]);
subplot3 = subplot(2,3,3),imshow(IR),axis equal,axis off,xlim(subplot3,[1 width]),ylim(subplot3,[1 height]);
subplot4 = subplot(2,3,4),imshow(IG),axis equal,axis off,xlim(subplot4,[1 width]),ylim(subplot4,[1 height]);
subplot5 = subplot(2,3,5),imshow(IRGB),axis equal,axis off,xlim(subplot5,[1 width]),ylim(subplot5,[1 height]);
subplot6 = subplot(2,3,6),imagesc(atan(cot(30*pi/180)*II)),axis equal,axis off,xlim(subplot6,[1 width]),ylim(subplot6,[1 height]);

