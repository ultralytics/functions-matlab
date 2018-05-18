function [h] = fcnplotline(varargin)
%varargin = {xyz,c}
%c = color, i.e. c='b.-'
%xyz = [xlocation ylocation zlocation], i.e. [nan 2], [2 nan], [nan 2 5], [1 nan 3], [6 2 1]
nin = nargin;
if all(isgraphics(varargin{1},'axes')); ha=varargin{1}; nin=nin-1; varargin=varargin(2:end); else ha=gca; end

xyz = varargin{1};
if nin==1
    c='b-';
elseif nin==2
    c=varargin{2};
end

nx = numel(xyz);
if isempty(c); c='b-';  end
for i=1:numel(ha)
    hb=ha(i);
    
    %fcntight(ha,'xyz');
    axis(hb,'tight')
    
    xl = get(hb,'xlim');
    yl = get(hb,'ylim');
    x=xyz(1); y=xyz(2);
    if nx==3
        z=xyz(3);
        zl = get(hb,'zlim');
        
        if all(~isnan(xyz([2 3])));  h(1,i)=plot3(hb,xl,y*[1 1],z*[1 1],c);  end
        if all(~isnan(xyz([1 3])));  h(2,i)=plot3(hb,x*[1 1],yl,z*[1 1],c);  end
        if all(~isnan(xyz([1 2])));  h(3,i)=plot3(hb,x*[1 1],y*[1 1],zl,c);  end
    else %x==2
        if ~isnan(xyz(2)); h(1,i)=plot(hb,xl,y*[1 1],c); end
        if ~isnan(xyz(1)); h(1,i)=plot(hb,x*[1 1],yl,c); end
    end
end
h=h(:)';