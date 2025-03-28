% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function []=plotNN(net)
clc; close all

nt = net.numLayers;  nn=zeros(nt,1);
nn(1)=net.input.size; %neurons per layer
for i=1:nt
    nn(i+1) = net.layers{i}.size;
end

ha=fig; L=[];  ha.Position([2 4])=[.05 .75];
for i=1:nt+1
    m=round((nn(i)));
    L(i+1).x=zeros(m,1)+i;
    L(i+1).y=(1:m)'-m/2;
    plot(L(i+1).x,L(i+1).y,'.')
    
    a=L(i).x;  b=L(i+1).x';  na=numel(a); nb=numel(b); xa=repmat(a,[1 nb]);  xb=repmat(b,[na 1]);
    a=L(i).y;  b=L(i+1).y';                            ya=repmat(a,[1 nb]);  yb=repmat(b,[na 1]);
    x=[xa(:) xb(:)]; x(:,3)=nan; x=x';
    y=[ya(:) yb(:)]; y(:,3)=nan; y=y';
   % plot(x(:),y(:),'-');

    
   if i>1
      w=max(max3(nn)*.0001,.03); %width = 0.1
       x=[xa(:) xb(:) xb(:) xa(:)]; % x(:,end+1)=nan;
       y=[ya(:)-w yb(:)-w yb(:)+w ya(:)+w]; % y(:,end+1)=nan;
       z=y*0;
       
       patch(x', y', z', 'k', ...
           'EdgeColor','none', ...
           'FaceColor','k', ...
           'FaceAlpha','Flat', ...
           'FaceVertexCData',1, ...
           'AlphaDataMapping','none', ...
           'FaceVertexAlphaData',.1);
   end
   
   if nn(i)>1; s='s'; else s=''; end
   switch i
       case 1
           text(i,m/2,sprintf('  %g Input%s',nn(i),s),'Rotation',90,'Fontsize',16)
       case nt+1
           text(i,m/2,sprintf('  %g Output%s',nn(i),s),'Rotation',90,'Fontsize',16)
       otherwise
           text(i,m/2,sprintf('  %g',nn(i)),'Rotation',90,'Fontsize',16)
   end
   
end
fcnmarkersize(30); axis off tight

