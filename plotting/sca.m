% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function h=sca(h)
%sets current axis, like axes(h) but faster

if nargin==0 %sets next subplot as current axis. On last subplot loops back to first subplot
    hf = gcf;
    hc=flip(findobj(hf,'type','axes','Tag',''));
    nc = numel(hc);
    
    i = find(gca==hc); %subplot index
    if i==1 && isempty(hc(1).UserData) && isempty(hc(1).Children) %first plot
        h=hc(1);  h.UserData=1;
    elseif i==nc %last plot
        h = hc(1);
    else
        h = hc(i+1);
    end
    hf.CurrentAxes=h;
elseif isnumeric(h) &&  h==round(h) %number
    hf=gcf;
    hc=findobj(hf,'type','axes');  hc=flip(hc); %returns in reverse order!
    hf.CurrentAxes = hc(h);
elseif isgraphics(h) %axis handle
    hf = h.Parent;
    set(0,'CurrentFigure',hf);
    %hf.CurrentAxes=h;
    set(hf,'CurrentAxes',h);
end
    