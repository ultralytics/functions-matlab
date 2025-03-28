% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [] = fcnribbon(xh,yh)
%xh=[1 30] histogram bin x values
%yh=[24 30], 24 pmts for 30 histogram bins

m=size(yh,1);
hb=ribbon(xh',yh',.5); for i=1:m; c=fcndefaultcolors(i,m);  set(hb(i),'facecolor',c,'edgecolor',fcnlightencolor(c,0),'displayname',sprintf('%g',i)); end
set(gca,'xtick',1:m,'xdir','reverse','cameraviewangle',9); grid off; axis tight; %legend(hb)
fcnfontsize(gca,8);  fcnview('skew')
set(gca,'ZColor',[1 1 1],'ZTick',[]); 
end

