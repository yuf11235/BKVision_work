function [Z,IterativeInfoOut] = DeWaveletOptimize(P,Q,Z0,IterativeInfo,borderInfo,hFigure)
    tic;
    [Z,IterativeInfoOut0] = DeWaveletIterative(P,Q,Z0,IterativeInfo,borderInfo,hFigure);
    timeVal=toc;
    IterativeInfoOut={'time','timelist','timeslist','errZList','errPQList';...
                      timeVal,IterativeInfoOut0{:}};
end

function [Z,IterativeInfoOut] = DeWaveletIterative(P,Q,Z0,IterativeInfo,borderInfo,hFigure)
%MultiScaleOptimize: Optimize Z from P¡ÖZx Q¡ÖZy
%Version:2.0, Author;WANG lei, Date:2015.6.10
%Input:
%  P,Q:P¡ÖZx Q¡ÖZy
%  Z0:Initial Surface
%  IterativeInfo: {endTimes,endErrZ,endErrPQ}
%      Times: Iterative Times -1 unlimited       
%      errZ:  errZ(Z(x,y))=mean(mean((Zk - Zk_1))  -1 unlimited
%      errPQ: errPQ(Z(x,y))=mean(mean((Zx-P).*(Zx-P)+(Zy-Q).*(Zy-Q)) -1 unlimited
%  borderInfo: 0: border free; 1: border flat
%Output:
%  Z: depth matrix
%  IterativeInfoOut: {time,timelist,timeslist,errZList,errPQList};
%Reference:
% (Code)[1] T. Wei, R. Klette, A Wavelet-Based Algorithm for Height from Gradients, Robot Vis. SE  - Lect. Notes Comput. Sci. 1998 (2001) 84¨C90. doi:doi: 10.1007/3-540-44690-7_11.
%Algorithm:
%  Solve minimize functional:
    
%% Initial
    Dwf=[0.00034246575342  -0.00535714285714;
        0.01461187214612  -0.11428571428571;
        -0.14520547945206  0.87619047619052;
        0.74520547945206  -3.39047619047638;
        0.0  5.26785714285743;
        -0.74520547945206  -3.39047619047638;
        0.14520547945206  0.87619047619052;
        -0.01461187214612  -0.11428571428571;
        -0.00034246575342  -0.00535714285714]';
    N = 3;

%% Initial
    [hP,wP]=size(P);
    [hQ,wQ]=size(Q);
    if(hP~=hQ||wP~=wQ)
        error('Input parameter number error');
    end
    h=hP;
    w=wQ;
    if isnan(Z0)
        Z0=zeros(h,w,'double');
    else
        [hZ,wZ]=size(Z0);
        if h~=hZ || w~=wZ
            error('Matrix Z0 size not fit!');
        end
    end
    [hZ,wZ]=size(Z0);
    
    if iscell(IterativeInfo)
        [hIterativeInfo,wIterativeInfo]=size(IterativeInfo);
        if 1~=hIterativeInfo || 3~=wIterativeInfo
            error('IterativeInfo should be {endTimes,endErrZ,endErrPQ,startAlf,rateAlf,endAlf}');
        end
        endTimes=int64(IterativeInfo{1});
        endErrZ=double(IterativeInfo{2});
        endErrPQ=double(IterativeInfo{3});
    else
        error('IterativeInfo should be Cell');
    end

    borderInfo;
%% Iterate
    tic;
    times=0;
    listNum=16;
    errPQList=NaN(1,listNum,'double');
    errZList=NaN(1,listNum,'double');
%     adaptRatedTimes=listNum;
%     adaptRatedInter=32;
    while times~=endTimes
        [Z,errZ,errPQ] = DeWaveletIterative(P,Q,Z0,borderInfo);%alf,
        times=times+1;
        errPQList=[errPQ,errPQList(1:listNum-1)];
        errZList=[errZ,errZList(1:listNum-1)];
        if errZ<endErrZ
            break;
        end
        if errPQ<endErrPQ
            break;
        end
        format long;
        [times,errZ,errPQ]%,alf  
        if ishandle(hFigure)
            figure(hFigure);
            subplot(1,2,1),plot(times,errZ,'b+'),title('errZ'),hold on;
            subplot(1,2,2),plot(times,errPQ,'b+'),title('errPQ'),hold on;
        end 
        if times>listNum && ~IsAstringe(errPQList,errZList)
            break;
        end
        Z0=Z;
    end
    time=toc;
    IterativeInfoOut={'time','times','errZ','errPQ';...
                       time,times,errZList(1),errPQList(1)};%,alf
end

function [Z,errZ,errPQ] = DeWaveletIterative(P,Q,Z0,borderInfo)%alf,
%    mZ(x,y)=0.25*(Z(x-1,y)+Z(x+1,y)+Z(x,y-1)+Z(x,y+1)...
%                 +P(x-0.5,y)-P(x+0.5,y)+Q(x,y-0.5)-Q(x,y+0.5))
%  For reach the minimize point 
%    Z(x,y)=(1-alf) * Z(x,y) + alf * mZ(x,y)
%% Set borders
    [hP,wP]=size(P);
    [hQ,wQ]=size(Q);
    [hZ,wZ]=size(Z0);
    if borderInfo==0
        ZE=[Z0(1,1),Z0(1,1:wZ),Z0(1,wZ);...
            Z0(1:hZ,1),Z0(1:hZ,1:wZ),Z0(1:hZ,wZ);...
            Z0(hZ,1),Z0(hZ,1:wZ),Z0(hZ,wZ);];
        PE=[P(1:hP,1),P,P(1:hP,wP)];
        QE=[Q(1,1:wQ);Q;Q(hQ,1:wQ)];
    elseif borderInfo>=1
        ZE=[0,zeros(1,wZ,'double'),0; ...
            zeros(hZ,1,'double'),Z0,zeros(hZ,1,'double');...
            0,zeros(1,wZ,'double'),0];
        PE=[zeros(hP,1,'double'),P,zeros(hP,1,'double')];
        QE=[zeros(1,wQ,'double');Q;zeros(1,wQ,'double')];
    else
        error('borderInfo should >=0');
    end
%% Iterate
    mZ=ZE(2:hZ+1,1:wZ)+ZE(2:hZ+1,3:wZ+2)+ZE(1:hZ,2:wZ+1)+ZE(3:hZ+2,2:wZ+1);
    mZ=mZ+PE(:,1:wP+1)-PE(:,2:wP+2)+QE(1:hQ+1,:)-QE(2:hQ+2,:);
    mZ=mZ*0.25;
    Z=mZ;
    %Z=(1-alf)*Z0+mZ*alf;
%% Error compute   
    errZ=sqrt(mean(mean((Z-Z0).*(Z-Z0))));
    disP=Z(1:hZ,2:wZ)-Z(1:hZ,1:wZ-1)-P;
    disP=disP.*disP;
    errP=mean(mean(disP));
%     errP=mean(sum(disP,2));
    disQ=Z(2:hZ,1:wZ)-Z(1:hZ-1,1:wZ)-Q;
    disQ=disQ.*disQ;
    errQ=mean(mean(disQ));
%     errQ=mean(sum(disQ,1));
    errPQ=sqrt(errP+errQ);
end

function isAstringe = IsAstringe(errPQList,errZList)
    [hPQ,wPQ]=size(errPQList);
    [hZ,wZ]=size(errZList);
    %isAstringe=(mean(errZList(1:wZ/2))>mean(errZList(wZ/2+1:wZ)));
    isAstringe=(mean(errPQList(1:wPQ/2))<mean(errPQList(wPQ/2+1:wPQ)));
    isAstringe=isAstringe && (mean(errZList(1:wZ/2))<mean(errZList(wZ/2+1:wZ)));
end