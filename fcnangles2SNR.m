function [SNR, cta]= fcnangles2SNR(a,b,weights)
%A = nx3 vectors
%B = nx3 vectors (optional)

if exist('b','var') && ~isempty(b)
    a = rotateB2Wc(fcnVEC2RPY(b),a); %a expressed in b frame
end
if nargin==3
    i = ~any(isnan([a weights]),2);
    [mu, sigma] = weightedMean(a(i,:),weights(i));
else
    mu=nanmean(a);  sigma=nanstd(a);
end
a = fcnvec2uvec(a);
cta = a(:,1)./1; %ct = a(:,1)./rangec(a);

[fh,cth] = fcnhistc(cta,90);  dct=cth(2)-cth(1);  fh=fh./sum(fh)/dct;
SNRfit = fsolve(@(s) fh-fcnthetapdf(s,cth)*2*pi,1); %SNR fit to ct histogram
SNR = mu(1)/mean(sigma);
fprintf('vector mu=[%.2f %.2f %.2f]mm, sigma=[%.2f %.2f %.2f]mm, SNR=%.2f\n',mu,sigma,SNR)  %[1 0 0] is signal


plotflag=0;
ct = linspace(-1,1,1000);
[sx,sy,sz] = sphere(120);
switch plotflag
    case 1
        %PLOT HISTOGRAM -----------------------------------------------------------
        fig(1,2,'10x20cm');  c=fcndefaultcolors(1);
        bar(cth,fh,1,'edgecolor',c,'facecolor',fcnlightencolor(c),'displayname','data')
        plot(ct,fcnthetapdf(SNRfit,ct)*2*pi,'color',c,'displayname',sprintf('%.2f SNR fit',SNR),'linewidth',3);
        xyzlabel('cos(\Theta)','pdf'); set(gca,'YLim',[0 2.5]); %fcntight('y0')
        
        %PLOT SPHERE --------------------------------------------------------------
        sca; fcnplot3(a,'.');
        color=reshape(fcnthetapdf(SNR,sx)*2*pi,size(sx));
        h=surf(sx,sy,sz,color,'edgecolor','none'); set(h,'facecolor',[1 1 1]*.9);
        fcnplotaxes3(1.25);  fcnplotspherecross(0,0,30,[0 0 0],1.02);
        axis tight equal vis3d off;  set(gca,'YDir','Reverse','ZDir','Reverse');  fcn3label; view(37,30); fcnfontsize(16); fcnmarkersize(3)
    case 2
        S=[.48 .30 .09 .05];
        L={'MTC Li','MTC Boron','Double CHOOZ','TREND'};
        n = numel(S);
        
        ha=fig(n,2,.7,1);
        for i=1:n
            c=fcndefaultcolors(i);
            cmap = parula(256); %fcndefinecolormap({[.85 .85 .85],c});
            str = sprintf(' %s %.2f SNR',L{i},S(i));
            
            sca(ha(1)); a=fcnthetapdf(S(i),ct)*2*pi; plot(ct,a,'color',c,'displayname',str,'linewidth',3);
            xyzlabel('cos(\Theta)','pdf'); text(1,a(end),str);
            
            hi=ha(i*2); sca(hi);
            color=reshape(fcnthetapdf(S(i),sx)*2*pi,size(sx));
            surf(sx,sy,sz,color,'edgecolor','none');
            fcnplotaxes3(1.25);  fcnplotspherecross(0,0,30,[0 0 0],1.02);
            colormap(hi,cmap); hi.CLim(1)=0;
            axis tight equal vis3d off;  set(gca,'YDir','Reverse','ZDir','Reverse');  fcn3label; view(37,30)
        end
        fcntight(ha(1),'y0');  fcntight('c0 joint')
        ha(1).Position([2 4])=[.1 .8]; delete(ha(3:2:end)); fcnfontsize(16)
end