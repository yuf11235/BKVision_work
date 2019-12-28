function [VolumeUp VolumeDown] = MyVolume(Z)
%Volume of deep surface
%Version:1.0, Author;WANG lei, Date:2015.6.10
%Input:
%  X,Y,Z
%Output:
%  volume
    minV=min(min(Z));
    maxV=max(max(Z));
    VolumeUp=0;
    VolumeDown=0;
    [hZ,wZ]=size(Z);
    for j=1:hZ
        for i=1:wZ
            if ~isnan(Z(j,i))
                VolumeUp=VolumeUp+(maxV-Z(j,i));
                VolumeDown=VolumeDown-(minV-Z(j,i));
            end
        end
    end
end

