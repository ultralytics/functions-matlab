function [] = MTCviewer()
clc; close all; format short g 
s = mfilename('fullpath'); s = s(1:find(s==filesep,1,'last')); cd(s)

[ha,hf]=fig(1,1,2,4);  set(hf,'Toolbar','figure','Units','normalized','Name','Ultralytics Viewer'); ha.Position(1)=.07;
filename = '/Users/glennjocher/Downloads/MTC/exp_0001_run_0817_salvaged.glenn.txt';

set(hf,'WindowKeyPressFcn',@fcnKeyPress);

h0 = uicontrol('Tag','eventselector','Style', 'popup','String', ' ', 'Units', 'normalized', 'Position', [.03 .89 .10 .10], 'Callback', @fcnplot1MTCevent, 'Value', 1); %[left bottom width height]
h1 = uicontrol('Style', 'pushbutton', 'String', '<', 'Units', 'normalized', 'Position', [ .01 .95 .02 .035], 'Callback', {@incrementevent,-1});
h2 = uicontrol('Style', 'pushbutton', 'String', '>', 'Units', 'normalized', 'Position', [ .13 .95 .02 .035], 'Callback', {@incrementevent,+1});
h3 = uicontrol('Style', 'pushbutton', 'String', 'DELAYED', 'Units', 'normalized', 'Position', [ .16 .94 .08 .06], 'Callback', {@swappromptdelayed,1});
h4 = uicontrol('Style', 'pushbutton', 'String', 'SPLINE ON', 'Tag','SPLINEBUTTON', 'Units', 'normalized', 'Position', [ .24 .94 .1 .06], 'Callback', {@swapinterpolate,1});
h5 = uicontrol('Style','Edit','KeyPressFcn',@my_keypressfcn);



%uicontrol('Style', 'text', 'String', sprintf('Event Number: (%g-%g)',min3(G.ve),max3(G.ve)), 'Units', 'normalized', 'Position',[.03 .95 .20 .05],'Backgroundcolor','w');
fcnfontsize(14)
G = loadnewfile(filename);


tbh = findall(gcf,'Type','uitoolbar'); %toolbar handle
tbhc=findall(tbh); %toolbar children handles
set(findobj(tbhc,'TooltipString','Open File'),'ClickedCallback', @loadnewfile)

%fcnplot1MTCevent;
%plotfilestats
end


function fcnKeyPress(a,b)
switch b.Key
    case {'leftarrow','uparrow'}
        incrementevent(0,0,-1);
    case {'rightarrow','downarrow'}
        incrementevent(0,0,1);
end

end


function G = loadnewfile(varargin)
cla; imshow('splash1.png','Parent',gca); axis image; axis off; xyzlabel(gca,' ',' ',' ',' '); legend off
drawnow

if all(ishandle(varargin{1})) || ~exist(varargin{1},'file')
    filename = '';
else
    filename = varargin{1};
end

G = fcnloadtextfile(filename,10E5,3);  if isempty(G); return; end
G.E=G.x(:,2);  G.unixTime=G.x(:,1);  G.events=fcnunique(G.E);  %A.x=int16(A.x);
G.ve = G.events;  ne=numel(G.ve);
G.ne=ne;
G.promptFlag=true;

%load('MTCpedestals.exp_0001_run_0882.glenn.txt.mat'); %load pedestals
load('MTCpedestals.exp_0099_run_0027.glenn.mat'); %load pedestals
G.pedestals=muvb;
G.pedestalOutliers=false(size(pedestalOutliers));
G.pruneChannels = pruneChannels;
G.SRCCHi = MTCpixelID2SRCCH(1:1536);  G.uhj=load('MTCmapping.mat'); G.uhj=G.uhj.X;
load MTCoffsets.mat; G.offsets=map; %pixel offsets (1-1536);
assignin('base','G',G)

str=sprintf('%.0f|',G.ve);
set(findobj(gcf,'Type','uicontrol','-and','Tag','eventselector'),'value',1,'String',str);

closeallexcept(findobj(0,'Name','Ultralytics Viewer'));

%if isempty(filename)
    fcnplot1MTCevent
    %plotfilestats
%end
view(0,90); axis normal xy tight on; grid on; %view(50,75)
end


function swappromptdelayed(varargin)
G = evalin('base','G');
if G.promptFlag
    G.promptFlag=false;
    varargin{1}.String='PROMPT';
else
    G.promptFlag=true;
    varargin{1}.String='DELAYED';
end
assignin('base','G',G)

fcnplot1MTCevent
end


function swapinterpolate(varargin)
if strcmp(varargin{1}.String,'SPLINE OFF')
  varargin{1}.String='SPLINE ON';
else
  varargin{1}.String='SPLINE OFF';
end

fcnplot1MTCevent
end


function incrementevent(varargin)
G = evalin('base','G');
increment = varargin{3};

h=findobj(gcf,'Type','uicontrol','-and','Tag','eventselector');
ei = floorandceil( get(h,'value') + increment, [1 G.ne]);
set(h,'value',ei);

