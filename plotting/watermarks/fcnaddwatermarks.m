function [] = fcnaddwatermarks(fname)
if nargin==0 || isempty(fname)
    [fname,pname]=uigetfile('*.*','Select image to add watermarks to:','MultiSelect','on');
    if numel(fname)==1 && fname==0; fprintf('No file selected ... Done.\n'); return; end
else
    pname = fcnfile2folder(fname);
end
%clc; clear all; close all; filename = 'EXAMPLE.png';     pathname = fcnfile2folder(filename);

s = sprintf('%swatermarked%s%s',pname,filesep);
if ~exist(s,'dir');  mkdir(s); end

if iscell(fname)
    n = numel(fname);
    for i=1:n
        fcnadd1watermark(fname{i},pname)
        fprintf('%g/%g\n',i,n)
    end
else
    fcnadd1watermark(fname,pname)
end
end


function [] = fcnadd1watermark(fname,pname)
I = importdata([pname fname]);  if isstruct(I); I=I.cdata; end
I = single(I);  Is = size(I);


%OPTIONS YOU CAN SPECIFY --------------------------------------------------
mean3(I)
if mean3(I)<160 %bottom left for dark images
    %logos = {'NGAlogo.png','UHlogo.png','UMlogo.png','HPUlogo.png','ULlogo.png'};
    logos           = {'ULVlogo.png'};
    position        = 'left bottom'; %i.e. 'bottom left', 'top right', 'center left', 'center bottom'
    order           = 'left to right'; %'top to bottom' or 'left to right'
    logosize        = .27;%.08; %fraction of image height
    transparency    =  1.00; %0 = logos fully transparent, 1 = fully opaque
else %large and translucent for light images
    logos = {'NGAlogo.png'};
    position        = 'center center'; %i.e. 'bottom left', 'top right', 'center left', 'center bottom'
    if Is(1)<Is(2);
        order           = 'left to right'; %'top to bottom' or 'left to right'
    else
        order           = 'top to bottom'; %'top to bottom' or 'left to right'
    end
    logosize        = 1; %fraction of image height
    transparency    = .12; %0 = logos fully transparent, 1 = fully opaque
end
%OPTIONS YOU CAN SPECIFY --------------------------------------------------


n = numel(logos);
A = cell(n,1); C=A; S=A; %left to right
for i = 1:n
    
    logo = importdata(logos{i});
    if isfield(logo,'cdata')
        cdata = single(logo.cdata);
        if isfield(logo,'alpha')
            alpha = single(logo.alpha(:,:,1))/256;
        else
            alpha = ones(size(cdata(:,:,1)));
        end
    else
        cdata = single(logo);
        alpha = ones(size(cdata(:,:,1)));
    end
    s = size(cdata); if numel(s)==2; cdata=repmat(cdata,[1 1 3]); end
    rows=round(Is(1)*logosize);  alpha = imresize(alpha,[rows nan]);  cdata = imresize(cdata,[rows nan]);
    
    %ADD BORDER
    b = ceil(rows*.03); %border
    A{i} = padarray(alpha,[b b],0);
    C{i} = padarray(cdata,[b b],0);
    S{i} = size(alpha);

end

if strcmpi(order,'left to right');
    A = A';  C = C';
else
    s = cell2mat(S); %[r1 c1; r2 c2]
    mr = max(s(:,2));
    er = mr - s(:,2); %extra rows needed
    for i = find(er)
        A{i} = padarray(A{i},[0 er(i)],0,'post');
        C{i} = padarray(C{i},[0 er(i)],0,'post');
    end
end
A=cell2mat(A);  C=cell2mat(C);  
if size(A,1)>Is(1); A = imresize(A,[Is(1) nan]);  C = imresize(C,[Is(1) nan]); end
if size(A,2)>Is(2); A = imresize(A,[nan Is(2)]);  C = imresize(C,[nan Is(2)]); end
s = size(A);

p = [0 0];
d = Is(1:2)-s;
if  ~isempty(regexpi(position,'left'))
    p(2) = 10;
end
if  ~isempty(regexpi(position,'right'))
    p(2) = Is(2)-s(2)-10;
end
if  ~isempty(regexpi(position,'top'))
    p(1) = 10;
end
if  ~isempty(regexpi(position,'bottom'))
    p(1) = Is(1)-s(1)-10;
end
n=numel(regexpi(position,'center'));
if  n==2 %center-center
    p = floor(d/2);
elseif n==1
    if p(1)==0; %centered left-right
        p(1) = round((Is(1)+1-s(1))/2);
    else %centered top to bottom
        p(2) = round((Is(2)+1-s(2))/2);
    end
end
p(1) = min(max(p(1),1),d(1));
p(2) = min(max(p(2),1),d(2));


r = p(1)+(1:s(1));  c = p(2)+(1:s(2));
A = A*transparency;
for j=1:3
    I(r,c,j) = I(r,c,j).*(1-A) + C(:,:,j).*A;
end

i=find(fname=='.');
prettyname = fname(1:i-1);
extension = fname(i+1:end);
imwrite(uint8(I),sprintf('%swatermarked%s%s.%s',pname,filesep,prettyname,extension))
end


