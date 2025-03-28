% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function []= fcnsterileneutrinosim(input)
close all
n = 1; %number of source points
%x0 = fcnsurvivalsurface(n); %(m) nu origins
%fcnintegratedetector(input,n);
%fcnsensetivitycurves(input,n)

LEsurfaces()
end

function LEsurfaces()
MeV = 1.8:.01:10;
E = MeV/1000;
L = linspace(0,.10,600)'; a=1; b=1;

%DEFAULT VALUES -----------------------------------------------------
a = 1; b = 1; %Pab
s22t(1,4) = 0.10;        dms(4,1) = 1.75; %red line    %14 %http://arxiv.org/abs/1303.3011v1
%s22t(1,4) = 0.057;      dms(4,1) = 0.9; %green line
%s22t(1,4) = 0.13;       dms(4,1) = 0.44; %blue line

s.f = fcnnuosc(E,L,4,dms,[],[],s22t,a,b);  %varargin = [E,L,n,dms,t,s2t,s22t,a,b]
np = 6.2145E28; %per m^3
day = 1; %365.25;
rp = 0.8; %GWth
s.r0 = fcnspecreactoremission(MeV).*fcnspecdetection(MeV)*(rp*np); % # cm^2/day, zero range spectrum, %NO CANDIDATE FRACTION!!!
%rs  = 7.95774715459477e-012*(L(:).^-2); %1/(4*pi*(r1*cmPerkm)^2); %solid angle range scaling
%s.s = (rs*s.r0).*s.f; %GET SCALED SPECTRUM VECTOR FOR TODAY ONLY
s.s = bsxfun(@times,s.r0/max(s.r0),s.f);
dMeV = MeV(2)-MeV(1);
s.n = sum(s.s,2) * (dMeV*day); %event count

Eres = .30;
Pab = s.s; 
Pabs = fcnsmearenergy(Pab,MeV,Eres./sqrt(MeV),2);

