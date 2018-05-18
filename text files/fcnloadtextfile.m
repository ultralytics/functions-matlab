function A = fcnloadtextfile(fname,maxlines,hsflag)
if nargin<2 || ~exist('maxlines','var');  maxlines = 1E6;  end
if nargin<3 || ~exist('hsflag','var');  hsflag = true;  end %header search flag

if exist(fname,'dir')==7 %fname is a directory, not a file
    sf=fname; if sf(end)==filesep; sf=sf(1:end-1); end; isfolder=true; %search folder
else sf=pwd; isfolder=false;
end 

if nargin==0 || isempty(fname) || isfolder
    [fname, pname] = uigetfile([sf '/*.*'],'Select text file:',fcnlastfileloaded(sf),'MultiSelect','on'); 
    if isequal(fname,0) || isequal(pname,0); fprintf('No file selected ... Done.\n'); A = []; return; end
else
    if any(fname==filesep) %fname has path in it. separate
        [pname, a]=fcnpathm1(fname);  fname=a(2:end);
    else
        pname=fcnpathm1(which(fname)); %path that file is in
    end
end


if ischar(fname)
    A = fcnloadonetextfile(fname,pname,maxlines,hsflag);
else %more than one file
    nf = numel(fname);
    for i=1:nf
        A(i) = fcnloadonetextfile(fname{i},pname,maxlines,hsflag); %#ok<AGROW>
    end
end
end


function A=fcnloadonetextfile(filename,pathname,maxlines,hsflag)
A=[]; tic; pf=[pathname filename];  fcnlastfileloaded(pf);
fprintf('Loading file ''%s'' \n',filename);  if any(pathname); fprintf('from folder ''%s''...\n',pathname); end

%IF FILE IS .MAT, SIMPLY LOAD
if strcmp(filename(end-3:end),'.mat')
    fprintf('Selected .mat file...'); load(pf); fprintf(' Done (%.1fs).\n',toc); 
    A.filename=filename;  A.pathname=pathname;
    return
end

%LOAD .TXT FILE HAS ACCOMPANYING .MAT, LOAD THAT INSTEAD
if exist([pf '.mat'],'file')
    fprintf('Found matching .mat file...'); load([pf '.mat']); fprintf(' Done (%.1fs).\n',toc);
    A.filename=filename;  A.pathname=pathname;
    return
end

% %LOAD .TXT FILE HAS ACCOMPANYING .MAT, LOAD THAT INSTEAD
% pfa = [pf '.mat'];
% pfb = [pf(1:find(pf=='.',1,'last')-1) '.mat'];
% if exist(pfa,'file')
%     fprintf('Found matching .mat file...'); load(pfa); fprintf(' Done (%.1fs).\n',toc);
%     A.filename=filename;  A.pathname=pathname;
%     return
% elseif exist(pfb,'file')
%     fprintf('Found matching .mat file...'); load(pfb); fprintf(' Done (%.1fs).\n',toc);
%     A.filename=filename;  A.pathname=pathname;
%     return
% end
% fid = fopen(pf);


fid = fopen(pf);

if ~exist('maxlines','var'); maxlines = 1E7; end %max number of lines to read

if hsflag>1000 %skip bytes
    fseek(fid,hsflag,-1);
elseif hsflag>1 %skip lines
    for i=1:(hsflag-1); fgetl(fid); end; %search for header columns on row # hsflag, so skip rows
end

%SCAN FOR HEADER ROW ------------------------------------------------------
s1 = textscan(fgetl(fid),'%s');  b=s1{1};  n1=numel(b);  headerflag=false;
if n1>=3;  headerflag = ~(all(isnumericstr(b{1})) && all(isnumericstr(b{2})) && all(isnumericstr(b{3})) );  end %a character string, not a nuer
if headerflag && hsflag
    fprintf('header row detected... ')
    header = b;
elseif hsflag %skip lines
    header = cell(n1,1);
