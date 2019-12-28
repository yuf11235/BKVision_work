function [Z,IterativeInfoOut] = MultiScaleOptimizeNoIni(P,Q,Z0,IterativeInfo,borderInfo,hFigure)
    tic;
    [Z,IterativeInfoOut0] = MultiScaleRecursion(P,Q,Z0,IterativeInfo,borderInfo,hFigure);
    timeVal=toc;
    IterativeInfoOut={'time','timelist','timeslist','errZList','errPQList';...
                      timeVal,IterativeInfoOut0{:}};
end

function [Z,IterativeInfoOut] = MultiScaleRecursion(P,Q,Z0,IterativeInfo,borderInfo,hFigure)
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
% (Code)Horn, B. K. P., & Brooks, M. J. (1985). The variational approach to shape from shading. Computer Vision, Graphics, and Image Processing, 32(1), 142. http://doi.org/10.1016/0734-189X(85)90010-6
%       Saracchini, R. F. V., Stolfi, J., Leit?o, H. C. G., Atkinson, G. a., & Smith, M. L. (2012). A robust multi-scale integration method to obtain the depth from gradient maps. Computer Vision and Image Understanding, 116(8), 882¨C895. http://doi.org/10.1016/j.cviu.2012.03.006
%Algorithm:
%  Solve minimize functional:
%                           w h
%  minimize: errPQ(Z(x,y))=¡Æ¡Æ(Zx(x,y)-P(x,y))^2+(Zy(x,y)-Q(x,y))^2
%                         x=1 y=1
%  If:       E=(Zx(x,y)-P(x,y))^2+(Zy(x,y)-Q(x,y))^2
%  Exist Euler-Lagrange equation:
%            ?E/?Z - d(?E/?Zx)/dx - d(?E/?Zy)/dy=0
%  Since  ?E/?Z=0; d(?E/?Zx)/dx=Zx(x,y)-P(x,y); d(?E/?Zy)/dy=Zy(x,y)-Q(x,y)
%  In discrete space the 2d poisson equation (5) could be described as 
%      a "five point difference format":
%
%                   Z(x,y-1)
%         ¡ð©¤©¤©¤¡÷©¤©¤©¤¡ñ©¤©¤©¤¡÷©¤©¤©¤¡ð
%         ©¦             ©¦             ©¦
%         ©¦             ©¦             ©¦
%         ¡ó             ¡ô -Q(x,y-0.5) ¡ó
%         ©¦             ©¦             ©¦
%         ©¦             ©¦4*Z(x,y)     ©¦
% Z(x-1,y)¡ñ©¤©¤©¤¡ø©¤©¤©¤¡ñ©¤©¤¨D¡ø©¤©¤©¤¡ñ Z(x+1,y)
%         ©¦ -P(x-0.5,y) ©¦  P(x+0.5,y) ©¦
%         ©¦             ©¦             ©¦
%         ¡ó             ¡ô Q(x,y+0.5)  ¡ó
%         ©¦             ©¦             ©¦
%         ©¦             ©¦             ©¦
%         ¡ð©¤©¤©¤¡÷©¤©¤©¤¡ñ©¤©¤©¤¡÷©¤©¤©¤¡ð
%                   Z(x,y+1)
%
%    mZ(x,y)=0.25*(Z(x-1,y)+Z(x+1,y)+Z(x,y-1)+Z(x,y+1)...
%                 +P(x-0.5,y)-P(x+0.5,y)+Q(x,y-0.5)-Q(x,y+0.5))
%  MultiScale logic
%                     a                    a'
%         ¡ñ©¤©¤¡ø©¤©¤¡ð©¤©¤¡ø©¤©¤¡ñ©¤©¤¡÷©¤©¤¡ð
%         ©¦         ©¦         ©¦          ©¦
%         ¡ô         ¡ó         ¡ô          ¡ó
%         ©¦         ©¦c        ©¦          ©¦
%       b ¡ð©¤©¤¡÷©¤©¤¡ð©¤©¤¡÷©¤©¤¡ð©¤©¤¡÷©¤©¤¡ðc'
%         ©¦         ©¦         ©¦          ©¦
%         ¡ô         ¡ó         ¡ô          ¡ó
%         ©¦         ©¦         ©¦          ©¦
%         ¡ñ©¤©¤¡ø©¤©¤¡ð©¤©¤¡ø©¤©¤¡ñ©¤©¤¡÷©¤©¤¡ð
%         ©¦         ©¦         ©¦          ©¦
%         ¡ô         ¡ó         ¡ô          ¡ó
%         ©¦         ©¦         ©¦          ©¦
%       b'¡ð©¤©¤¡÷©¤©¤¡ð©¤©¤¡÷©¤©¤¡ð©¤©¤¡÷©¤©¤¡ðc'''
%                     c''
    
    
%% Initial
    [hP,wP]=size(P);
    [hQ,wQ]=size(Q);
    if(hP~=hQ+1||wP+1~=wQ)
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
    Z=Z0;
    if iscell(IterativeInfo)
        [hIterativeInfo,wIterativeInfo]=size(IterativeInfo);
        if 1~=hIterativeInfo || 4~=wIterativeInfo
            error('IterativeInfo should be {endTimes,endErrZ,endErrPQ,minSize}');
        end
        endTimes=int64(IterativeInfo{1});
        endErrZ=double(IterativeInfo{2});
        endErrPQ=double(IterativeInfo{3});
        minSize=double(IterativeInfo{4});
    else
        error('IterativeInfo should be Cell');
    end

    borderInfo;
