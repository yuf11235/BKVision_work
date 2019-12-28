function[NormXMat,NormYMat,NormZMat,MaskNormMat] = MultiImage2SurfNorm(ImageList, WeightMatList, MaskMat, LightVectList)
%输入  I  分别是多通道图像矩阵三维
%      W  区域有效性选择
%      L  光源方向矩阵行向量为单个光源的单位方向向量
%输出  (N1,N2,N3)是表面单位法向的矩阵
    [h,w,n] =size(ImageList);
    [hW,wW,nW] =size(WeightMatList);
    [hM,wM,nM] =size(MaskMat);
    [nL,dL] =size(LightVectList);
    NormXMat = (zeros(h,w,'double'));
    NormYMat = (zeros(h,w,'double'));
    NormZMat = (ones(h,w,'double'));
    
    MaskNormMat=NaN(h,w,'double');
    %MaskMat;
    if h~= hW ||w~= wW || n~= nW || h~= hM ||w ~= wM ||1~= nM ||n~=nL ||dL~=3
        return;
    end
    %invL=inv(double(L));
    tmpNormVect=double(zeros(3,1));%临时保存的向量
    tmpImagePixlVect=double(zeros(n,1));%临时保存的向量
    tmpWeightPixlVect=double(zeros(n,1));%临时保存的向量
%     tmpMaskPixl=1;%临时保存的向量
    LightVectListWeighted=LightVectList;
    for i = 1:h
        for j = 1:w
            if isnan(MaskMat(i,j))==1
                NormXMat(i,j)=0;
                NormYMat(i,j)=0;
                NormZMat(i,j)=0.01;
            else
                tmpImagePixlVect=double(shiftdim(ImageList(i,j,:),2));                
                tmpWeightPixlVect=shiftdim(WeightMatList(i,j,:),2);
                LightVectListWeighted=LightVectList.*[tmpWeightPixlVect tmpWeightPixlVect tmpWeightPixlVect];
                tmpNormVect=(inv(LightVectListWeighted'*LightVectListWeighted)*LightVectListWeighted')*tmpImagePixlVect;
                normsuf=norm(tmpNormVect);
                tmpNormVect=tmpNormVect./normsuf;
                if normsuf~=0
                    tmpNormVect=tmpNormVect/norm(tmpNormVect);
                    NormXMat(i,j) =tmpNormVect(1,1);
                    NormYMat(i,j) =tmpNormVect(2,1);
                    NormZMat(i,j) =tmpNormVect(3,1);                    
                    MaskNormMat(i,j) =1;
                else
                    NormXMat(i,j) =0;
                    NormYMat(i,j) =0;   
                    NormZMat(i,j) =0.01;
                end
            end
        end
    end       
end