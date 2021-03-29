clc;
clear;
jpegFiles = dir('jpg/A*.jpg'); 
numfiles = length(jpegFiles);
mydata = cell(1, numfiles);

for k = 1:numfiles 
  mydata{k} = imread(strcat('jpg/', jpegFiles(k).name));
%   jpegFiles(k).name
  o_p2B(mydata{k})
end

FINAL();
