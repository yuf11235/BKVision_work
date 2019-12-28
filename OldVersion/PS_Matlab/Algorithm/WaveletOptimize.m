function [Z,IterativeInfoOut] = WaveletOptimize(PS,QS,IterativeInfo,borderInfo,hFigure)
    [hP,wP]=size(PS);
    [hQ,wQ]=size(QS);
    if(hP~=hQ||wP~=wQ)
        error('Input parameter number error');
    end
    PN=(PS(1:h,2:w)+PS(1:h,1:w-1))/2;
    QN=(QS(2:h,1:w)+QS(1:h-1,1:w))/2; 
    tic;
    [Z,IterativeInfoOut0] = PQ2Z(PN,QN,IterativeInfo,borderInfo,hFigure);
    timeVal=toc;
    IterativeInfoOut={'time','timelist','timeslist','errZList','errPQList';...
                      timeVal,IterativeInfoOut0{:}};
end

function [A0,IterativeInfoOut] = PQ2Z(P1,Q1,IterativeInfo,borderInfo,hFigure)
%WaveletOptimize: Optimize Z from P≈Zx Q≈Zy
%Version:2.0, Author;WANG lei, Date:2015.6.10
%Input:
%  P,Q:P≈Zx Q≈Zy
%  Z0:Initial Surface
%  IterativeInfo: {endTimes,endErrZ,endErrPQ}
%      Times: Iterative Times -1 unlimited       
%      errZ:  errZ(Z(x,y))=mean(mean((Zk - Zk_1))  -1 unlimited
%      errPQ: errPQ(Z(x,y))=mean(mean((Zx-P).*(Zx-P)+(Zy-Q).*(Zy-Q)) -1 unlimited
%  borderInfo: 0: border free; 1: border flat
%Output:
%  Z: depth matrix
%  IterativeInfoOut: {time,[times],errZ,errPQ};
%Reference:
% (Code)Horn, B. K. P., & Brooks, M. J. (1985). The variational approach to shape from shading. Computer Vision, Graphics, and Image Processing, 32(1), 142. http://doi.org/10.1016/0734-189X(85)90010-6
%       Saracchini, R. F. V., Stolfi, J., Leit?o, H. C. G., Atkinson, G. a., & Smith, M. L. (2012). A robust multi-scale integration method to obtain the depth from gradient maps. Computer Vision and Image Understanding, 116(8), 882–895. http://doi.org/10.1016/j.cviu.2012.03.006
%Algorithm:
%前向分解算法流程
%         未下采样小波矩阵               横向差分矩阵    y x      未下采样小波矩阵      y x           小波矩阵
%               uD1 ←间隔(2,1)*(1,-1)′←   P1  →间隔(2,1)*(1,1)′  → uV1   →间隔(1,2)*(1,0) →    V1     
%            y x↑                       y x↑                    y x   ↓
%        间隔(1,2)*(1,-1)           间隔(1,1)*(1,-1)          间隔(1,2)*(1,2,1)
%               ↑                         ↑                          ↓
%            纵向差分矩阵   y x          原矩阵                 二阶纵向差分矩阵  y x      未下采样小波矩阵            小波矩阵
%               Q1   ←间隔(2,1)*(1,1)′←  Z                          P2 →间隔(2,1)*(1,1)′→ uV2→间隔(1,2)*(1,0)→  V2
%           y x ↓
%      间隔(1,2)*(1,1)                                                 ↓
%               ↓
%          未下采样小波矩阵  y x      二阶纵向差分矩阵             未下采样小波矩阵
%              uH1   →间隔(2,1)*(1,2,1)→  Q2              →         uD1
%           y x ↓                      y x ↓ 
%      间隔(1,2)*(1,0)             间隔(1,2)*(1,1)
%               ↓                          ↓
%            小波矩阵               未下采样小波矩阵  y x      二阶纵向差分矩阵
%               H1                         uH2
%                                       y x ↓ 
%                                  间隔(1,2)*(1,0) 
%                                           ↓
%                                        小波矩阵
%                                           H2     
%% Initial
    if(isnan(P1(1,1)) || isnan(Q1(1,1)))
        A0=zeros(1,1);
        IterativeInfoOut=NaN;
    else
        [hP,wP]=size(P1);
        [hQ,wQ]=size(Q1);
        if(hP~=hQ+1||wP+1~=wQ)
            error('Input parameter number error');
        end
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
%% MultiScale recursion   
%         tic;
        [H1,V1,D1,P2,Q2]= PQ2HVD(P1,Q1);
        [hH1,wH1] = size(H1);
        [hV1,wV1] = size(V1);
        [hD1,wD1] = size(D1);
        if(hH1==hV1 &&hH1==hD1 &&wH1==wV1 &&wH1==wD1)
            [A1,IterativeInfoOut1]=PQ2Z(P2,Q2,IterativeInfo,borderInfo,hFigure);
            A0=-HarrWaveletsRec(-A1,H1,V1,D1);
           [hA0 wA0]=size(A0);
             if (hA0>=minSize && wA0>=minSize)
%                 P1=P1(1:hA0,1:wA0-1);
%                 Q1=Q1(1:hA0-1,1:wA0);
                IterativeInfo2={endTimes,endErrZ,endErrPQ};
                [A0,IterativeInfoOut2] = PossionSolverOptimizeUntimer(P1,Q1,A0,IterativeInfo2,borderInfo,NaN);
            end
        else
            error('Matrix not match');
        end
%         timeThisScale=toc;
        timeThisScale=0;
        [hA,wA]=size(A0);
        if ishandle(hFigure)
            figure(hFigure);mesh(A0),title(['Z_ScaleSize=' num2str(hA) '×' num2str(wA) ]),axis equal;
        end
        errZ=sqrt(mean(mean((A0-A0).*(A0-A0))));
        disP=A0(1:hA,2:wA)-A0(1:hA,1:wA-1)-P1;
        disP=disP.*disP;
        errP=mean(mean(disP));
        disQ=A0(2:hA,1:wA)-A0(1:hA-1,1:wA)-Q1;
        disQ=disQ.*disQ;
        errQ=mean(mean(disQ));
        errPQ=sqrt(errP+errQ);
        if ~iscell(IterativeInfoOut1)
            timelist=timeThisScale;
            timeslist=0;
            errZList=-1;
            errPQList=-1;
        else
            timelist=[timeThisScale;IterativeInfoOut1{1}];
            timeslist=[IterativeInfoOut2{2,2};IterativeInfoOut1{2}];
            errZList=[IterativeInfoOut2{2,3};IterativeInfoOut1{3}];
            errPQList=[IterativeInfoOut2{2,4};IterativeInfoOut1{4}];
        end
        IterativeInfoOut={timelist,timeslist,errZList,errPQList};
    end
end


%由差分矩阵作为中间结果的可递归函数
function [H1,V1,D1,P2,Q2]= PQ2HVD(P1,Q1)
%{unSamQled difference[P,Q] to wavelets[H1,V1,D1]Algorithm-----------------
%前向分解算法流程
%         未下采样小波矩阵               横向差分矩阵    y x      未下采样小波矩阵      y x           小波矩阵
%               uD1 ←间隔(2,1)*(1,-1)′←   P1  →间隔(2,1)*(1,1)′  → uV1   →间隔(1,2)*(1,0) →    V1     
%            y x↑                       y x↑                    y x   ↓
%        间隔(1,2)*(1,-1)           间隔(1,1)*(1,-1)          间隔(1,2)*(1,2,1)
%               ↑                         ↑                          ↓
%            纵向差分矩阵   y x          原矩阵                 二阶纵向差分矩阵  y x      未下采样小波矩阵            小波矩阵
%               Q1   ←间隔(2,1)*(1,1)′←  Z                          P2 →间隔(2,1)*(1,1)′→ uV2→间隔(1,2)*(1,0)→  V2
%           y x ↓
%      间隔(1,2)*(1,1)                                                 ↓
%               ↓
%          未下采样小波矩阵  y x      二阶纵向差分矩阵             未下采样小波矩阵
%              uH1   →间隔(2,1)*(1,2,1)→  Q2              →         uD1
%           y x ↓                      y x ↓ 
%      间隔(1,2)*(1,0)             间隔(1,2)*(1,1)
%               ↓                          ↓
%            小波矩阵               未下采样小波矩阵  y x      二阶纵向差分矩阵
%               H1                         uH2
%                                       y x ↓ 
%                                  间隔(1,2)*(1,0) 
%                                           ↓
%                                        小波矩阵
%                                           H2            
%-------------------------------------------------------------------------}
    %规整矩阵大小
    [p1h,p1w]=size(P1);
    [q1h,q1w]=size(Q1);
    %原始矩阵大小
    zh=uint16(min(p1h,q1h+1));
    zh=2*((zh-1)/2);
    zw=uint16(min(p1w+1,q1w));
    zw=2*((zw-1)/2);
    p1h=zh;
    p1w=zw-1;
    q1h=zh-1;
    q1w=zw;
    P1=P1(1:p1h,1:p1w);
    Q1=Q1(1:q1h,1:q1w);
    %使用卷积理论计算
    LoD=[1 1];
    HiD=[-1 1];
    HiDD=[-1 0 1];
    LoDLoD=[1 2 1];
    %以两种方法计算uD1
    upD1=conv2(P1,HiD','valid');
    uqD1=conv2(Q1,HiD,'valid');
    %测试部分
    %figure;
    %mesh(upD1-uqD1);%axis equal;
    %
    %{增补算法：根据upD1==uqD1的条件修改PQ矩阵-------
%     diffPQ=mean(mean(upD1-uqD1));
%     P1=P1-diffPQ/2;
%     Q1=Q1+diffPQ/2;
    uD1=(upD1+uqD1)./2;
    [uD1h,uD1w]=size(uD1);
    D1=uD1(1:2:uD1h,1:2:uD1w);
    [D1h,D1w]=size(D1);
    %----------------------------------------------}
    
    uV1=conv2(P1,LoD','valid'); 
    [uV1h,uV1w]=size(uV1);
    sV1=uV1(1:2:uV1h,1:uV1w);
    [sV1h,sV1w]=size(sV1);
    V1=sV1(1:sV1h,1:2:sV1w);
    [V1h,V1w]=size(V1);
        
    uH1=conv2(Q1,LoD,'valid'); 
    [uH1h,uH1w]=size(uH1);
    sH1=uH1(1:uV1h,1:2:uV1w);
    [sH1h,sH1w]=size(sH1);
    H1=sH1(1:2:sH1h,1:sH1w);
    [H1h,H1w]=size(H1);
    
    if uV1w>=3
        uP2=conv2(sV1,LoDLoD,'valid');
        [uP2h,uP2w]=size(uP2);
        P2=uP2(1:uP2h,1:2:uP2w);
    else
        P2=NaN;
    end
    if uH1h>=3  
        uQ2=conv2(sH1,LoDLoD','valid');
        [uQ2h,uQ2w]=size(uQ2);
        Q2=uQ2(1:2:uQ2h,1:uQ2w);
    else
        Q2=NaN;
    end
end
%-------------------------------------------------------------------------}

%{误差纠正算法,修正A矩阵十字交线---------------------------------------------
function A1= FixError(A)
    [h,w]=size(A);
    A1=A;
    alf=0.9;
    if h>=8 && w>=8
        %线误差
        errRAH=2*sum(A(1:h/2,w/2)-A(1:h/2,w/2+1))/h;
        errRAV=2*sum(A(h/2,1:w/2)-A(h/2+1,1:w/2))/w;
        errRVD=2*sum(A(h/2+1:h,w/2)-A(h/2+1:h,w/2+1))/h;
        errRHD=2*sum(A(h/2,w/2+1:w)-A(h/2+1,w/2+1:w))/w;
        %中心点误差
        errPAH=(A(h/2,w/2)-A(h/2,w/2+1));
        errPAV=(A(h/2,w/2)-A(h/2+1,w/2));
        errPVD=(A(h/2+1,w/2)-A(h/2+1,w/2+1));
        errPHD=(A(h/2,w/2+1)-A(h/2+1,w/2+1));
        %误差纠正
        errAH=alf*errRAH+(1-alf)*errPAH;
        errAV=alf*errRAV+(1-alf)*errPAV;
        errAD=alf*(errRAV+errRVD+errRAH+errRHD)/2+(1-alf)*(errPAV+errPVD+errPAH+errPHD)/2;
        A1(1:h/2,w/2+1:w)=A(1:h/2,w/2+1:w)+errAH;
        A1(h/2+1:h,1:w/2)=A(h/2+1:h,1:w/2)+errAV;
        A1(h/2+1:h,w/2+1:w)=A(h/2+1:h,w/2+1:w)+errAD;
    end
end
%-------------------------------------------------------------------------}

%{将矩阵值规整到指定范围-----------------------------------------------
function O= Reassign(I,minValue,maxValue)
    minI=min(min(I));
    maxI=max(max(I));
    distI=maxI-minI;
    distValue=maxValue-minValue;
    ratio=distValue/distI;
    addValue=minValue-minI;
    O=(I+addValue)*ratio;
end
%--------------------------------------------------------------------}

%{哈尔小波分解------------------------------
function [A1,H1,V1,D1] = HarrWaveletsDec(A0)
    [h,w]=size(A0);
    dA0=double(A0);
    A1=dA0(1:2:h-1,1:2:w-1)+dA0(1:2:h-1,2:2:w)+dA0(2:2:h,1:2:w-1)+dA0(2:2:h,2:2:w);
    H1=dA0(1:2:h-1,1:2:w-1)+dA0(1:2:h-1,2:2:w)-dA0(2:2:h,1:2:w-1)-dA0(2:2:h,2:2:w);
    V1=dA0(1:2:h-1,1:2:w-1)-dA0(1:2:h-1,2:2:w)+dA0(2:2:h,1:2:w-1)-dA0(2:2:h,2:2:w);
    D1=dA0(1:2:h-1,1:2:w-1)-dA0(1:2:h-1,2:2:w)-dA0(2:2:h,1:2:w-1)+dA0(2:2:h,2:2:w);
end
%-----------------------------------------}

%{哈尔小波重构------------------------------
function A0 = HarrWaveletsRec(A1,H1,V1,D1)
    A1=double(A1);
    H1=double(H1);
    V1=double(V1);
    D1=double(D1);
    [hA1,wA1]=size(A1);
    [hH1,wH1]=size(H1);
    [hV1,wV1]=size(V1);
    [hD1,wD1]=size(D1);
    if (hA1==hH1 &&hA1==hV1 &&hA1==hD1 &&wA1==wH1 &&wA1==wV1 &&wA1==wD1)
        hA0=hA1*2;
        wA0=wA1*2;
        A0=double(zeros(hA0,wA0));
        A0(1:2:hA0-1,1:2:wA0-1)=(A1+H1+V1+D1)/4;
        A0(1:2:hA0-1,2:2:wA0)=(A1+H1-V1-D1)/4;
        A0(2:2:hA0,1:2:wA0-1)=(A1-H1+V1-D1)/4;
        A0(2:2:hA0,2:2:wA0)=(A1-H1-V1+D1)/4;
    else
        error('Matrix not match');
    end
end
%-----------------------------------------}