fcnplot1MTCevent
end


function fcnplot1MTCevent(varargin)
if nargin==0 || isgraphics(varargin{1}) 
    G = evalin('base','G');
    ei = get(findobj(gcf,'Type','uicontrol','-and','Tag','eventselector'),'value');
else
    G = varargin{1};
    ei = varargin{2};
end
en = G.ve(ei); %event number
i = G.E==en;  G.x=G.x(i,:);  

pid = MTCSRCCH2pixelID(G.x(:,3:6));  nw=32;  RW=G.x(:,7);  W=G.x(:,8);  i=W<RW;  Wa=W-RW+1;  Wa(i)=Wa(i)+nw;

%PRUNING LIST
[~, i] = fcnpruninglist(pid); 
%i=true(size(i)); disp('WARNING NOT PRUNED!!')
pid = pid(i);  W=W(i);  V=int16(G.x(i,10:73)');  Wa=Wa(i);  nj=sum(i);

%SUBTRACT PEDESTALS
V = subtractpedestals(G.pedestals,G.pedestalOutliers,pid,W,V);

hb=findobj(gcf,'String','DELAYED','-or','String','PROMPT');
if (max(Wa)-min(Wa))>3 %AT LEAST 4 WINDOWS
    hb.Visible='on';
    if G.promptFlag
        j=firstfour(Wa,1:nj); %FIRST 4
        pstr = 'PROMPT';
    else
        j=lastfour(Wa,1:nj); %LAST 4
        pstr = 'DELAYED';
    end
else %ONLY 1 BOOKEND, AMBIGUOUS
    hb.Visible='off';
    j=1:nj;
    pstr = '';
end
Wa=Wa(j);  nw=max(Wa)-min(Wa)+1;  nj=numel(j);  pid=pid(j);  V=V(:,j);  %fwi(i)=min(Wa);  
V=removeSpikes(V);

xa = zeros(nw*64,1536,'int16');
k = sub2ind([64 nw 1536],ones(nj,1),Wa-min(Wa)+1,pid);  %DOUBLE BOOKEND

xa(k+(0:63)) = V';
xa=double(xa); %xa(xa==0)=nan; 

h=findobj('Tag','SPLINEBUTTON');
if strcmp(h.String,'SPLINE OFF')
    [stats, xa]=geteventstats(G,xa);
    %ts=std(fcnsigmarejection(stats(stats(:,4)~=0,4),2,2))
end
xa(end,:)=nan;

h=gca;  cla(h);  PMT=G.SRCCHi(pid,5);  x=(1:size(xa,1))';
for i=1:24
    y = xa(:,pid(PMT==i));  ny=size(y,2);
    if ny>0
        xi = repmat(x,[1 ny]);
        plot3(h,xi(:),y(:),xi(:)*0+i,'Color',fcndefaultcolors(i,24),'Display',sprintf('PMT %g',i),'linewidth',1);
    end
end
%fcnfontsize(28)
if ~G.promptFlag; pstr = 'DELAYED'; end
axis(h,'tight')
h.Title.String = sprintf('%s event %g %s',str_(G.filename),en,pstr); 
if ei==1; legend show; xyzlabel('Time (sample)','Amplitude (sample)','PMT'); fcnfontsize(14); end

end


function [stats, x] = geteventstats(G,x)
nanx=isnan(x);  i=all(nanx(end-63:end,:),1) & ~all(nanx,1);  x(end-63:end,i)=0;  %fix last window missing
[j, a, w, t, integral, x, ppv] = fcnpulsewidth(single(x),[.45 .50 .55],[50 90000],[5 50],1500,'fraction');  k=t~=0;

clc
w(w~=0 & ~isnan(w))

%APPLY CALIBRATIONS
a(j) = a(j)./G.offsets(j,2);
t(k) = t(k) - G.offsets(k,4);
integral(j) = integral(j)./G.offsets(j,5);

a(a~=0 & ~isnan(a))
%nansum(a)
stats = [j, a, w, t, integral, ppv]; %[triggered, amplitude, width, time, integral, prepulse]
end


function i=lastfour(w,i)
i = i( w>(max(w)-4) );
end
function i=firstfour(w,i)
i = i( w<(min(w)+4) );
end


function plotfilestats
G = evalin('base','G');
xe = G.xe;

fprintf('\nFile contains %g events over %g rows. Full file statistics:\n',G.ne,G.rows);
fprintf('mean:     %.1f\nstd:      %.1f\nmin:    %.1f\nmax:      %.1f\n\n',mean3(xe),std(xe(:)),minmax3(xe));
a = squeeze(max(max(xe,[],1),[],2));   mv = sortrows([(1:G.ne)' a],-2); %max values per event
fprintf('Most energetic events:\n       event   max value\n');  fprintf('%12g%12g\n',mv(1:6,:)')


figure(findobj(0,'Name','Ultralytics Viewer')) 
end

