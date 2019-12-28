clear;
%Times   FI  PS  MI  MO  WI  WO
% n=4
% n=5
% n=6
% n=7
% n=8
% n=9
% n=10
TimeMat=zeros(10,7,'double');
errPQMat=zeros(10,7,'double');
for n=3:8
    clc;
    close all;
    %n=4;
    width=2^n;
    height=2^n;
    x=1:width;
    y=1:height;
    dstPath=['F:\Files\Paper\Fast 3D reconstruction algorithm based on wavelet\Sample\MSize\' num2str(2^n) '\'];
    if ~exist(dstPath,'dir')
        error('File not exist');
    end
    [Num PathArray NameArray] =LoadMatFiles(dstPath);
    for i=1:Num
        close all;
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
        
        InfoOut_FourWayIntegrat=load([dstPath leftName '.mat'],'InfoOut_FourWayIntegrat');
        InfoOut_FourWayIntegrat=InfoOut_FourWayIntegrat.InfoOut_FourWayIntegrat;
        TimeMat(n,1)=InfoOut_FourWayIntegrat{2,1};
        errPQMat(n,1)=InfoOut_FourWayIntegrat{2,2};
        
        InfoOut_PossionSolverOptimize=load([dstPath leftName '.mat'],'InfoOut_PossionSolverOptimize');
        InfoOut_PossionSolverOptimize=InfoOut_PossionSolverOptimize.InfoOut_PossionSolverOptimize;
        TimeMat(n,2)=InfoOut_PossionSolverOptimize{2,1};
        errPQMat(n,2)=InfoOut_PossionSolverOptimize{2,4};
        
        InfoOut_MultiScaleIntegrat=load([dstPath leftName '.mat'],'InfoOut_MultiScaleIntegrat');
        InfoOut_MultiScaleIntegrat=InfoOut_MultiScaleIntegrat.InfoOut_MultiScaleIntegrat;
        TimeMat(n,3)=InfoOut_MultiScaleIntegrat{2,1};
        errPQMat(n,3)=InfoOut_MultiScaleIntegrat{2,5}(1);
        
        InfoOut_MultiScaleOptimize=load([dstPath leftName '.mat'],'InfoOut_MultiScaleOptimize');
        InfoOut_MultiScaleOptimize=InfoOut_MultiScaleOptimize.InfoOut_MultiScaleOptimize;
        TimeMat(n,4)=InfoOut_MultiScaleOptimize{2,1};
        errPQMat(n,4)=InfoOut_MultiScaleOptimize{2,5}(1);
        
        InfoOut_WaveletIntegrat=load([dstPath leftName '.mat'],'InfoOut_WaveletIntegrat');
        InfoOut_WaveletIntegrat=InfoOut_WaveletIntegrat.InfoOut_WaveletIntegrat;
        TimeMat(n,5)=InfoOut_WaveletIntegrat{2,1};
        errPQMat(n,5)=InfoOut_WaveletIntegrat{2,5}(1);
        
        InfoOut_WaveletOptimize=load([dstPath leftName '.mat'],'InfoOut_WaveletOptimize');
        InfoOut_WaveletOptimize=InfoOut_WaveletOptimize.InfoOut_WaveletOptimize;
        TimeMat(n,6)=InfoOut_WaveletOptimize{2,1};
        errPQMat(n,6)=InfoOut_WaveletOptimize{2,5}(1);
        
        InfoOut_FFTIntegrate=load([dstPath leftName '.mat'],'InfoOut_FFTIntegrate');
        InfoOut_FFTIntegrate=InfoOut_FFTIntegrate.InfoOut_FFTIntegrate;
        TimeMat(n,7)=InfoOut_FFTIntegrate{2,1};
        errPQMat(n,7)=InfoOut_FFTIntegrate{2,5}(1);
    end
end