%% MultiScale recursion
    if minSize<4
        minSize=4;
    end
    IterativeInfoOut1=NaN;
%     tic;
    if hP>minSize && wP>minSize-1 && hQ>minSize-1 && wQ>minSize && hZ>minSize && wZ>minSize
        hOdd=mod(h,2);
        wOdd=mod(w,2);
        subP=(P(1:2:hP,1:2:wP-1)+P(1:2:hP,2:2:wP))./2;
        subQ=(Q(1:2:hQ-1,1:2:wQ)+Q(2:2:hQ,1:2:wQ))./2;
        subZ0=Z0(1:2:hZ,1:2:wZ);
        %[hSZ,wSZ]=size(subZ0);
        [subZ,IterativeInfoOut1] = MultiScaleRecursion(subP,subQ,subZ0,IterativeInfo,borderInfo,hFigure);
        Z(1:2:h,1:2:w)=2*subZ;        
        Z(2:2:h,1:2:w)=2*subZ;        
        Z(1:2:h,1:2:w)=2*subZ;        
        Z(2:2:h,2:2:w)=2*subZ;
       
    else
        [Z,InfoOut_FourWayIntegrat] = FourWayIntegrate(P,Q);
    end
    IterativeInfo2={endTimes,endErrZ,endErrPQ};
    [Z,IterativeInfoOut2] = PossionSolverOptimizeUntimer(P,Q,Z,IterativeInfo2,borderInfo,NaN);
%     timeThisScale=toc;
    timeThisScale=0;
    if ishandle(hFigure)
        figure(hFigure);mesh(Z),title(['Z_ScaleSize=' num2str(hZ) '¡Á' num2str(wZ) ]),axis equal;
    end
    if ~iscell(IterativeInfoOut1)
        timelist=timeThisScale;
        timeslist=IterativeInfoOut2{2,2};
        errZList=IterativeInfoOut2{2,3};
        errPQList=IterativeInfoOut2{2,4};
    else
        timelist=[timeThisScale;IterativeInfoOut1{1}];
        timeslist=[IterativeInfoOut2{2,2};IterativeInfoOut1{2}];
        errZList=[IterativeInfoOut2{2,3};IterativeInfoOut1{3}];
        errPQList=[IterativeInfoOut2{2,4};IterativeInfoOut1{4}];
    end
    IterativeInfoOut={timelist,timeslist,errZList,errPQList};
end