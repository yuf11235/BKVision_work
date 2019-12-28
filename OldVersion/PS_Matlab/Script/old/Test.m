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
%% 
[X,Y,Z] =upsphere(x,y,maxwidth/2,maxheight/2,-maxwidth/7,2*maxwidth/5,0);
X=int16(X(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Y=int16(Y(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n)));
Z=Z(1:2^(maxn-n):maxheight,1:2^(maxn-n):maxwidth)/(2^(maxn-n));

hupsphere=figure('name','upsphere');
figure(hupsphere);
colormap('default');
mesh(X,Y,Z),axis equal;

[P,Q] = Deep2Gradient(Z,1);
[PP,QQ] = Deep2Gradient(Z,0);
%% 
[Z_FFTIntegrate,InfoOut_FFTIntegrate] = FFTIntegrate(PP,QQ,{0,0,NaN,NaN,NaN});
InfoOut_FFTIntegrate
hFigure3D=figure('Name','3D');
figure(hFigure3D);
colormap('jet');
mesh(Z_FFTIntegrate),title('Z:FFTIntegrate'),axis equal%;
