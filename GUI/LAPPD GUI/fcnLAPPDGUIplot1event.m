% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function fcnLAPPDGUIplot1event(varargin)
if nargin==0 || isgraphics(varargin{1}) 
    G = evalin('base','G');
    ei = get(findobj(gcf,'Type','uicontrol','-and','Tag','eventselector'),'value');
else
    G = varargin{1};
    ei = varargin{2};
end

cl = cell(1,30); for i=1:30; cl{i} = sprintf(' %g ',i); end; %channel labels
V = G.xe(:,1:end,ei);

tbins = repmat((0:255)',[1 30]); 
channels = repmat(1:30,[256 1]);

cla
c = fcndefaultcolors(1:6,6);


colorbychannel = false;
if ~colorbychannel
    h=plot3(tbins,channels,V,'b-','linewidth',2); for i=1:5; set(h((1:6)+(i-1)*6),'color',c(i,:),'displayname',sprintf('PSEC %g',i)); end
    legend(h(1:6:30));
else
    h=plot3(tbins,channels,V,'b-','linewidth',2); for i=1:6; set(h(i:6:30),'color',c(i,:),'displayname',sprintf('channel %g',i)); end
    legend(h(1:6));
end
text(tbins(1,:)-5,1:30,double(V(1,:)),cl,'fontsize',10)
axis tight; grid off; box off;
xyzlabel('t (bin)','strip','V (bin)',str_(sprintf('Event %g of %g from ''%s''',ei,G.ne,G.pf1)));
