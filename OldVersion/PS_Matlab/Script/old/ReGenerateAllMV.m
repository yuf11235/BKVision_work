clear;
for n=7
    for Volume=1:32
        clc;
        close all;
        %n=4;
        width=2^n;
        height=2^n;
        x=1:width;
        y=1:height;
        dstPath=['F:\Files\Paper\Fast 3D reconstruction algorithm based on wavelet\Sample\MVolume3\' num2str(2^n) '\' num2str(Volume)  '\'];
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

            figure(100);
            %titleStr=['phyR=' num2str(phyR) ' phyG=' num2str(phyG) ' phyB=' num2str(phyB)];
            [HNx,WNx]=size(Nx);
            quiver(Nx(1:1:HNx,1:1:WNx),Ny(1:1:HNx,1:1:WNx)),axis equal;%title(titleStr),
            %% Add noise

            minPP=min(min(PP));
            maxPP=max(max(PP));
            minQQ=min(min(QQ));
            maxQQ=max(max(QQ));
    %         PPN=imnoise((PP-minPP)/(maxPP-minPP),'gaussian',0,0.01)*(maxPP-minPP)+minPP;
    %         QQN=imnoise((QQ-minQQ)/(maxQQ-minQQ),'gaussian',0,0.01)*(maxQQ-minQQ)+minQQ;
            PPN=PP;
            QQN=QQ;

            %% FourWayIntegration
    %         [Z_FFTIntegrate,InfoOut_FFTIntegrate] = FFTIntegrate(PP,QQ,{0,0,NaN,NaN,NaN});
    %         subplot(3,2,1),mesh(Z_FFTIntegrate),title('Z:FFTIntegrate');%,axis equal;
    %         save([dstPath leftName '.mat'],'Z_FFTIntegrate','-append');
    %         save([dstPath leftName '.mat'],'InfoOut_FFTIntegrate','-append');
    %         InfoOut_FFTIntegrate
    %         hFigure3D=figure('Name','3D');
    %         figure(hFigure3D);
    %         subplot(3,2,1),mesh(Z_FFTIntegrate),title('Z:FFTIntegrate'),axis equal;
            colormap('jet');
            figure(1);
            mesh(Z),axis equal;%,title('Z:FourWayIntegrat')

           %% FourWayIntegration
            figure(2);
            colormap('jet');
            [Z_FourWayIntegrat,InfoOut_FourWayIntegrat] = FourWayIntegrate(PPN,QQN);
            save([dstPath leftName '.mat'],'Z_FourWayIntegrat','-append');
            save([dstPath leftName '.mat'],'InfoOut_FourWayIntegrat','-append');
            InfoOut_FourWayIntegrat
            mesh(Z_FourWayIntegrat),axis equal;%,title('Z:FourWayIntegrat')    
            figure(3);
            colormap('jet');
            mesh(Z_FourWayIntegrat-Z-min(min(Z_FourWayIntegrat-Z))),...%,title('Z:FourWayIntegrat')
                colorbar('southoutside','Position',[0.599567474048442 0.202380952380952 0.305789668808701 0.0464197530864191]),axis equal; 


            figure(4);
            colormap('jet');
            [Z_PossionSolverOptimize,InfoOut_PossionSolverOptimize] = PossionSolverOptimize(PPN,QQN,NaN,{-1,-1,0.001},1,NaN);
            save([dstPath leftName '.mat'],'Z_PossionSolverOptimize','-append');
            save([dstPath leftName '.mat'],'InfoOut_PossionSolverOptimize','-append');
            InfoOut_PossionSolverOptimize
            mesh(Z_PossionSolverOptimize),axis equal;%,title('Z:FourWayIntegrat')
            figure(5);
            colormap('jet');
            mesh(Z_PossionSolverOptimize-Z-min(min(Z_PossionSolverOptimize-Z))),...%,title('Z:FourWayIntegrat')
                colorbar('southoutside','Position',[0.599567474048442 0.202380952380952 0.305789668808701 0.0464197530864191]),axis equal; 

            figure(6);
            colormap('jet');
            [Z_FI,InfoOut_FI] = FourWayIntegrate(PPN,QQN);
            [Z_FI_PS,InfoOut_FI_PS] = PossionSolverOptimize(PPN,QQN,Z_FI,{-1,-1,0.001},1,NaN);
            InfoOut_FI_PS{2,1}=InfoOut_FI_PS{2,1}+InfoOut_FI{2,1};
            save([dstPath leftName '.mat'],'Z_FI_PS','-append');
            save([dstPath leftName '.mat'],'InfoOut_FI_PS','-append');
            InfoOut_FI_PS
            mesh(Z_FI_PS),axis equal;%,title('Z:FourWayIntegrat')
            figure(7);
            colormap('jet');
            mesh(Z_FI_PS-Z-min(min(Z_FI_PS-Z))),...%,title('Z:FourWayIntegrat')
                colorbar('southoutside','Position',[0.599567474048442 0.202380952380952 0.305789668808701 0.0464197530864191]),axis equal; 
            
            figure(8);
            colormap('jet');
            [Z_MultiScaleIntegrat,InfoOut_MultiScaleIntegrat] = MultiScaleIntegrate(PPN,QQN,NaN,{-1,-1,0.001,4},1,NaN);
            save([dstPath leftName '.mat'],'Z_MultiScaleIntegrat','-append');
            save([dstPath leftName '.mat'],'InfoOut_MultiScaleIntegrat','-append');
            InfoOut_MultiScaleIntegrat
            mesh(Z_MultiScaleIntegrat),axis equal;%,title('Z:FourWayIntegrat')
            figure(9);
            colormap('jet');
            mesh(Z_MultiScaleIntegrat-Z-min(min(Z_MultiScaleIntegrat-Z))),...%,title('Z:FourWayIntegrat')
                colorbar('southoutside','Position',[0.599567474048442 0.202380952380952 0.305789668808701 0.0464197530864191]),axis equal; 

            figure(10);
            colormap('jet');
            [Z_MultiScaleOptimize,InfoOut_MultiScaleOptimize] = MultiScaleOptimize(PPN,QQN,NaN,{-1,-1,0.001,4},1,NaN);
            save([dstPath leftName '.mat'],'Z_MultiScaleOptimize','-append');
            save([dstPath leftName '.mat'],'InfoOut_MultiScaleOptimize','-append');
            InfoOut_MultiScaleOptimize
            mesh(Z_MultiScaleOptimize),axis equal;%,title('Z:FourWayIntegrat')
            figure(11);
            colormap('jet');
            mesh(Z_MultiScaleOptimize-Z-min(min(Z_MultiScaleOptimize-Z))),...%,title('Z:FourWayIntegrat')
                colorbar('southoutside','Position',[0.599567474048442 0.202380952380952 0.305789668808701 0.0464197530864191]),axis equal;    
            
            figure(12);
            colormap('jet');
            [Z_MultiScaleOptimizeNoIni,InfoOut_MultiScaleOptimizeNoIni] = MultiScaleOptimizeNoIni(PPN,QQN,NaN,{-1,-1,0.001,4},1,NaN);
            save([dstPath leftName '.mat'],'Z_MultiScaleOptimizeNoIni','-append');
            save([dstPath leftName '.mat'],'InfoOut_MultiScaleOptimizeNoIni','-append');
            InfoOut_MultiScaleOptimizeNoIni
            mesh(Z_MultiScaleOptimizeNoIni),axis equal;%,title('Z:FourWayIntegrat')
            figure(13);
            colormap('jet');
            mesh(Z_MultiScaleOptimizeNoIni-Z-min(min(Z_MultiScaleOptimizeNoIni-Z))),...%,title('Z:FourWayIntegrat')
                colorbar('southoutside','Position',[0.599567474048442 0.202380952380952 0.305789668808701 0.0464197530864191]),axis equal; 

            figure(14);
            colormap('jet');
            [Z_WaveletIntegrate,InfoOut_WaveletIntegrat] = WaveletIntegrate(PPN,QQN,{-1,-1,0.001,4},1,NaN);
            save([dstPath leftName '.mat'],'Z_WaveletIntegrate','-append');
            save([dstPath leftName '.mat'],'InfoOut_WaveletIntegrat','-append');
            InfoOut_WaveletIntegrat
            mesh(Z_WaveletIntegrate),axis equal;%,title('Z:FourWayIntegrat')
            figure(15);
            colormap('jet');
            mesh(Z_WaveletIntegrate-Z-min(min(Z_WaveletIntegrate-Z))),...%,title('Z:FourWayIntegrat')
                colorbar('southoutside','Position',[0.599567474048442 0.202380952380952 0.305789668808701 0.0464197530864191]),axis equal;  

            figure(16);
            colormap('jet');
            [Z_WaveletOptimize,InfoOut_WaveletOptimize] = WaveletOptimize(PPN,QQN,{-1,-1,0.001,4},1,NaN);
            save([dstPath leftName '.mat'],'Z_WaveletOptimize','-append');
            save([dstPath leftName '.mat'],'InfoOut_WaveletOptimize','-append');
            InfoOut_WaveletOptimize
            mesh(Z_WaveletOptimize),axis equal;%,title('Z:FourWayIntegrat')
            figure(17);
            colormap('jet');
            mesh(Z_WaveletOptimize-Z-min(min(Z_WaveletOptimize-Z))),...%,title('Z:FourWayIntegrat')
                colorbar('southoutside','Position',[0.599567474048442 0.202380952380952 0.305789668808701 0.0464197530864191]),axis equal; 
        end
    end
end