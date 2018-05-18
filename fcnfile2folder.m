function pathname = fcnfile2folder(filename)
str = which(filename,'-ALL');

currentpath = strrep(cd,'\','/');
path1 = fcnpathm1(str{1});
if strcmpi(path1(1:end-1),currentpath)
    pathname = path1;
    return
elseif isempty(str) || numel(str)>1
    pathname = uigetdir([],sprintf('Select folder containing file ''%s'':',filename));
    if pathname==0; return; end;
    pathname = [pathname '/'];
else
    pathname = fcnpathm1(str{1});
end

addpath(pathname);
%addpath(fcnpathm1(pathname));
%cd(pathname);



