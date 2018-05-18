function [] = NTCviewer()
clc; close all; format short g 
s = mfilename('fullpath'); s = s(1:find(s==filesep,1,'last')); cd(s)

[ha,hf]=fig(1,3,1.5,2);  set(hf,'Toolbar','figure','Units','normalized','Name','Ultralytics Viewer','WindowKeyPressFcn',@fcnKeyPress,'WindowButtonMotionFcn','motionNTC();'); 
ha(1).Position(1)=.04; ha(1).Position(4)=.75;  ha(1).Position(3)=.35;  
ha(2).Position(4)=.8;  ha(2).Position(2)=.1;
ha(3).Position(4)=.8;  ha(3).Position(2)=.1;
for i=1:3; axis(ha(i),'off'); end
filename = '/Users/glennjocher/Downloads/MTC/exp_0001_run_0817_salvaged.glenn.txt';

uicontrol('Tag','eventselector','Style', 'popup','String', ' ', 'Units', 'normalized', 'Position', [.03 .89 .10 .10], 'Callback', @fcnplot1MTCevent, 'Value', 1); %[left bottom width height]
uicontrol('Style', 'pushbutton', 'String', '<', 'Units', 'normalized', 'Position', [ .01 .95 .02 .035], 'Callback', {@incrementevent,-1});
uicontrol('Style', 'pushbutton', 'String', '>', 'Units', 'normalized', 'Position', [ .13 .95 .02 .035], 'Callback', {@incrementevent,+1});
uicontrol('Style', 'pushbutton', 'String', 'DELAYED', 'Units', 'normalized', 'Position', [ .16 .94 .08 .06], 'Callback', {@swappromptdelayed,1},'Tag','pushbuttonPromptDelayed');
uicontrol('Style', 'pushbutton', 'String', 'SPLINE ON', 'Tag','pushButtonSpline', 'Units', 'normalized', 'Position', [ .24 .94 .1 .06], 'Callback', {@swapinterpolate,1});

%uicontrol('Style', 'text', 'String', sprintf('Event Number: (%g-%g)',min3(G.ve),max3(G.ve)), 'Units', 'normalized', 'Position',[.03 .95 .20 .05],'Backgroundcolor','w');
fcnfontsize(14)
loadnewfile(filename);

tbh = findall(gcf,'Type','uitoolbar'); %toolbar handle
tbhc = findall(tbh); %toolbar children handles
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
ha=findobj(gcf,'Type','Axes'); for i=1:numel(ha); cla(ha(i)); end
imshow('splash1.png','Parent',ha(2)); axis image; axis off; xyzlabel(gca,' ',' ',' ',' '); legend off
drawnow

if all(ishandle(varargin{1})) || ~exist(varargin{1},'file')
    filename = '';
else
    filename = varargin{1};
end

G = fcnloadtextfile(filename,9E6,3);  if isempty(G); return; end
G.E=G.x(:,2);  G.unixTime=G.double/1E6;  G.events=fcnunique(G.E);  %A.x=int16(A.x);
G.ve = G.events;  ne=numel(G.ve);
G.ne=ne;
G.promptFlag=true;

pfile = 'pedestals.exp_0099_run_0180.glenn.mat';
load(pfile); %load pedestals
G.pedestals=muvb;
G.pedestalOutliers=false(size(pedestalOutliers));
G.SRCCHi = MTCpixelID2SRCCH(1:1536);
load MTCoffsets.mat; G.offsets=map; %pixel offsets (1-1536);
H = design(fdesign.lowpass('Fp,Fst',0.01,.2), 'equiripple');  % Design an FIR equiripple filter
H.Arithmetic = class(single(1));  G.filter = H;
assignin('base','G',G)

dt = max(G.unixTime)/1E6-minnonzero(G.unixTime)/1E6; %(s)
fprintf('\n%g events over %.1f s (%.1f Hz)\n%g missing unix times',G.ne,dt,G.ne/(dt),sum(G.unixTime==0));
[~,~,~,n]=fcnunique(G.x(:,2));  fprintf(', %g missing windows\n',sum(512-n));

