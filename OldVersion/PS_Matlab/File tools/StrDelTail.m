function dstStr= StrDelTail(srcStr)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    allStrLen=length(srcStr);
    srcStrLen=allStrLen;
    for i=allStrLen:-1:1
        if srcStr(1,srcStrLen)==' '
            srcStrLen=srcStrLen-1;
        else
            break;
        end
    end
    if srcStrLen<0
        srcStrLen=0;
    end
    dstStr=srcStr(1,1:srcStrLen);
end

