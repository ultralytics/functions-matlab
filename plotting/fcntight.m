function varargout = fcntight(varargin)
%example: fcntight('y'); fcntight(gca,'xy'); fcntight('evenx'); 
%example: fcntight('evenjointxyz'); fcntight('c') for color
%example: fcntight('y0') sets y lower limit to 0
%joint: all axes in figure the same as largest
%even: largest tight axes reflected about zero


% ADD TIGHT 'COLOR' to automatically set the colormaps tight, across axes
%findobj(get(get(gca,'children'))
% 	AlphaData = [1]
% 	AlphaDataMapping = scaled
% 	Annotation = [ (1 by 1) hg.Annotation array]
% 	CData = [ (360 by 180) double array]


if nargin==1
    if any(isgraphics(varargin{1}))
        h = varargin{1};  h=h(isgraphics(h));
        b = parsestr('xyz');
    else
        h = findobj(gcf,'type','axes'); %,'tag',''); %h = gca;
        b = parsestr(varargin{1});
    end
elseif nargin==2
    h = varargin{1};   h=h(isgraphics(h));
    b = parsestr(varargin{2});
else
    h = findobj(gcf,'type','axes','tag',''); %h = gca;
    b = parsestr('xyz');
end
[joint, even, tx, ty, tz, tc, x0, y0, z0, c0, sigma] = deal(b{:});
n = numel(h);

[mmx, mmy, mmz, mmc] = fcnaxesdatalims(h,sigma);

if x0; mmx(:,1)=0; end
if y0; mmy(:,1)=0; end
if z0; mmz(:,1)=0; end
if c0; mmc(:,1)=0; end

if even
    mmx = max(abs(mmx),[],2)*[-1 1];
    mmy = max(abs(mmy),[],2)*[-1 1];
    mmz = max(abs(mmz),[],2)*[-1 1];
end
if joint
    mmx = repmat([min(mmx(:,1)), max(mmx(:,2))], [n 1]);
    mmy = repmat([min(mmy(:,1)), max(mmy(:,2))], [n 1]);
    mmz = repmat([min(mmz(:,1)), max(mmz(:,2))], [n 1]);
    mmc = repmat([min(mmc(:,1)), max(mmc(:,2))], [n 1]);
    
    if numel(h)==1 && tx && ty && tz && even %then 'joint' means x y and z axes jointeven instead of figure subaxes togethor
        a = [mmx; mmy; mmz];  a = a([tx; ty; tz]>0,:);  a = max(abs(a(:)));
        mmx = [-a a];  mmy = [-a a];  mmz = [-a a];
    end
end

i=mmx(:,1)==mmx(:,2);  mmx(i,1)=mmx(i,1)-1;  mmx(i,2)=mmx(i,2)+1; %empty plots or 1 point
i=mmy(:,1)==mmy(:,2);  mmy(i,1)=mmy(i,1)-1;  mmy(i,2)=mmy(i,2)+1; 
i=mmz(:,1)==mmz(:,2);  mmz(i,1)=mmz(i,1)-1;  mmz(i,2)=mmz(i,2)+1; 

nanx=~any(isnan(mmx),2);
nany=~any(isnan(mmy),2);
nanz=~any(isnan(mmz),2);
nanc=~any(isnan(mmc),2);

if tx==0 && ty==0 && tz==0 && tc==0; tx=1; ty=1; tz=1; end
for i = 1:n
    if tx && nanx(i);  h(i).XLim=mmx(i,:);  end
    if ty && nany(i);  h(i).YLim=mmy(i,:);  end
    if tz && nanz(i);  h(i).ZLim=mmz(i,:);  end
    if tc && nanc(i);   if mmc(i,1)==mmc(i,2); mmc(i,:)=mmc(i,:)+[-1 1]*1E-9; end;   h(i).CLim=mmc(i,:);  end
end


if nargout>0
    varargout = {mmx,mmy,mmz,mmc};
end

end



function b = parsestr(str)
if numel(str)==0; return; end
a = {'joint','even','x','y','z','c','x0','y0','z0','c0','sigma'};  b=cell(size(a));
for i=1:numel(a)
   b{i} = any(regexpi(str,a{i}));
end
end