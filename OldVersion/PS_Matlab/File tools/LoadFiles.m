%function LoadFiles
% 载入文件夹
%pathName = uigetdir(cd, '请选择文件夹');
% if pathName == 0
%     msgbox('您没有正确选择文件夹');
%     return;
% end
function [fileNum filePathArray fileNameArray] =LoadFiles(pathName,filetype)
%pathName = 'G:\彩色相机测试程序\matlab\';
% 搜索bmp格式文件
fileNameArray = ls(strcat(pathName,'\*.',filetype));
filePathArray = strcat(pathName,fileNameArray); % 得到文件路径
%filePathSet=cell2mat(filePathSet);
%fileNum = length(size(filePathArray)); % 文件个数
fileNum = size(filePathArray,1); % 文件个数
clc;