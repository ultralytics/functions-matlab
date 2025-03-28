% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [] = fcnrotateaxes(h,x,n)
%x = [az, el]; %deg
%n = number of steps to do it in
if nargin==2
    n = 50;
end

if ismac
    n=round(n/3);
end

[az1, el1] = view(h);                  
az2 = x(1);
el2 = max(x(2),-89.9999);  

if az1==az2 && el1==el2
    return
end

del = el2-el1;
daz = az2-az1;
if abs(daz)>180 && ~any(abs(daz) == [180 360])
    daz = mod(daz,-sign(daz)*180);
end

v = logspace(0,-2,n); v = 1 - (v(2:end)-v(end));
az = az1 + v*daz;
el = el1 + v*del;

for i = 1:numel(v)
    [aznow, elnow] = view;
    if i>1 && (az(i-1)~=aznow || el(i-1)~=elnow) 
        return %the button's been interrupted by another click
    end
    view(h,az(i),el(i)); drawnow
end
view(h,mod(az(i),360),el(i));