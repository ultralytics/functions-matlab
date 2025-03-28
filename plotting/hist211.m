% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function ha3 = hist211(X,Y,nb,type)
% clc; close all
% X = randn(1E4,1)*.98;
% Y = X + randn(1E4,1)*.4;
% Y(1:5000) = Y(1:5000)+5;
if nargin<3; nb = 64; end
if nargin<4; type = []; end
if nargin==1
    Y=X(:,2);
    X=X(:,1);
end

sigmarejectionflag = 0;

ha = fig(2,2,1.5);  delete(ha(2));
c = [0 0.405 0.666]; %fcndefaultcolors(1);
set(ha(1),'Position',get(ha(1),'Position').*[1 1 1 .35]);
set(ha(4),'Position',get(ha(4),'Position').*[1 1 .35 1]);

i = isfinite(X) & isfinite(Y);  if sigmarejectionflag;  [~,j] = fcnsigmarejection(Y,6,1);  [~,k] = fcnsigmarejection(X,4,3);  i = i & j & k; end
X=X(i);  Y=Y(i);

if iscell(nb)
    vx=nb{1};
    vy=nb{2};  i=X>=vx(1) & X<=vx(end) & Y>=vy(1) & Y<=vy(end);  X=X(i);  Y=Y(i);
else
    vx = linspace(min3(X),max3(X),nb);
    vy = linspace(min3(Y),max3(Y),nb);
end

sca(ha(1));
h=histogram(X,vx);  set(ha(1),'Ytick',[],'Xticklabel',[],'Ycolor','none','Xcolor','none','Ylim',[0 max(h.Values)]);  h.FaceColor=c;  h.EdgeColor=fcnlightencolor(h.FaceColor);
legend(h,sprintf('\\mu = %.2g \\pm %.2g',mean(X),std(X)))

sca(ha(3));
hist2(X,Y,{vx,vy},type,sigmarejectionflag);
h=findobj(gca,'type','line');  if numel(h)>0; h.Color=c; end


sca(ha(4));
[y,x] = histcounts(Y,vy); x=x(1:end-1)/2+x(2:end)/2;
barh(x,y,1,'facecolor',c,'edgecolor',fcnlightencolor(c),'facealpha',.6,'displayname',sprintf('\\mu = %.2g \\pm %.2g',mean(Y),std(Y)));
set(ha(4),'Xtick',[],'Yticklabel',[],'Xcolor','none','Ycolor','none','Xlim',[0 max(y)]);

%histNfit(x,y,'b',true); %COMMENT THIS OUT
legend show


p3=get(ha(3),'Position');
set(ha(1),'Position',get(ha(1),'Position').*[1 0 1 1]+[0 p3(2)+p3(4)+.01 0 0]);
set(ha(4),'Position',get(ha(4),'Position').*[0 1 1 1]+[p3(1)+p3(3)+.01 0 0 0]);

linkaxes(ha([1 3]),'x')
linkaxes(ha([4 3]),'y')
axis(ha(3),'tight')

ha3=ha(3);
sca(ha3);
end