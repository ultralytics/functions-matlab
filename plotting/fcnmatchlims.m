% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function fcnmatchlims(h0,h)
if nargin==0 %match all subplot axes limits to the biggest one
    h = findobj(gcf,'type','axes','-not','Tag','legend');  n=numel(h);
    for i=1:n
        [mmx(i,:),mmy(i,:),mmz(i,:)] = fcnaxesdatalims(h(i)); %#ok<AGROW>
    end
    mmx=minmax3(mmx);  mmy=minmax3(mmy);  mmz=minmax3(mmz);
    set(h,'xlim',mmx,'ylim',mmy,'zlim',mmz);
    return
elseif nargin==1 %make all other subplots mimic h0
    h = findobj(get(h0,'parent'),'type','axes','-and','Tag','');   h=h(h~=h0);
end

%make 'h' mimic 'h0'
n = numel(h);
x = get(h0,'xlim');  xd = get(h0,'xdir');
y = get(h0,'ylim');  yd = get(h0,'ydir');
z = get(h0,'zlim');  zd = get(h0,'zdir');
cva = get(h0,'CameraViewAngle');
cp = get(h0, 'CameraPosition');
ct = get(h0, 'CameraTarget');
cuv = get(h0,'CameraUpVector');
v = get(h0,'View');

for j=1:2
    for i=1:n
        set(h,'xlim',x,'ylim',y,'zlim',z,'xdir',xd,'ydir',yd,'zdir',zd,'CameraViewAngle',cva,'CameraPosition',cp,...
            'CameraTarget',ct,'CameraUpVector',cuv,'View',v);
        %set(h,'xlim',x,'ylim',y,'zlim',z,'xdir',xd,'ydir',yd,'zdir',zd,'CameraViewAngle',cva,'CameraPosition',cp,'View',v);
    end
end
