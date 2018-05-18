function extractPlotData()
clc; close all;
fname = uigetfile('*.*');
A = importdata(fname);  if isstruct(A); cdata=A.cdata; else cdata=A; end
imshow(cdata+100); axis image tight equal

%ENTER LIMS [xmin xmax ymin ymax]
xlims = [400 800];
ylims = [0 2.5];

%CLICK CORNERS
fprintf('Click bottom left corner\n');  [x0, y0] = ginput(1);
fprintf('Click top right corner\n');    [x1, y1] = ginput(1);

%CLICK ON CURVE
fprintf('Trace Curve. Click once to start tracing, then a second time to stop.\n')

I = cdata(round(y1:y0),round(x0:x1),:);
cla; imshow(I+100); hold on

%set(gca,'xscale','log','yscale','log')

button=1;  i=0;  x=[];  y=[]; hs=[];
while button == 1
    i = i+1;
    [x(i), y(i), button] = ginput(1); %#ok<AGROW>
    plot(x(i),y(i),'g.','markersize',20);

    if i>1
        if sum(x(i)==x & y(i)==y)>1; i=i-1; continue; end %duplicate point
        xp = linspace(x(1),x(end),1000);
        yp = interp1(x,y,xp,'spline');
        
        deleteh(hs);
        hs = plot(xp,yp,'g-');
    end
end
Irows = size(I,1);
Icols = size(I,2);
y = Irows - y;

x = x/Icols * diff(xlims) + xlims(1); %#ok<*NASGU>
y = y/Irows * diff(ylims) + ylims(1);
[x,i]=unique(x); y=y(i);

save([fname ' trace.mat'],'x','y','fname')
end

function interpPlot()
p=load('SG BCF-98 Absorption.png trace.mat');  p.y = fcnsignalLoss2attenuationLength(p.y);
x = (82:2000)';   
F = griddedInterpolant(p.x,p.y,'spline');  y = F(x); 
i = x<min(p.x) | x>max(p.x);  edge=round((max(p.x)-min(p.x))*.2);
F = griddedInterpolant([p.x(1)-edge*[2 1] p.x p.x(end)+edge*[1 2]],[0 0 p.y 0 0],'pchip');  y(i) = F(x(i)); 
y=max(y,0);
fig; plot(p.x,p.y,'r.','Markersize',25); plot(x,y,'b.-') 
al=y; save BCF98.attenuationLength.mat x al
end

