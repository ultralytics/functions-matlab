function [h,a] = coasts(ha)
% coasts = gshhs('gshhs_i.b');  cl = [coasts.Level];  coasts = coasts(cl==1);    
% Lat = [coasts.Lat];
% Lon = [coasts.Lon];
% save coasts.mat Lat Lon
%a=load('coasts.mat'); h=[];

c = [1 1 1]*.7;

if nargin==1 && isgraphics(ha)    
    %b=shaperead('ne_10m_admin_0_boundary_lines_land');
    b=shaperead('ne_10m_admin_0_countries_lakes');
    x=[b(:).X];  y=[b(:).Y];
    h(1)=geoshow(y,x,'DisplayType','line','Color',c,'Linewidth',1);  %h(2).Children.ZData=h(2).Children.XData*0+10;

    %h(2)=geoshow(a.Lat,a.Lon,'DisplayType','line','Color','g','Linewidth',1); %Hi Res Coastlines
end

