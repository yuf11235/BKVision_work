function dstStr= GetFileNameFromPath(srcStr)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    srcStr=StrDelTail(srcStr);
    srcStrLen=length(srcStr);
    dstStr=srcStr;
    for i=srcStrLen:-1:1
        if strcmp(srcStr(1,i),'\') ||strcmp(srcStr(1,i),'/')
            dstStr=srcStr(1,i+1:srcStrLen);
            break;
        end
    end
    srcStr=dstStr;
    srcStrLen=length(srcStr);
    for i=srcStrLen:-1:1
        if strcmp(srcStr(1,i),'.')
            dstStr=srcStr(1,1:i-1);
        end
    end
end

