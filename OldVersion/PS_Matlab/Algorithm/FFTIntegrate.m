function [Z,InfoOut] = FFTIntegrate(PP,QQ,InfoIn)
%FFTIntegrate: Optimize Z from P¡ÖZx Q¡ÖZy
%Version:2.0, Author;WANG lei, Date:2015.6.10
%Input:
%  P,Q:P¡ÖZx Q¡ÖZy
%  Z0:Initial Surface
%  InfoIn: {lamda,mue,endTimes,endErrZ,endErrPQ}
%      Times: Iterative Times -1 unlimited       
%      errZ:  errZ(Z(x,y))=mean(mean((Zk - Zk_1))  -1 unlimited
%      errPQ: errPQ(Z(x,y))=mean(mean((Zx-P).*(Zx-P)+(Zy-Q).*(Zy-Q)) -1 unlimited
%  borderInfo: 0: border free; 1: border flat
%Output:
%  Z: depth matrix
%  InfoOut: {time,times,errZ,errPQ};
%Reference:
% (Code)Wenner, A., & Brune, C. (n.d.). Reconstructing Depth Information from Surface Normal Vectors Inhaltsverzeichnis, 1¨C58.
%Algorithm:
%  Solve minimize functional:
    
%% Initial
    [hP,wP]=size(PP);
    [hQ,wQ]=size(QQ);
    if(hP-1~=hQ || wP~=wQ-1)
        error('Input parameter number error');
    end
    P=([PP(:,1),PP]+[PP,PP(:,wP)])/2;
    Q=([QQ(1,:);QQ]+[QQ;QQ(hQ,:)])/2;
    if iscell(InfoIn)
        [hIterativeInfo,wIterativeInfo]=size(InfoIn);
        if 1~=hIterativeInfo || 5~=wIterativeInfo
            error('IterativeInfo should be {endTimes,endErrZ,endErrPQ,minSize}');
        end
        lamda=double(InfoIn{1});
        mue=double(InfoIn{2});
%         endTimes=int64(InfoIn{3});
%         endErrZ=double(InfoIn{4});
%         endErrPQ=double(InfoIn{5});
    else
        error('IterativeInfo should be Cell');
    end
    h=hP;
    w=wQ;
%% MultiScale recursion   
    tic;
    fftP=fft2(P);
    fftQ=fft2(Q);
    fftPR=real(fftP);
    fftPI=imag(fftP);
    fftQR=real(fftQ);
    fftQI=imag(fftQ);
    u=0:w-1;
    v=0:h-1;
    [U,V]=meshgrid(u,v);
    sinU=sin(2*pi*U/w);
    sinV=sin(2*pi*V/h);
    sinUU=sinU.*sinU;
    sinVV=sinV.*sinV;
    sinUUVV=(sinUU+sinVV);
    d=sinUUVV;%(1+lamda)*+ mue*sinUUVV.*sinUUVV;
    fftZR=(sinU.*fftPI+sinV.*fftQI)./d;
    fftZI=(-sinU.*fftPR-sinV.*fftQR)./d;
%     fftZR(w,h)=0;
%     fftZI(w,h)=0;
    
%     d=U.*U+V.*V;
%     fftZR=(U.*fftPI+V.*fftQI)./d;
%     fftZI=(-U.*fftPR-V.*fftQR)./d;
    fftZR(1,1)=0;
    fftZI(1,1)=0;
    fftZ=complex(fftZR,fftZI);
    Zi = ifft2(fftZ);
    Z=real(Zi);
    timeThisScale=toc;
    %errZ=sqrt(mean(mean((Z-Z).*(Z-Z))));
    disP=Z(1:h,2:w)-Z(1:h,1:w-1)-PP;%0.5*(P(:,1:wP-1)+P(:,2:wP));
    disP=disP.*disP;
    errP=mean(mean(disP));
    disQ=Z(2:h,1:w)-Z(1:h-1,1:w)-QQ;%0.5*(Q(1:hQ-1,:)+Q(2:hQ,:));
    disQ=disQ.*disQ;
    errQ=mean(mean(disQ));
    errPQ=sqrt(errP+errQ);
    time=timeThisScale;
    timeslist=NaN;
    InfoOut={'time','timeslist','errPQ';...
             time,timeslist,errPQ};
end