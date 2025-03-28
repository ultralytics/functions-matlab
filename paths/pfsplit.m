% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [pname, fname, fnamepretty] = pfsplit(str)
%path and filename split
%['/Users/glennjocher/Desktop/APR25/', 'Neutron_Run_2.txt', 'Neutron Run 2'] = pfsplit('/Users/glennjocher/Desktop/APR25/Neutron_Run_2.txt')

i=find(str==filesep,1,'last');  
if isempty(i)
    i = 0;
    pname = '';
else
    pname = str(1:i);
end
fname = str(i+1:end);

if nargout==3
   s = str(i+1:find(str=='.',1,'last')-1);
   fnamepretty = strrep(s,'_',' ');
end


