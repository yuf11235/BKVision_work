function [imageFiltered,imageDwted,imageDwtMasked,cellDwted,cellMasked,...
    imageInvFiltered,imageInvMasked,cellInvMasked] = WaveLetsFilter(imageIn,wname,maskMatrix)
%Image Filter using dwt2~idwt2
%   imageIn: input image
%   wname: wavelet type
%   maskMatrix: filter mask Matrix, whoese size is 2^n X2^n
%               ！！if maskMatrix is 2X2, dwt2 is one time
%               ！！if maskMatrix is 4X4, dwt2 is two times
%   imageOut: output image where freq is masked by maskMatrix value 0
%   invImageOut: output image where freq is masked by maskMatrix value 1
%   imagedwted: dwted image
%   imageMasked: masked image
%   cellDwted: dwted image cell
%   cellMasked: masked image cell
    [hmask,wmask]=size(maskMatrix);    
    [himage,wimage]=size(imageIn);
    if(hmask~=wmask)   
        error(message('WaveLetsFilter:maskMatrix:Invalid_Size'));
    end
    times=log2(hmask);
    if(mod(times,1)~=0)
        error(message('WaveLetsFilter:maskMatrix:Invalid_Size'));
    end
    times=uint(times);
    if(hmask==2)
        [imageFiltered,imageDwted,imageDwtMasked,cellDwted,cellMasked,...
            imageInvFiltered,imageInvMasked,cellInvMasked]=WaveLetsFilter2X2(imageIn,wname,maskMatrix);
    else
        [imageFilteredAll,imageDwtedAll,imageDwtMaskedAll,cellDwtedAll,cellMaskedAll,...
            imageInvOutAll,imageInvMaskedAll,cellInvMaskedAll]=WaveLetsFilter2X2(imageIn,wname,[1,1;1,1]);
        [imageFilteredA,imageDwtedA,imageDwtMaskedA,cellDwtedA,cellMaskedA,...
            imageInvFilteredA,imageInvMaskedA,cellInvMaskedA] = WaveLetsFilter(cellDwtedAll{1,1},wname,maskMatrix(1:hmask/2,1:wmask/2));
        [imageFilteredH,imageDwtedH,imageDwtMaskedH,cellDwtedH,cellMaskedH,...
            imageInvFilteredH,imageInvMaskedH,cellInvMaskedH] = WaveLetsFilter(cellDwtedAll{1,2},wname,maskMatrix(1:hmask/2,wmask/2+1:wmask));        
        [imageFilteredV,imageDwtedV,imageDwtMaskedV,cellDwtedV,cellMaskedV,...
            imageInvFilteredV,imageInvMaskedV,cellInvMaskedV] = WaveLetsFilter(cellDwtedAll{2,1},wname,maskMatrix(hmask/2+1:hmask,1:wmask/2));                
        [imageFilteredD,imageDwtedD,imageDwtMaskedD,cellDwtedD,cellMaskedD,...
            imageInvFilteredD,imageInvMaskedD,cellInvMaskedD] = WaveLetsFilter(cellDwtedAll{2,2},wname,maskMatrix(hmask/2+1:hmask,wmask/2+1:wmask));
        
        imageDwted=[imageDwtedA,imageDwtedH;imageDwtedV,imageDwtedD];
        imageDwtMasked=[imageDwtMaskedA,imageDwtMaskedH;imageDwtMaskedV,imageDwtMaskedD];
        cellDwted={cellDwtedA,cellDwtedH;cellDwtedV,cellDwtedD};
        cellMasked={cellMaskedA,cellMaskedH;cellMaskedV,cellMaskedD};
        imageFiltered = idwt2(imageFilteredA,imageFilteredH,imageFilteredV,imageFilteredD,wname,[himage,wimage]);
        
        imageInvMasked=[imageInvMaskedA,imageInvMaskedH;imageInvMaskedV,imageInvMaskedD];
        cellInvMasked={cellInvMaskedA,cellInvMaskedH;cellInvMaskedV,cellInvMaskedD};
        imageInvFiltered = idwt2(imageInvFilteredA,imageInvFilteredH,imageInvFilteredV,imageInvFilteredD,wname,[himage,wimage]);
    end
end

function [imageFiltered,imageDwted,imageDwtMasked,cellDwted,cellMasked,...
    imageInvFiltered,imageInvMasked,cellInvMasked] = WaveLetsFilter2X2(imageIn,wname,maskMatrix)
%Image Filter using dwt2~idwt2
%   imageIn: input image
%   wname: wavelet type
%   maskMatrix: filter mask Matrix, whoese size is 2X2
%   imageOut: output image
%   imagedwted: dwted image
%   imageMasked: masked image
%   cellDwted: dwted image cell
%   cellMasked: masked image cell
    [hmask,wmask]=size(maskMatrix);
    [himage,wimage]=size(imageIn);
    if(hmask~=2 ||wmask~=2)   
        error(message('WaveLetsFilter:maskMatrix:Invalid_Size'));
    end
    [cA,cH,cV,cD] = dwt2(imageIn,wname,'mode','sym');
    imageDwted=[cA,cH;cV,cD];
    cellDwted={cA,cH;cV,cD};
    cA=cA*maskMatrix(1,1);
    cH=cH*maskMatrix(1,2);
    cV=cV*maskMatrix(2,1);
    cD=cD*maskMatrix(2,2);     
    icA=cA*(1-maskMatrix(1,1));
    icH=cH*(1-maskMatrix(1,2));
    icV=cV*(1-maskMatrix(2,1));
    icD=cD*(1-maskMatrix(2,2));
    imageDwtMasked=[cA,cH;cV,cD];
    cellMasked={cA,cH;cV,cD};
    imageFiltered = idwt2(cA,cH,cV,cD,wname,[himage,wimage]);
    
    imageInvMasked=[icA,icH;icV,icD];
    cellInvMasked={icA,icH;icV,icD};
    imageInvFiltered = idwt2(icA,icH,icV,icD,wname,[himage,wimage]);
end
