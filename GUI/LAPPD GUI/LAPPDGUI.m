function [] = LAPPDGUI()
clc; close all; format short g 
s = mfilename('fullpath'); s = s(1:find(s==filesep,1,'last')); cd(s)

fig(1,1,2,4);  set(gcf,'Tag','LAPPD GUI','Toolbar','figure','Units','normalized','Name','LAPPD GUI')

filename = 'demount_2700V_x-12239_y-64239_board2.txt';
G = loadnewfile(filename);

str=sprintf('%.0f|',G.ve);
h0 = uicontrol('Tag','eventselector','Style', 'popup',      'String', str(1:end-1), 'Units', 'normalized', 'Position', [.03 .85 .10 .10], 'Callback', @fcnLAPPDGUIplot1event, 'Value', 1);
h1 = uicontrol('Style', 'pushbutton', 'String', '<', 'Units', 'normalized', 'Position', [ .01 .915 .02 .035], 'Callback', {@incrementevent,-1});
h2 = uicontrol('Style', 'pushbutton', 'String', '>', 'Units', 'normalized', 'Position', [ .13 .915 .02 .035], 'Callback', {@incrementevent,+1});
uicontrol('Style', 'text', 'String', sprintf('Event Number: (%g-%g)',min3(G.ve),max3(G.ve)), 'Units', 'normalized', 'Position', get(h0,'Position').*[1 1 1 0] + [0 .10 0 .03],'Backgroundcolor','w');

tbh = findall(gcf,'Type','uitoolbar'); %toolbar handle
tbhc=findall(tbh); %toolbar children handles
set(findobj(tbhc,'TooltipString','Open File'),'ClickedCallback', @loadnewfile)

fcnLAPPDGUIplot1event;  view(50,75)
plotfilestats
end


function G = loadnewfile(varargin)
if all(ishandle(varargin{1}))
    filename = '';
else
    filename = varargin{1};
end

G = fcnloadtextfile(filename,1E6,0);  if isempty(G); return; end
xn = G.x;

ne = size(xn,1)/256; %number of events
xe = reshape(xn,[256 ne 32]);
xe = permute(xe,[1 3 2]); %[256 32 ne]
xe = xe(:,2:end-1,:);

%AUTO-PEDESTALS
xe = xe - mean(xe(:));
xe = xe - mean(xe,3);

G.xe=xe;
G.ne=ne;
G.ve=1:ne;
assignin('base','G',G)

set(findobj(gcf,'Type','uicontrol','-and','Tag','eventselector'),'value',1);
closeallexcept(findobj(0,'Name','LAPPD GUI'));

if isempty(filename)
    fcnLAPPDGUIplot1event
    plotfilestats
end
end


function incrementevent(varargin)
G = evalin('base','G');
increment = varargin{3};

h=findobj(gcf,'Type','uicontrol','-and','Tag','eventselector');
ei = floorandceil( get(h,'value') + increment, [1 G.ne]);
set(h,'value',ei);

fcnLAPPDGUIplot1event
end


function plotfilestats
G = evalin('base','G');
xe = G.xe;

fprintf('\nFile contains %g events over %g rows. Full file statistics:\n',G.ne,G.rows);
fprintf('mean:     %.1f\nstd:      %.1f\nmin:    %.1f\nmax:      %.1f\n\n',mean3(xe),std(xe(:)),minmax3(xe));
a = squeeze(max(max(xe,[],1),[],2));   mv = sortrows([(1:G.ne)' a],-2); %max values per event
fprintf('Most energetic events:\n       event   max value\n');  fprintf('%12g%12g\n',mv(1:6,:)')

mu = mean(xe,3);
s = std(xe,[],3);

ha = fig(2,3,1.5);
sca(ha(1)); surf(mu'); shading flat; axis tight; colorbar; grid off; xyzlabel('t (bin)','strip','',sprintf('mean ''%s''',str_(G.filename))); view(70,40);
sca(ha(2)); surf(s'); shading flat; axis tight; colorbar; grid off; xyzlabel('t (bin)','strip','','standard deviation'); %view(70,40)
sca(ha(3)); surf(max(xe,[],3)'); shading flat; axis tight; colorbar; grid off; xyzlabel('t (bin)','strip','','max'); view(70,40)
sca(ha(4)); plotribbons(xe);
sca(ha(5)); fcnhist(xe(:)); xyzlabel('','','','Value Histogram')

sxe = size(xe);
%xf = squeeze(xe(:,10,:));
xf = reshape(xe,[sxe(1) sxe(2)*sxe(3)]);
i = any(xf<-200,1);  ni=sum(i);

if ni>0
    ha = fig(2,3,1.5);
    sca(ha(1));
    plot(xf(:,i)); xyzlabel('t (sample)','V (sample)','',sprintf('signals (%.2f efficient)',ni/numel(i)))
    sca(ha(2));
    
    [minval, tsignals] = min(xf(:,i));
    fcnhist(minval,30); xyzlabel('V (sample)','','','Amplitude Histogram')
    sca(ha(3));
    %xg = xe(:,1,:);
    %[maxval, ttriggers] = max(xg(:,i));

    %plot(xg(:,i)); xyzlabel('t (sample)','V (sample)','','triggers')
end

figure(findobj(0,'Name','LAPPD GUI')) 
end


function plotribbons(x)
n=100; %number of histogram bins
m=30; %number of strips
yh = zeros(m,n);
xh = linspace(-100,100,n);
for i=1:m
    a=x(:,i,:); a=a(:); a=a(a~=0);
    [yhi, xh] = fcnhist(a,xh);  dxh=xh(2)-xh(1);
    %yhi=yhi./max(yhi(8:end-2));
    yh(i,:) = yhi;
end
fcnribbon(xh,yh); xyzlabel('strip','V (bins)');
end