else %rewind
    fprintf('no header row... ')
    header = cell(n1,1);
    frewind(fid)
end
[format, nn, vn, ns, vs] = getformat(fid); %[formatstr, number numeric, vector numeric, number strings, vector strings]
nh=numel(header); if nh<(nn+ns);  header = cat(1,header, cell(nn+ns-nh,1));  end
fprintf('%g columns (%g numbers, %g strings)... ',nn+ns,nn,ns)
bytes = estimatedtime(filename,pathname);

if nn==73; format=format([1:2 5:end]); end % ********************** MTC GLENN FORMAT ***************************
if nn==3; format='%f%f%f'; end % ********************** TOFPET2 SINGLES FORMAT ***************************
if nh>=2 && strcmp(header{2},'PDGEncoding'); format((1:4)+4)='%f64'; end % ********************** 2017 GEANT4 FORMAT ***************************
if nh>=8 && strcmp(header{8},'PDGEncoding'); format((1:4)+26)='%f64'; end % ********************** 2017 GEANT4 FORMAT ***************************


%TEXTSCAN (FASTER) ----------------------------------
A.x=textscan(fid,format,maxlines,'Headerlines',0); %a little faster for small files
% A.x=textscan(fread(fid, 'uint8=>char')',format,maxlines,'Headerlines',0);
rows = size(A.x{1},1);

if nn==73; A.double=A.x{1}; end % ********************** MTC GLENN FORMAT ***************************
if nh>=2 && strcmp(header{2},'PDGEncoding'); A.double=A.x{2}; end % ********************** 2017 GEANT4 FORMAT ***************************
if nh>=8 && strcmp(header{8},'PDGEncoding'); A.double=A.x{8}; end % ********************** 2017 GEANT4 FORMAT ***************************

xs = cell(rows,ns);  for i=1:ns; xs(:,i)=A.x{vs(i)}; end %strings
A.x = [A.x{vn}]; %numbers

%FSCANF (SLOWER! ONLY NUMERIC!) -----------------------------------------
%     format = strrep(format,'%s','%*s'); %skip strings if any
%     xn = fscanf(fid,format,[nn maxlines])'; rows = size(xn,1);
%     xs = {};  ns=0;  vs=[];
%     header=header(min(vn,numel(header))); vn=1:nn;

A.rows = rows;
A.ftell = ftell(fid);
fprintf('%g rows... ',A.rows)
fclose(fid);  fprintf('Done %.0fMb/s (%.1fMb in %.1fs).\n',bytes/1E6/toc,bytes/1E6,toc)


%POSTPROCESSING -----------------------------------------------------------
A.names(:,1)=num2cell(1:nn+ns);                 A.names(:,2)=header;
A.numericnames(:,1)=num2cell(1:nn);             A.numericnames(:,2)=header(vn);
if ns>0;  A.stringnames(:,1)=num2cell(1:ns);    A.stringnames(:,2)=header(vs);  else A.stringnames=[]; end
A.vn = vn;
A.vs = vs;
A.xs = xs; %string data
A.filename = filename;
A.pathname = pathname;  i=find(pathname==filesep);
A.loadTime = toc; %(s)

                      a=pathname(i(end-1):i(end));        A.p1=a;  A.pf1=[a filename];
a=[]; if numel(i)>2;  a=pathname(i(end-2):i(end)); end;   A.p2=a;  A.pf2=[a filename];
a=[]; if numel(i)>3;  a=pathname(i(end-3):i(end)); end;   A.p3=a;  A.pf3=[a filename];
A.format = format;
end


function b = estimatedtime(fname,pathname)
% read 46,700 rows/s at 70 cols per row = 3.27E6 values/s.
finfo = dir([pathname fname]);
b = finfo.bytes;
t = b/50E6; % (s) est read time
if t>1;  fprintf('please wait %.0fs (%.0fMb @50Mb/s)... ',t,b/1E6);  end
end
