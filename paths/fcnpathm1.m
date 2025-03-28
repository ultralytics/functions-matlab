% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [str, t] = fcnpathm1(str)
%path minus 1

if find(str==filesep,1,'last')==numel(str)
    i=find(str(1:end-1)==filesep,1,'last');
else
    i=find(str(1:end)==filesep,1,'last');
end
t = str(i:end);
str = str(1:i);
