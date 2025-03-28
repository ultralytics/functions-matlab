% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function liteviewer
clc; close all; format short g 
s = mfilename('fullpath'); 
s = s(1:find(s==filesep,1,'last'));
addpath(s)
addpath(genpath([s 'liteviewer files\']))
%cd(s)

G = fcnloadGEANT();
if any(G.vs)
    processname=G.xs(:,2);
else
    processname=repmat({''},[G.rows 1]);
end

%PRINT ENTIRE GEANT FILE REPORT TO SCREEN ---------------------------------
pid = G.x(:,7); %particleID
tid = G.x(:,8); %trackID
parent = G.x(:,9); %parent trackID (parentID)
ke1 = G.x(:,18);
ke2 = G.x(:,19);
dE = G.x(:,20);
eventnumber = G.x(:,1);
steplength = G.x(:,21);
particlename = fcnpid2name(pid);

[upid,I,J] = unique(pid);
fprintf('\nGEANT file contains %.0f events on %.0f rows. Full file statistics: \n',G.ne,numel(pid))
fprintf('        Particle     Tracks       Rows    dE (MeV) length(mm)\n')
for i=1:numel(upid)
    j = find(pid==upid(i));
    nrows = sum(J==i);
    name = particlename{I(i)};
    Bi = unique([eventnumber(j) tid(j)],'rows');
    
    nutid = size(Bi,1);
    dEi = sum(dE(j))/nutid;
    Li = sum(steplength(j))/nutid;
    fprintf('%16s%11.0f%11.0f%11.4f%11.2f\n',name,nutid,nrows,dEi,Li);
end
fprintf('\n')
hmotion=[];  
assignin('base','hmotion',hmotion);

%LOAD EVENT ---------------------------------------------------------------
[~, hf] = fig(1,1,2);  assignin('base','haxes1',gca);
str=sprintf('%.0f|',G.ve);
h0 = uicontrol('Style', 'popup', 'String', str(1:end-1), 'Units', 'normalized', 'Position', [.03 .85 .10 .10], 'Callback', @fcnpopupevent, 'Value', 1);
uicontrol('Style', 'text', 'String', 'Event Number:', 'Units', 'normalized', 'Position', get(h0,'Position').*[1 1 1 0] + [0 .10 0 .03],'Backgroundcolor','w');
set(hf,'Toolbar','figure','Units','normalized','WindowButtonMotionFcn','hmotion=fcnmotion(x,particlename,processname,hmotion,haxes1);','WindowScrollWheelFcn',@fcnscroll,'WindowButtonUpFcn', '', 'WindowButtonDownFcn', '')

[x, h, nupid, upid, pid] = fcnpopupevent(h0);

% str=[];  for i=1:nupid;  str=[str sprintf('%s|',fcnparticleID2name(upid(i),pid,particlename))];  end
% h1 = uicontrol('Style', 'listbox', 'String', str(1:end-1), 'Max', 10, 'Units', 'normalized', 'Position', [.83 .6 .15 .25], 'Callback', @fcnlist, 'Value', 1:nupid, 'UserData', 1:nupid);
% uicontrol('Style', 'text', 'String', 'Prompt', 'Units', 'normalized', 'Position', get(h1,'Position').*[1 1 1 0] + [0 .26 0 .03]);
% 
% str=[];  for i=1:nupid;  str=[str sprintf('%s|',fcnpid2name(upid(i)))];  end
% h2 = uicontrol('Style', 'listbox', 'String', str(1:end-1), 'Max', 10, 'Units', 'normalized', 'Position', [.83 .25 .15 .25], 'Callback', @fcnlist, 'Value', 1:nupid, 'UserData', 1:nupid);
% uicontrol('Style', 'text', 'String', 'Delayed', 'Units', 'normalized', 'Position', get(h2,'Position').*[1 1 1 0] + [0 .26 0 .03]);

function [x, h,nupid,upid,pid]=fcnpopupevent(h,j)
strh = get(h,'string');
ei = eval(strh(get(h,'value'),:));
[x, h,nupid,upid,pid]=fcnplotevent(ei,G.x,particlename,processname);
end

end

function [x, h nupid upid pid]=fcnplotevent(event,x0,particlename,processname)
fprintf('Loading Event %.0f:\n',event);

cla
v1 = x0(:,1)==event;
if ~any(v1)
    x=[];
    h=[];
    nupid = 0;
    upid = [];
    pid = [];
    fprintf('Warning: No data found for event %.0f.\n',event);
    return
end

x=x0(v1,:);  particlename=particlename(v1);  processname=processname(v1);
pid = x(:,7); %particleID
tid = x(:,8); %trackID
parent = x(:,9); %parent trackID (parentID)
ke1 = x(:,18);
ke2 = x(:,19);
dE = x(:,20);
t1 = x(:,16);
eventnumber = x(:,1);
steplength = x(:,21);

assignin('base','x',x);
assignin('base','particlename',particlename);
assignin('base','processname',processname);

ha=gca;
v2 = pid==0;
photonflag = any(v2);
if photonflag
    wl = fcne2wl(ke1(v2),1.5);
    hff = figure;
    set(hff,'Position',[830 50 450 800],'Toolbar','figure');
    subplot(211)
    [n,nx] = hist(wl,100);
    bar(nx,n,1,'facecolor',[.7 .7 .7],'edgecolor',[.3 .3 .3])
    xlabel('Wavelength (mm)'); title('photon \lambda histogram')
    
    tvec = linspace(min(t1(v2)),max(t1(v2)),100);
    subplot(212)
    hhist=gca;  hold(hhist,'on')
    %hist(t1,100); axis tight
    xlabel('Time (ns)'); title('photon time histogram')

    sca(ha)
end


hold(ha,'on')
[upid,~,j]=unique(pid);  nupid=numel(upid);  names=cell(nupid,1);  h=zeros(nupid,1);
lim = max3(abs(x(pid~=0,10:15)));  

h(1) = plot3([0 0],[0 0],[-lim 0],'-','Color',[0 1 0],'LineWidth',2,'MarkerSize',1);
names{1} = 'particle gun';


fprintf('        Particle     Tracks       Rows    dE (MeV)   photons\n')
[name, c] = fcnpid2name(upid);
for k=1:nupid
   v1 = find(j==k);
   [utid,~,jj]=unique(tid(v1));  nutid=numel(utid);
   
   v4 = [];
   if upid(k)~=0
       for l=1:nutid
           v3 = v1(jj==l);
           p = [x(v3,10:12); x(v3(end),13:15)];
           h(k+1) = plot3(p(:,1),p(:,2),p(:,3),'.-','Color',c{k},'LineWidth',1,'MarkerSize',15);
           if photonflag;  v4 = [v4; find(v2 & parent==utid(l))];  end
       end
       
       if photonflag && ~isempty(v4)
           y = hist(t1(v4),tvec);
           h2(k) = bar(hhist,tvec,y,1,'facecolor',c{k},'edgecolor',c{k});  set(get(h2(k),'Children'),'FaceAlpha',.5)
       end
   else
       h(k+1) = plot3(0,0,0,'.-','Color',c{k},'LineWidth',1,'MarkerSize',1);
   end
   names{k+1} = sprintf('%.0f %s, (%.3gMeV)',nutid,strrep(name{k},'_','\_'),sum(dE(v1)));
   fprintf('%16s%11.0f%11.0f%11.4f%11.0f\n',name{k},nutid,numel(v1),sum(dE(v1)),numel(v4))
end
fcnview('skew')
hl=legend(h,names);  p0=get(hl,'Position');  set(hl,'Position',[.03 .03 p0(3:4)])
axis([-1 1 -1 1 -1 1]*lim);  xyzlabel('X (mm)','Y (mm)','Z (mm)'); set(gca,'YDir','Reverse','ZDir','Reverse'); grid off; box on; axis vis3d;

if photonflag
    v1 = h2~=0;
    hl=legend(h2(v1),names{v1}); axis(hhist,'tight'); legend(hl,'boxoff'); fcnlegend(hl,.5); fcnfontsize(8,hff)
end

c=[1 1 1]*.9;
text(0,0,-lim*1.1,'TOP','fontsize',20,'color',c)
text(0,lim*1.1,0,'RIGHT','fontsize',20,'color',c)
text(lim*1.1,0,0,'FRONT','fontsize',20,'color',c)

fprintf('\n');
end

function fcnlist(h, event) %#ok<INUSD>
val=get(h,'Value');  x=get(h,'UserData');  v1=val==x;
if any(v1)
    x = x(~v1);
else
    x = [x val];
end
set(h,'Value',x,'UserData',x,'Selected', 'off');
end

function fcnscroll(h, event) %#ok<INUSL>
factor = event.VerticalScrollCount;
x = get(gca,'CurrentPoint');
set(gca,'CameraTargetMode','manual','CameraTarget',mean(x,1))
if factor>0
    amount = 1.4;
else
    amount= 0.6;
end
zoom(amount)
centerPointer
end

function centerPointer
p2 = get(gcf,'Position');
p1 = get(gca,'Position');
ss=get(0,'ScreenSize');
p2 = p2.*ss([3 4 3 4]);
p1 = p1.*p2([3 4 3 4]);
p3 = [p1(1)+p1(3)/2, p1(2)+p1(4)/2] + p2(1:2);
set(0,'PointerLocation',p3);
end