%{将矩阵值规整到指定范围-----------------------------------------------
function O= Reassign(I,minValue,maxValue)
    %[height,width,deepth]=size(I);
    minI=double(min(min(min(I))));
    maxI=double(max(max(max(I))));
    distI=maxI-minI;
    distValue=maxValue-minValue;
    ratio=distValue/distI;
    O=(I-minI);
    O=O*ratio+minValue;
end
%--------------------------------------------------------------------}

