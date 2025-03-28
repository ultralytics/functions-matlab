% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [] = fcnmexall()
clc; close all
% a=what; a=a.mex; n=numel(a);
% for i=1:n
%     b = fesplit(a{i});
%     s = sprintf('mex %s.cpp',b); fprintf('%s\n',s);
%     eval(s); fprintf('\n');
% end

s=ls;
TABCHAR = sprintf('\t');
RTNCHAR = 10; %sprintf('\n');
i=strfind(s,'.cpp');  n=numel(i); files=cell(n,1);
for j=1:n
   t=s(1:i(j)+3);
   k=find(t==TABCHAR | t==RTNCHAR | t==' ',1,'last');
   if any(k);  t=t(k:end); end
   files{j}=strtrim(t);
end

for i=1:n
    b = fesplit(files{i});
    s = sprintf('mex %s.cpp',b); fprintf('%s\n',s);
    
    try 
        eval(s); 
    catch
        sprintf('FAILURE ------------ FAILURE IN:  %s',s);
    end
        fprintf('\n');
end