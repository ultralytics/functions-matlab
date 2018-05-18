function []=scopedata()
clc; close all;

G = fcnloadtextfile('',2000);  ng = numel(G);

ha=fig(2,3,1.5);
x=1:1032;
ov = ones(size(x));

normalizebefore = false;
normalizeafter = false;

ac = 2:4; %active channels
for gi = 1:ng
    A = G(gi);
    a = reshape(A.x',[1032 4 A.rows]);
    j = false([A.rows 4]);
    
    for i=ac;
        sca(ha(1))
        b=squeeze(a(:,i,:))';
        pedestals = mean3(b(:)); b=b-pedestals;
        
        st = 20; %noise threshold
        
        j(:,i)=any(b>st,2) & all(b<500,2) & ~any(b(:,400:end)>st*2,2); %signals
        k=all(b<st*.9,2); %empty

        if sum(k)>0
            pedestalv = mean(b(k,:),1);
        else
            pedestalv = 0;
        end
        b = bsxfun(@minus,b,pedestalv);
        a(:,i,:) = bsxfun(@minus,a(:,i,:),pedestalv'+pedestals);
        
        if normalizebefore
            if i==2;  k = max(b,[],2);  end
            b = bsxfun(@times,b,1./k); 
        end
        
        b=b(j(:,i),:);
        
        mu = mean(b,1);
        if normalizeafter
            if i==2;  l = max(mu);  end %#ok<*UNRCH>
            mu = mu./l; 
        end
        
        c = fcndefaultcolors(gi,ng);         
        dn = sprintf('''%s'' channel %g (%.2f eff)',str_(A.filename),i,mean(j(:,i)));
        h=plot3(x,i*ov,mu,'.-','linewidth',2);
        %h=plot(x,mu,'.-','linewidth',2);
        if i==3; c=fcnlightencolor(c,.4); end
        if i==4; c=fcnlightencolor(c,-.3); end
        set(h,'color',c,'displayname',dn);

         if i==3 %center strip!
             sca(ha(6)); fcnhist(max(b(:,300:400)'),30,c,'line',dn); %#ok<UDIM> %amplitude distribution
         end
        
        sca(ha(2))
        nb = min(size(b,1),300);
        plot3(repmat(x',[1 nb]),repmat(i*ov',[1 nb]),b(1:nb,:)','color',c,'linewidth',.5); %first 30
    end
    
    
    acc = all(j(:,ac),2); %active channel candidates
    if sum(acc)>1 %more than one candidate
        sca(ha(3))
        b = squeeze(max(a(:,ac,acc),[],1));
        centroids = ac*b./sum(b);
        fcnhist(centroids,30,c,'bar',str_(A.filename)); alpha(.7)
        
        
        sca(ha(4))
        r = 350:450; nr = numel(r); %rows
        c = a(r,ac,acc);
        centroids = squeeze(sum(bsxfun(@times,repmat(ac,[nr 1]),c),2)./sum(c,2));
        t = repmat(r',[1 size(centroids,2)]);
        hist3([t(:) centroids(:)],{r,linspace(min(ac)-1,max(ac)+1,60)}); 
        axis tight; view(-40,80); box on
        set(gcf,'renderer','opengl'); 
        set(findobj(gca,'Tag','hist3'),'FaceColor','interp','CDataMode','auto','edgecolor','none');
        
        
        sca(ha(5)) %fit norm to charge cloud
        c = fcndefaultcolors(gi,ng); 
        mb=mean(b,2);
        hb=bar(ac,mb,.6); alpha(.7); set(hb,'facecolor',c,'edgecolor',fcnlightencolor(c),'DisplayName',str_(A.pf1));
        f=fit(ac(:),mb(:),'gauss1');  s = f.c1/sqrt(2);
        x2 = linspace(min(ac)-1,max(ac)+1,1000);
        plot(x2,f(x2),'-','linewidth',2,'color',c,'displayname',sprintf('%s fit sigma=%.2f',str_(A.pf1),s));
    end

end
fcnview(ha(1:2),[35 19]); %fcnview(ha(1:2),[0 0])
%linkprop(ha(1:2),{'CameraPosition','CameraUpVector'});

%fcntight(ha(1:2),'jointxyz')
set(ha(1:2),'xlim',[300 500]);
set(ha(3),'xlim',[1 4]);
xyzlabel(ha(1:2),'t (bin)','')
xyzlabel(ha(3:4),'channel','','','center of charge')
xyzlabel(ha(5),'LAPPD strip','','',str_(A.p2))
xyzlabel(ha(6),'Amplitude (bins)','','','Amplitude Distribution')

legend(ha(1),'show','location','northeast')
fcnlinewidth(findobj(gcf,'Tag','legend'),6)

function [fitresult, gof] = createFit(x, mu)
w = zeros(size(x));
w(335:375)=1;

% Fit: 'untitled fit 1'.
[xData, yData, weights] = prepareCurveData( x, mu, w );

% Set up fittype and options.
ft = fittype( 'gauss1' );
opts = fitoptions( ft );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0];
opts.StartPoint = [0.94232657618525 355 71.5733834376942];
opts.Upper = [Inf Inf Inf];
opts.Weights = weights;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
% 
% % Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, xData, yData );
% legend( h, 'mu vs. x with w', 'untitled fit 1', 'Location', 'NorthEast' );
% % Label axes
% xlabel( 'x' );
% ylabel( 'mu' );
% grid on

fig
h2 = plot(x, b(:,:) ,'-','color',[1 1 1]*.8);
h3 = plot(x, mu/max3(mu) ,'r-','linewidth',2);
h1 = plot(x, fitresult(x)./max3(fitresult(x)),'b-','linewidth',3);
legend([h1 h2(1) h3(1)],{'Normal Fit','Photons','Mean Photons'})
xyzlabel('t (bins)','V (normalized)','','LAPPD Scope /Users/glennjocher/Desktop/LAPPD Data/JUNE 24/160k.txt');
set(gca,'xlim',[300 400],'ylim',[-.3 1]);set(gcf,'units','centimeters','Position',[1 1 24 16]); grid on
