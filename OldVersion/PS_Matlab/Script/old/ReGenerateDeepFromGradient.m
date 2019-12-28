%clear;
clc;
close all;
n=4;
width=2^n;
height=2^n;
x=1:width;
y=1:height;
dstPath=['E:\Files\Paper\Fast 3D reconstruction algorithm based on wavelet\Sample\' num2str(2^n) '\'];
if ~exist(dstPath,'dir')
    error('File not exist');
end
[Num PathArray NameArray] =LoadMatFiles(dstPath);
for i=1:Num
    leftName=NaN;
    leftNamelong=NameArray(i,:);
    leftName= StrDelTail(leftNamelong);
    leftNameLen=length(leftName)-4;
    leftName=leftName(1,1:leftNameLen);
    [dstPath leftName '.mat']
    Z=load([dstPath leftName '.mat'],'Z');
    Z=Z.Z;
    X=load([dstPath leftName '.mat'],'X');
    X=X.X;
    Y=load([dstPath leftName '.mat'],'Y');
    Y=Y.Y;
    P=load([dstPath leftName '.mat'],'P');
    P=P.P;
    Q=load([dstPath leftName '.mat'],'Q');
    Q=Q.Q;
    PP=load([dstPath leftName '.mat'],'PP');
    PP=PP.PP;
    QQ=load([dstPath leftName '.mat'],'QQ');
    QQ=QQ.QQ;
    Nx=load([dstPath leftName '.mat'],'Nx');
    Nx=Nx.Nx;
    Ny=load([dstPath leftName '.mat'],'Ny');
    Ny=Ny.Ny;
    Nz=load([dstPath leftName '.mat'],'Nz');
    Nz=Nz.Nz;
    VolumeUp=load([dstPath leftName '.mat'],'VolumeUp');
    VolumeUp=VolumeUp.VolumeUp;
    VolumeDown=load([dstPath leftName '.mat'],'VolumeDown');
    VolumeDown=VolumeDown.VolumeDown;
    
    %% FourWayIntegration
    [Z_FourWayIntegrat,InfoOut_FourWayIntegrat] = FourWayIntegrat(P,Q);
    save([dstPath leftName '.mat'],'Z_FourWayIntegrat','-append');
    save([dstPath leftName '.mat'],'InfoOut_FourWayIntegrat','-append');
    InfoOut_FourWayIntegrat
    hFigure3D=figure('Name','3D');
    figure(hFigure3D);
    subplot(2,2,1),mesh(Z_FourWayIntegrat),title('Z_FourWayIntegrat'),axis equal;
    
%     hFigure1=figure('Name','errZ & errPQ');
%     figure(hFigure1);
    [Z_PossionSolverOptimize,InfoOut_PossionSolverOptimize] = PossionSolverOptimize(PP,QQ,NaN,{2000,-1,0.001},1,NaN);
    save([dstPath leftName '.mat'],'Z_PossionSolverOptimize','-append');
    save([dstPath leftName '.mat'],'InfoOut_PossionSolverOptimize','-append');
    InfoOut_PossionSolverOptimize
    figure(hFigure3D);
    subplot(2,2,2),mesh(Z_PossionSolverOptimize),title('Z_PossionSolverOptimize'),axis equal;
   
%     hFigure2=figure('Name','MultiScaleIntegrat');
%     figure(hFigure2);
    [Z_MultiScaleIntegrat,InfoOut_MultiScaleIntegrat] = MultiScaleIntegrat(PP,QQ,NaN,{6000,-1,0.001,4},1,NaN);
    save([dstPath leftName '.mat'],'Z_MultiScaleIntegrat','-append');
    save([dstPath leftName '.mat'],'InfoOut_MultiScaleIntegrat','-append');
    InfoOut_MultiScaleIntegrat
    figure(hFigure3D);
    subplot(2,2,3),mesh(Z_MultiScaleIntegrat),axis equal,title('Z_MultiScaleIntegrat');
    
%     hFigure3=figure('Name','MultiScaleOptimize');
%     figure(hFigure3);
    [Z_MultiScaleOptimize,InfoOut_MultiScaleOptimize] = MultiScaleOptimize(PP,QQ,NaN,{6000,-1,0.001,4},1,NaN);
    save([dstPath leftName '.mat'],'Z_MultiScaleOptimize','-append');
    save([dstPath leftName '.mat'],'InfoOut_MultiScaleOptimize','-append');
    InfoOut_MultiScaleOptimize
    figure(hFigure3D);
    subplot(2,2,4),mesh(Z_MultiScaleOptimize),axis equal,title('Z_MultiScaleOptimize');
    
    if isnan(timeAllList)
        nList=n;
        timeAllList=[InfoOut_FourWayIntegrat(2,1) InfoOut_PossionSolverOptimize(2,1) InfoOut_MultiScaleIntegrat(2,1) InfoOut_MultiScaleOptimize(2,1)];
        volumeUpList=VolumeUp;
        volumeDownList=VolumeDown;
    else
        nList=[nList;n];
        timeAllList=[timeAllList;InfoOut_FourWayIntegrat(2,1) InfoOut_PossionSolverOptimize(2,1) InfoOut_MultiScaleIntegrat(2,1) InfoOut_MultiScaleOptimize(2,1)];
        volumeUpList=[volumeUpList;VolumeUp];
        volumeDownList=[volumeDownList;VolumeDown];
    end
end