% %PLOT PEDESTAL
% P = fcnwindows2channels(muvb');
% i = G.SRCCHi(G.SRCCHi(:,1)==12,1:4);  i=sortrows(i,[1 2 3 4]);  i=MTCSRCCH2pixelID(i);  Q=P(i,1:64*32);
% fig; pcolor(Q); shading flat; fcntight; colorbar; xyzlabel('T (sample)','Channel','',sprintf('%s (%g empty)',str_(pfile),sum3(Q==0)));

str=sprintf('%.0f|',G.ve);
set(findobj(gcf,'Type','uicontrol','-and','Tag','eventselector'),'value',1,'String',str);
closeallexcept(findobj(0,'Name','Ultralytics Viewer'));
fcnplot1MTCevent; view(0,90); axis normal xy tight on; grid on

%RUN STATISTICS
ne = min(ne,15000); A=cell(ne,2);
es=findobj(gcf,'Type','uicontrol','-and','Tag','eventselector');
hspline=findobj('Tag','pushButtonSpline'); hspline.String = 'SPLINE OFF'; waitbarParfor(ne);
for i=1:ne
    fprintf('TS %g/%g: %s\n',i,ne,waitbarParfor);
    es.Value=i;
    [A{i,1},A{i,2}]=fcnplot1MTCevent;
end
plotfilestats(A)
end


function swappromptdelayed(varargin)
G = evalin('base','G');
if G.promptFlag
    G.promptFlag=false;  varargin{1}.String='PROMPT';
else
    G.promptFlag=true;   varargin{1}.String='DELAYED';
end
assignin('base','G',G)
fcnplot1MTCevent;
end


function swapinterpolate(varargin)
if strcmp(varargin{1}.String,'SPLINE OFF')
  varargin{1}.String='SPLINE ON';
else
  varargin{1}.String='SPLINE OFF';
end
fcnplot1MTCevent;
end


function incrementevent(varargin)
G = evalin('base','G');
h=findobj(gcf,'-depth',1,'-and','Tag','eventselector');
h.Value = floorandceil(h.Value + varargin{3}, [1 G.ne]);
fcnplot1MTCevent;
end


function [stats, V] = fcnplot1MTCevent(varargin)
stats=[]; V=[];  gcc = get(gcf,'Children'); 
if nargin==0 || isgraphics(varargin{1}) 
    G = evalin('base','G');
    ei = get(findobj(gcc,'flat','Tag','eventselector'),'value');
else
    G = varargin{1};
    ei = varargin{2};
end
en = G.ve(ei); %event number
G.x=G.x(G.E==en,:);  

% 
% S=MTCpixelID2SRCCH([1204 1211 1203 1195])
% S =
%   4?12 int16 matrix
%     12     1     3     2    23     4     7    14   158    10    46     5
%     12     1     3     1    23     3     8    14   158    10    30     5
%     12     1     3     3    23     3     7    14   158    10    62     5
%     12     1     3     5    23     3     6    14   158    10    94     5

%PRUNE
pid = NTCIRSDmap(G.x(:,3:6),'pixel');
%i = ~any(pid==[33 34 35 36 41 42 43 44],2);  %Omron pruning list
i = ~any(pid==([106 98 108 99]+1000),2);  %ArrayX pruning list
if ~any(i); ha=findobj(gcf,'Type','Axes'); cla(ha(3)); ha(3).Title.String='WARNING: No Unpruned Data for this Event'; return; end %no unpruned data left!
%i=true(size(mtcpid));
G.x = G.x(i,:);  pid=pid(i);  mtcpid = MTCSRCCH2pixelID(G.x(:,3:6)); 

nw=32;  RW=G.x(:,7);  W=G.x(:,8);  Wa=W-RW+1;  Wa(W<RW)=Wa(W<RW)+nw;
Vx=int16(G.x(:,10:73)');  nj=sum(i);

%SUBTRACT PEDESTALS
Vx = subtractpedestals(G.pedestals,G.pedestalOutliers,mtcpid,W,Vx);  Vx(Vx==1600)=0; 

hb=findobj(gcc,'flat','Tag','pushbuttonPromptDelayed');
if (max(Wa)-min(Wa))>15 %AT LEAST 4 WINDOWS
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
Wa=Wa(j);  nw=max(Wa)-min(Wa)+1;  nj=numel(j);  pid=pid(j);  Vx=Vx(:,j);  %fwi(i)=min(Wa);  

V = zeros(nw*64,128,'int16');
k = sub2ind([64 nw 128],ones(nj,1),Wa-min(Wa)+1,pid);  %DOUBLE BOOKEND

V(k+(0:63)) = Vx';
V=single(V); %xa(xa==0)=nan;

%fig; pcolor(V); shading flat

hspline=findobj(gcc,'flat','Tag','pushButtonSpline');
if strcmp(hspline.String,'SPLINE OFF')
    %V([1 2 129 130],:)=nan; %remove stitching spikes
    V=removeSpikes(V,10);
    V=removeSpikes(V,[5 3]);
    porch=nanporch(V,20);
    V=V-porch;
    
    V=filter(G.filter,V);
    %V=fcnsmooth(V,11);
    [stats, V]=geteventstats(G,V);
    stats = [stats porch(:)];
else
    stats=zeros(128,6);
    stats(:,2) = max(V);
end
amplitude = stats(:,2);
time = stats(:,4);
V(end,:)=nan;  if nargout>0; return; end

ha=flipud(findobj(gcf,'Type','Axes'));
h=ha(1);  cla(h);  x=(1:size(V,1))';  ARRAY=NTCIRSDmap(1:128,'SRCCH');  ARRAY=ARRAY(:,6);  
for i=1:2
    y = V(:,ARRAY==i);
    if ei==1; y(:,end+1)=nan; end;  ny=size(y,2); %#ok<AGROW>
    if ny>0
        xi = repmat(x,[1 ny]);
        plot3(h,xi(:),y(:),xi(:)*0+i,'Color',fcndefaultcolors(i,2),'Display',sprintf('Array %g',i),'linewidth',1);
    end
end
if ~G.promptFlag; pstr = 'DELAYED'; end
h.XTick=1:64:size(V,1);  h.XTickLabel=0:numel(h.XTick)-1;
h.Title.String = sprintf('%s event %g %s',str_(G.filename),en,pstr);
if ei==1; legend(h,'show'); xyzlabel(h,'Time (window)','Amplitude (sample)','PMT'); end

input=[]; load NTCIRSDinputcube.mat; %loads 'input'
delete(findobj(gcf,'Tag','zp'));

sca(ha(2));
plotDetector(input,amplitude(:),ei,amplitude,hspline,'Amplitude')

sca(ha(3));
plotDetector(input,time(:),ei,amplitude,hspline,'Time')

sca(ha(1));
end


function [stats, x] = geteventstats(G,x)
nanx=isnan(x);  i=all(nanx(end-63:end,:),1) & ~all(nanx,1);  x(end-63:end,i)=0;  %fix last window missing
[j, a, w, t, integral, x, ppv] = fcnpulsewidth(single(x),[.50],[10 20000],[15 50],1500,'fraction');  k=t~=0;
%APPLY CALIBRATIONS
%a(j) = a(j)./G.offsets(j,2);
%t(k) = t(k) - G.offsets(k,4);
%integral(j) = integral(j)./G.offsets(j,5);
stats = [j, a, w, t, integral, ppv]; %[triggered, amplitude, width, time, integral, prepulse]
end

function [] = plotDetector(input,Z,ei,amplitude,hspline,titlestr)
load NTCfit.paradigm.mat
opi = input.cube.all.opposingPixel;  x=input.cube.all.xyz(1:64,1);  y=input.cube.all.xyz(1:64,2);  
ca = amplitude+amplitude(opi); %combined amplitude
ma = min(amplitude,amplitude(opi)); %min amplitude

ci = Z~=0 & Z(opi)~=0 & ma>20;  AlphaData = ones(size(Z))*.9;  AlphaData(Z==0)=.1;

if ei==1
    cla
    fcnPlotDetector(input,Z,AlphaData);
    hc=colorbar('East'); hc.Label.String='samples';  hc.Label.Units='Normalized';  hc.Label.Position=[.9 .88 0];
    fcnview('skew'); axis off equal tight;  title(titlestr); fcnfontsize(16);
else
    if strcmp(hspline.String,'SPLINE OFF')
        switch titlestr
            case 'Amplitude'
                X=Z./Z(opi);  X(~ci)=nan;
                z = F(X(1:64));
                label = Z(1:64)/2+Z(opi(1:64))/2;
            case 'Time'
                X=Z(opi)-Z;  X(~ci)=nan;
                %z = polyval(P,X(1:64)*.368); z(~isnan(z)) %LUT
                z = -X(1:64)*.368*79; z=max(min(z,100,'includenan'),-100,'includenan'); %z(~isnan(z))%79 mm/ns
                t0 = (Z+Z(opi)-190/79/.368)/2; label=t0(1:64); %t0 = (t1+t2-D/v)/2
                AlphaData(~ci)=.1;
                Z(~ci)=0;
        end
        
        z=double(z); i=~isnan(z);
        if any(i)
            hs=stem3(x,y,z/5,'.','MarkerSize',1,'Tag','zp','BaseValue',input.cube.Lr(3)); scatter3(x,y,z/5,ca(1:64)/max(ca(1:64))*100,hs.Color,'filled','Tag','zp');
            
            textlabels = num2cell(round(label(i)*10)/10);  for j=1:sum(i); textlabels{j}=['  ' num2str(textlabels{j})]; end
            text(x(i),y(i),z(i)/5,textlabels,'HorizontalAlignment','Left','Tag','zp')
            
            %[mu,V] = fitLineND([x(i) y(i) z(i)/5],ca(i));  fcnplot3([mu-V*30; mu+V*30],'-','linewidth',3,'Tag','zp');
        end
        %hp.CData = [nan(64,1); Z(65:128)];
        %hp.FaceVertexAlphaData = double(hp.CData~=0);
    end
    hp=findobj(gca,'Type','Patch');
    hp.CData = Z;
    hp.FaceVertexAlphaData = AlphaData;
    
    X=hp.CData; if any(X); ha=gca; ha.CLim = [-.1 .1] + minmax3(fcnsigmarejection(X(X~=0),60,3)); end
end

% i=[105, 106, 107, 113, 114, 115, 121, 122, 123 62, 63, 64, 54, 55, 56, 46, 47, 48, ...
% 65, 66, 67, 73, 74, 75, 81, 82, 83, 6, 7, 8, 14, 15, 16, 22, 23, 24];
% hp.FaceVertexAlphaData(i)=1;
% 
% patch(input.cube.all.v.x(i,:)', input.cube.all.v.y(i,:)', input.cube.all.v.z(i,:)','w', ...
%     'EdgeColor','r', ... 'EdgeAlpha',0, ...
%     'FaceColor','Flat', ...
%     'FaceAlpha',1, ...
%     'FaceVertexCData',hp.CData(i), ...
%     'FaceVertexAlphaData',1, ...
%     'CDataMapping','scaled', ...
%     'AlphaDataMapping','none', ...
%     'FaceLighting','none', ...
%     'BackFaceLighting','unlit', ...
%     'parent',gca);
end


function i=lastfour(w,i)
i = i( w>(max(w)-8) );
end
function i=firstfour(w,i)
i = i( w<(min(w)+8) );
end


function plotfilestats(A0)
G = evalin('base','G');
load NTCIRSDinputcube.mat;  opi = input.cube.all.opposingPixel;  %36 and 101
ne = numel(A0(:,1));
pa=22;  pb=opi(pa);  
pp = [21 23 14 30]; %perpendiculars array 1
pd = [13 15 29 31]; %diagonals array 1
cv = [pa pp pd]; 
cv=1:64;

pid = unique(NTCIRSDmap(G.x(:,3:6),'pixel'),'stable'); scanOrder=nan(128,1);

%MAPPING
S=[A0{:,1}]; S=permute(reshape(S,[128 7 numel(S)/7/128]),[1 2 3]); S(S==0)=nan; map.mu=zeros(128,7); map.s=map.mu;
for i=1:128
    for j=1:7
        x=fcnsigmarejection(S(i,j,:),3,3);  if j==1; x=S(i,j,:); x(isnan(x))=0; end
        map.mu(i,j) = mean(x);
        map.s(i,j) = std(x);
    end
    try scanOrder(i)=find(pid==i); end
end
%map.mu(:,1)=scanOrder;



ha=fig(2,5);  ml={'triggered','amplitude','width','time','integral','minimum','porch'};
for i=1:5
    sca(i);   fcnPlotDetector(input,map.mu(:,i),ones(128,1)); h=colorbar('East'); h.Label.String='samples'; title(sprintf('%s',ml{i}));  if i==3; h=title(sprintf('%s\n%s',str_(G.filename),ml{i})); h.VerticalAlignment='middle'; end
    sca(i+5); fcnPlotDetector(input,map.s(:,i),ones(128,1));  h=colorbar('East'); h.Label.String='samples'; title(sprintf('%s \\sigma',ml{i}));
end; for i=1:10; set(ha(i),'CameraViewAngle',8.5); end
%MAPPING


cv=[cv, opi(cv)'];
Va=cell(ne,1); P=zeros(ne,128);  t=P; a=P;
for i=1:ne
    x = A0{i,1};  if isempty(x); continue; end
    t(i,:) = x(:,4); %time
    a(i,:) = x(:,2); %amplitude
    P(i,:) = x(:,7); %porch
    for j=1:numel(cv)
        Va{i,j} = A0{i,2}(:,cv(j));
    end
end





dt = t(:,pb)-t(:,pa);  ar = a(:,pb)./a(:,pa);
%[~,i] = fcnsigmarejection(dt);  [~,j] = fcnsigmarejection(ar);  i = i & j & all(cellfun(@numel,Va)==256,2);
i = t(:,pb)~=0 & t(:,pa)~=0;% & (1:ne)'>7180 & (1:ne)'<7480;
dt=dt(i);  ar=ar(i);  Va=Va(i,:);  P=P(i,:);  t=t(i,:);

fig(2,2,1.5); 
sca; fhistogram(dt,60); xyzlabel('dt (samples)','','',str_(G.filename));  
sca; fhistogram(ar,60); xyzlabel('amplitude ratio');
%sca; plotDetector(input,Z,dZ,ei,amplitude,hspline,titlestr)
%sca; plotDetector(input,Z,dZ,ei,amplitude,hspline,titlestr)
sca; plot(P(:,cv)); legend('CH1','CH2'); xyzlabel('event','porch (samples)')

co = get(0,'defaultAxesColorOrder');
fig(3,3,1); for e=1:9; sca; for j=1:numel(cv); plot(Va{e,j}); end; title(e); end; fcnlinewidth(1.5); fcntight('xyjoint')

ha=fig(1,2,1.5); for j=1:numel(cv); X=[Va{:,j}];  [~,hp(j)]=fcnpulsetemplate(X,t(:,pa)); hp(j).DisplayName = sprintf('CH %g',cv(j)); end; fcntight; xyzlabel('T (sample)','Amplitude (sample)','',str_(G.filename)); legend show; legend boxoff
%sca; Z=ones(128,1); h=fcnPlotDetector(input,Z); h.FaceVertexCData=ones(128,3)*.85; for j=1:numel(cv); h.FaceVertexCData(cv(j),:)=co(j,:); end; h.FaceVertexAlphaData(cv)=1;
sca; Z=zeros(128,1); for j=1:numel(cv); Z(cv(j))=max(hp(j).YData); end; h=fcnPlotDetector(input,Z,ones(128,1)); h.FaceVertexAlphaData(cv)=1; ha(2).CLim=[0 10];  h=colorbar('East'); h.Label.String='samples'; ha(1).XLim=[0 256]; ha(1).YLim=[-10 20];

fig; fcnpulsetemplate([Va{:,cv==22}],t(:,pa));
[a,i]=sort(Z(1:64),'descend'); b=[a(1:9) cv(i(1:9))']
[a,i]=sort(Z(65:end),'descend'); b=[a(1:9) cv(i(1:9))'+64]

figure(findobj(0,'Name','Ultralytics Viewer'))
end



