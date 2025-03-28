% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [] = fcnbox(h,str)
%fcnbox(h,'on')
if nargin==1 
    h = gca;
end

for i=1:numel(h)
   box(h(i),str);
end