ha=fig(1,2,1.5);
sca; pcolor(L,E*1E3,Pab');  shading flat; xyzlabel('L (km)','E (MeV)','',sprintf('P_%g_%g \\Deltam^2_{41}=%g s^2(2\\Theta_{14})=%g',a,b,dms(4,1),s22t(1,4))); colorbar; axis tight; 
sca; pcolor(L,E*1E3,Pabs'); shading flat; xyzlabel('L (km)','E (MeV)','',sprintf('P_%g_%g \\Deltam^2_{41}=%g s^2(2\\Theta_{14})=%g, %gE^{-.5} resolution',a,b,dms(4,1),s22t(1,4),Eres)); colorbar; axis tight;
set(ha,'clim',[0 1])
end


function fcnsensetivitycurves(input,n)
cc=fcnspheresource(n);  cc(:,1) = cc(:,1) + 5000;

X=0; Y=0; Z=0; 
L = sqrt(bsxfun(@minus,X(:),cc(:,1)').^2 + bsxfun(@minus,Y(:),cc(:,2)').^2 + bsxfun(@minus,Z(:),cc(:,3)').^2);
L=L(:)/1E6; %mm to km

np = 6.2145E28/numel(X); %per m^3

day = 1; %365.25;
rp = 0.8/n; %GWth
ne = 120; E = linspace(1.8,8,ne);  de = E(2)-E(1); %E (MeV)

zm = zeros(6);  dms=zm;  t=zm;  s2t=zm;  s22t=zm;
na=80;   a = 10.^linspace(-1,1.1,na); %dms (eV^2)
nb=100;  b = 10.^linspace(-2,0,nb); %s22t
op.n = 4;  op.dms = dms;  op.s22t = s22t;
s4 = zeros(na,nb,ne);
for i=1:na
    for j=1:nb
        op.dms(4,1) = a(i);
        op.s22t(1,4) = b(j);

        s = fcnspec1s(E, L, op, rp, np, day);
        s4(i,j,:) = s.s;
    end
end
n4 = sum(s4,3)*de;
s4s = fcnsmearenergy(s4,E,.15./sqrt(E),3);


op.n = 3;  op.dms = zm;  op.s22t = zm;
s = fcnspec1s(E, L, op, rp, np, day);
s3 = s.s;
n3 = sum(s3)*de;

[a,b,n4] = upscalesurface(a,b,n4,4);

ha=fig(1,3,1.5); 
c = [1 1 1];
spacing = 350;
%sca(ha(1)); set(gca,'xscale','log','yscale','log')

day = 7;
bk = n3*10;
bks = 1; %background sigma fraction
bkvar = bk*bks^2; %background variance
N3 = (n3+bk)*day;
N4 = (n4+bk)*day; 
p3 = normpdf(N4,N3,sqrt(N3 + bkvar*day));
p4 = normpdf(N4,N4,sqrt(N4 + bkvar*day));
probability = p4./(p4+p3);
% pcolor(b,a,probability); shading flat; colorbar; axis tight
% xyzlabel('sin^2(2\theta_{14})','\Deltam^2_{41} (eV^2)'); title('4 flavor probability (vs 3 flavor)')
% [C,h] = contour(b,a,probability,[.68 .95 .995],'color',c,'linewidth',3); clabel(C,h,'LabelSpacing',spacing,'color',c,'rotation',0,'FontSize',12);


sca
k = fcnconfidence2sigma(probability,2);
pcolor(b,a,k); shading flat; colorbar; axis tight
xyzlabel('sin^2(2\theta_{14})','\Deltam^2_{41} (eV^2)'); title('4 flavor confidence (1m^3, 800MWt, 5m, 1 day, 1/10SBR)')
[C,h] = contour(b,a,k,[1 2 3 4 5],'color',c,'linewidth',3); 
h=clabel(C,h,'LabelSpacing',spacing,'color',c,'rotation',0,'FontSize',15); 
for i=1:numel(h); set(h(i),'String',sprintf('%s \\sigma',get(h(i),'string'))); end
x = [1.75 .1; .9 .057; .44 .13];  plot(x(:,2),x(:,1),'w+'); text(x(:,2),x(:,1),{sprintf('%g\\Deltam^2\n%gs^2',x(1,:)),sprintf('%g\\Deltam^2\n%gs^2',x(2,:)),sprintf('%g\\Deltam^2\n%gs^2',x(3,:))},'color','w')


sca
pcolor(b,a,n4./n3); shading flat; colorbar; axis tight
[C,h] = contour(b,a,n4./n3,[.8 .9 .99],'color',c,'linewidth',3); clabel(C,h,'LabelSpacing',spacing,'color',c,'rotation',0,'FontSize',15);
xyzlabel('sin^2(2\theta_{14})','\Deltam^2_{41} (eV^2)'); title('3 flavor survival at 5m')
x = [1.75 .1; .9 .057; .44 .13];  plot(x(:,2),x(:,1),'w+'); text(x(:,2),x(:,1),{sprintf('%g\\Deltam^2\n%gs^2',x(1,:)),sprintf('%g\\Deltam^2\n%gs^2',x(2,:)),sprintf('%g\\Deltam^2\n%gs^2',x(3,:))},'color','w')


sca
load Craaga_100x100.mat
b = s22th14;
a = dm2s;
[a,b,chi2s] = upscalesurface(a,b,chi2s,8);
pcolor(b,a,chi2s); shading flat; 
[C,h] = contour(b,a,chi2s,20:3:30 ,'color',c,'linewidth',1); %clabel(C,h,'LabelSpacing',spacing,'color',c,'rotation',0,'FontSize',15);
xyzlabel('sin^2(2\theta_{14})','\Deltam^2_{41} (eV^2)'); title('RAA')
x = [1.75 .1; .9 .057; .44 .13];  plot(x(:,2),x(:,1),'w+'); %text(x(:,2),x(:,1),{sprintf('%g\\Deltam^2\n%gs^2',x(1,:)),sprintf('%g\\Deltam^2\n%gs^2',x(2,:)),sprintf('%g\\Deltam^2\n%gs^2',x(3,:))},'color','w')
set(gca,'clim',[20 30]); axis tight; colorbar

set(ha,'xscale','log','yscale','log')

fcnfontsize(12)
end

function [xn,yn,zn] = upscalesurface(x,y,z,n)
%x=1x80; y=1x100; z=80x100;
x=x(:)'; y=y(:)';
xn = interp(x,n);
yn = interp(y,n);
zn = interp2(x,y',z',xn,yn','spline')';
end


function fcnintegratedetector(input,n)
cc=fcnspheresource(n);  cc(:,1) = cc(:,1) + 5000;

mmx = minmax3(input.cube.all.x);
mmy = minmax3(input.cube.all.y);
mmz = minmax3(input.cube.all.z);
m = 3;
[X,Y,Z]=ndgrid(linspace(mmx(1),mmx(2),m), linspace(mmy(1),mmy(2),m), linspace(mmz(1),mmz(2),m));  


r = sqrt(bsxfun(@minus,X(:),cc(:,1)').^2 + bsxfun(@minus,Y(:),cc(:,2)').^2 + bsxfun(@minus,Z(:),cc(:,3)').^2);
r=r(:)/1E6; %mm to km

np = 6.2145E28/numel(X); %per m^3

day =365.25;
rp = 0.8/n; %GWth
MeV = 1.8:.1:8;
s = fcnspec1s(MeV, r, [], rp, np, day);

sum(s.n)

popoutsubplot(evalin('base','handles.GUI.axes1'),fig)
fcnplot3(cc,'r.'); fcnplot3([X(:) Y(:) Z(:)],'b.'); axis tight
end


function cc = fcnsurvivalsurface(n)
distance = 5; %distance from detector center to core center (m)
%cc=fcnrodsource(n);
cc=fcnspheresource(n);
cc(:,1) = cc(:,1) + distance*1E3;

plotflag = true;
if plotflag
    popoutsubplot(evalin('base','handles.GUI.axes1'),fig)
    h=fcnplot3(cc,'.'); axis equal vis3d; axis tight; set(h,'color','g','markersize',7);
    set(gca,'XTickMode','auto','XTickLabelMode','auto','YTickMode','auto','YTickLabelMode','auto','ZTickMode','auto','ZTickLabelMode','auto')
end

a = 2000; %mm edge
[mmx,mmy,mmz] = fcnaxesdatalims(gca);
[X,Y,Z]=ndgrid(linspace(mmx(1)-a-5000,mmx(2)+a,320), linspace(mmy(1)-a,mmy(2)+a,80), 0);  s=size(X);


L = sqrt(bsxfun(@minus,X(:),cc(:,1)').^2 + bsxfun(@minus,Y(:),cc(:,2)').^2 + bsxfun(@minus,Z(:),cc(:,3)').^2); 

Lx = linspace(0,max3(L)*1E-6,1000); %km
E = (1.6:.1:7)/1000; nE=numel(E); %Gev
y = fcnnuosc(E',Lx,4);
sL = size(L);
i = fcnindex1c(Lx,L(:)*1E-6);


sumE = false;
s22t(1,4) = 0.10;       dms(4,1) = 1.75; %red line
if sumE
    title(sprintf('all \\nu_e   \\Deltam^2_{41}=%3g, sin^2(2\\Theta_{14})=%3g',dms(4,1),s22t(1,4)))
    dcs = fcnspecreactoremission(E*1000).*fcnspecdetection(E*1000); dcs = dcs./max(dcs); 
    y=bsxfun(@times,y,dcs');
    P = reshape(y(:,i),[nE sL]);
    P = squeeze(sum(P)); %add up all point sources
    P = reshape(sum(P,2)/nE,s);
else
    MeV = 4; %4MeV
    title(sprintf('%gMeV \\nu_e   \\Deltam^2_{41}=%3g, sin^2(2\\Theta_{14})=%3g',MeV,dms(4,1),s22t(1,4)))
    P = y(fcnindex1c(E,MeV/1000),i);
    P = reshape(P,[1 sL]);
    P = sum(P,3); %add up all point sources
    P = reshape(P,s);
end
P=P/n;
P=P/max3(P);

surf(X,Y,Z,P,'edgecolor','none'); alpha(.8)
axis tight; set(gca,'clim',[.9 1]); %set(gca,'clim',fcnminmax(P));
end



function s = fcnspec1s(MeV, L, op, rp, np, day, r0, f1) %specscaled
%s = fcnspec1s(Evector (MeV),range (km), reactor power (GW), detector mass (kg))
%s.r0 = [1x921 double] unscaled zero range spectrum vector
%s.f  = [1x921 double] fraction vector
%s.s  = [1x921 double] san onofre scaled spectrum vector
%s.n  = [1x1 double] integrated event count for day
%r1 = max(r1,0.9); %(km) 900m FLOOR!!
%np = 1.2429e+026 for MTC @2L, 9.9432e+033 for TREND @160M liters. 6.2145e+25 per liter
%cmPerkm  = 100000;
E = MeV(:)'/1000; %Gev

s.r0 = fcnspecreactoremission(MeV).*fcnspecdetection(MeV)*(rp*np); % # cm^2/day, zero range spectrum, %NO CANDIDATE FRACTION!!!
rs  = 7.95774715459477e-012*(L(:).^-2); %1/(4*pi*(r1*cmPerkm)^2); %solid angle range scaling

if numel(L)==1
    s.f = fcnnuosc(E,L,op.n,op.dms,[],[],op.s22t);
else
    Lx = linspace(min3(L),max3(L),1000); %km
    y = fcnnuosc(E',Lx,op.n)';
    s.f = y(fcnindex1c(Lx,L(:)),:);
end

s.s = (rs*s.r0).*s.f; %GET SCALED SPECTRUM VECTOR FOR TODAY ONLY

s.n = 0;
if numel(MeV)>1
    dMeV = MeV(2)-MeV(1);
    s.n = sum(s.s,2) * (dMeV*day); %event count
end

end

function cc=fcnrodsource(distance)
r = .02; %rod radius (m)
h = .5; %rod height (m)

nx = 4;  vx = linspace(-1,1,nx)'*.3; %x rods
ny = 4;  vy = linspace(-1,1,ny)'*.3; %y rods

z = (rand(n,1)-.5)*h;
az = (rand(n,1)-.5)*2*pi;
radius = r*sqrt(rand(n,1));
cc = fcnSC2CC([radius zeros(n,1) az]);  cc(:,3)=z;

cc(:,1) = cc(:,1) + vx(randi(nx,[n 1]));
cc(:,2) = cc(:,2) + vy(randi(ny,[n 1]));
cc = cc*1000;
end

function cc=fcnspheresource(n)
radius = .3; %(m)
if n==1; radius = 0; end
v = isovecs(n);
r = rand(n,1).^(1/3)*radius;
cc = bsxfun(@times,v,r);
cc = cc*1000;
end

function Y = fcnsmearenergy(X,E,Esigma,dim)
if nargin==3; dim = 1; end
sx = size(X);  
ne = sx(dim);  de = E(2)-E(1);
if numel(sx)>2; X=reshape(X,[prod(sx(1:end-1)) sx(end)]); end

Y = zeros(size(X));
for i=1:ne
    P = normpdf(E,E(i),Esigma(i));
    %nk = trapz(P)*de; %normalizing constant
    Y(:,i) = X*P';
end
Y = reshape(Y*de,sx);
end