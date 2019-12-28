clear;
%Times   FI  PS  FI_PS  MO  WI  WO
% V=1
% n=2
% n=3
% n=4
% n=5
% n=6
% n=7
% n=8
% n=9
% n=10
% n=11
% n=12
TimeMat=zeros(32,6,'double');
errPQMat=zeros(32,6,'double');
VolumeUpMat=zeros(32,6,'double');
VolumeDownMat=zeros(32,6,'double');
for n=7
    for Volume=1:32
        clc;
        close all;
        %n=4;
        width=2^n;
        height=2^n;
        x=1:width;
        y=1:height;
        dstPath=['F:\Files\Paper\Fast 3D reconstruction algorithm based on wavelet\Sample\MVolume3\' num2str(2^n) '\' num2str(Volume)  '\']
        if ~exist(dstPath,'dir')
            error('File not exist');
        end
        [Num PathArray NameArray] =LoadMatFiles(dstPath);
        for i=1:Num
            i
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
            VolumeUpMat(Volume,:)=ones(1,6,'double')*VolumeUp;
            VolumeDown=load([dstPath leftName '.mat'],'VolumeDown');
            VolumeDown=VolumeDown.VolumeDown;
            VolumeDownMat(Volume,:)=ones(1,6,'double')*VolumeDown;

            InfoOut_FourWayIntegrat=load([dstPath leftName '.mat'],'InfoOut_FourWayIntegrat');
            InfoOut_FourWayIntegrat=InfoOut_FourWayIntegrat.InfoOut_FourWayIntegrat;
            TimeMat(Volume,1)=InfoOut_FourWayIntegrat{2,1};
            errPQMat(Volume,1)=InfoOut_FourWayIntegrat{2,2};

            InfoOut_PossionSolverOptimize=load([dstPath leftName '.mat'],'InfoOut_PossionSolverOptimize');
            InfoOut_PossionSolverOptimize=InfoOut_PossionSolverOptimize.InfoOut_PossionSolverOptimize;
            TimeMat(Volume,2)=InfoOut_PossionSolverOptimize{2,1};
            errPQMat(Volume,2)=InfoOut_PossionSolverOptimize{2,4};       
            
            InfoOut_FI_PS=load([dstPath leftName '.mat'],'InfoOut_FI_PS');
            InfoOut_FI_PS=InfoOut_FI_PS.InfoOut_FI_PS;
            TimeMat(Volume,3)=InfoOut_FI_PS{2,1};
            errPQMat(Volume,3)=InfoOut_FI_PS{2,4};

%             InfoOut_MultiScaleIntegrat=load([dstPath leftName '.mat'],'InfoOut_MultiScaleIntegrat');
%             InfoOut_MultiScaleIntegrat=InfoOut_MultiScaleIntegrat.InfoOut_MultiScaleIntegrat;
%             TimeMat(n,4)=InfoOut_MultiScaleIntegrat{2,1};
%             errPQMat(n,4)=InfoOut_MultiScaleIntegrat{2,5}(1);

            InfoOut_MultiScaleOptimize=load([dstPath leftName '.mat'],'InfoOut_MultiScaleOptimize');
            InfoOut_MultiScaleOptimize=InfoOut_MultiScaleOptimize.InfoOut_MultiScaleOptimize;
            TimeMat(Volume,4)=InfoOut_MultiScaleOptimize{2,1};
            errPQMat(Volume,4)=InfoOut_MultiScaleOptimize{2,5}(1);

            InfoOut_WaveletIntegrat=load([dstPath leftName '.mat'],'InfoOut_WaveletIntegrat');
            InfoOut_WaveletIntegrat=InfoOut_WaveletIntegrat.InfoOut_WaveletIntegrat;
            TimeMat(Volume,5)=InfoOut_WaveletIntegrat{2,1};
            errPQMat(Volume,5)=InfoOut_WaveletIntegrat{2,5}(1);

            InfoOut_WaveletOptimize=load([dstPath leftName '.mat'],'InfoOut_WaveletOptimize');
            InfoOut_WaveletOptimize=InfoOut_WaveletOptimize.InfoOut_WaveletOptimize;
            TimeMat(Volume,6)=InfoOut_WaveletOptimize{2,1};
            errPQMat(Volume,6)=InfoOut_WaveletOptimize{2,5}(1);    
            
            InfoOut_MultiScaleOptimizeNoIni=load([dstPath leftName '.mat'],'InfoOut_MultiScaleOptimizeNoIni');
            InfoOut_MultiScaleOptimizeNoIni=InfoOut_MultiScaleOptimizeNoIni.InfoOut_MultiScaleOptimizeNoIni;
            TimeMat(Volume,7)=InfoOut_MultiScaleOptimizeNoIni{2,1};
            errPQMat(Volume,7)=InfoOut_MultiScaleOptimizeNoIni{2,5}(1);

        end
    end
end

%% 取消注释以下行以保留轴的 X 极限

hlog=figure(101);
 axes1 = axes('Parent',hlog);%,'YScale','log','YMinorTick','on',...
%     'XScale','log',...
%     'XMinorTick','on');
box(axes1,'on');
hold(axes1,'all');
% xlim(axes1,[0 65]);
% 创建 xlabel
xlabel('Volume');

% 创建 ylabel
ylabel('Time (s)');

% 使用 loglog 的矩阵输入创建多行
loglog1 = plot([VolumeDownMat(1:32,2:4) VolumeDownMat(1:32,6)],[TimeMat(1:32,2:3) TimeMat(1:32,7) TimeMat(1:32,4)],...
    'Parent',axes1);
% set(loglog1(1),'Marker','o','DisplayName','FI');
set(loglog1(1),'Marker','square','DisplayName','PS','Color',[0 0.498039215803146 0]);
set(loglog1(2),'Marker','+','DisplayName','FI+PS','Color',[0 0 0]);
set(loglog1(3),'Marker','x','DisplayName','MPS','Color',[0 1 1]);
% set(loglog1(5),'Marker','*','DisplayName','WI');
set(loglog1(4),'Marker','v','DisplayName','WO','Color',[1 0 0]);
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.704923127088048 0.541181746190536 0.163291139240506 0.277777777777778]);