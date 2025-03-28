% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function hout = fcnscatter3(h,x,y,z,s,c)
cm = colormap;
ni = size(cm,1);

clims = get(h,'clim');
ci = fcnindex1(linspace(clims(1),clims(2),ni),c);  ci = max(min(ci,ni),1);

% clims = [min(c) max(c)];
% set(h,'clim',clims)
hc = sort(findobj(h,'userdata',1));
if isempty(hc)
    hout=zeros(ni,1);
    for i=1:ni
        v1=find(ci==i);
        if ~isempty(v1)
            hout(i)=plot3(h,x(v1),y(v1),z(v1),'.','color',cm(i,:));
        else
            hout(i)=plot3(h,0,0,0,'.','color',cm(i,:));
        end
    end
    set(hout,'markersize',s,'userdata',1);
else
    for i=1:ni
        v1=find(ci==i);
        if ~isempty(v1)
            set(hc(i),'xdata',x(v1),'ydata',y(v1),'zdata',z(v1))
        else
            set(hc(i),'xdata',[],'ydata',[],'zdata',[])
        end
    end
    hout=h;
end


end

