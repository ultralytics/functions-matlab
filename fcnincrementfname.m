% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function str = fcnincrementfname(str)
if exist([pwd filesep str],'file')==0
    return
end

i=find(str=='.',1,'last');
if ~isempty(i)
    fname = str(1:i-1);
    extension = str(i:end);
else
    fname=str;
    extension=[];
end


i=isnumericstr(fname);
if any(i)
    number = eval(fname(i));
    fname = fname(1:find(i==false,1,'last'));
else
    number = 0;
end

while exist([pwd filesep str],'file')~=0
    number = number+1;
    str = sprintf('%s%.0f%s',fname,number,extension);
end


