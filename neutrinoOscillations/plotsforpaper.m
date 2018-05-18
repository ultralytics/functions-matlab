
%MeV = linspace(1.8,8,600);
%r1 = linspace(180,200,50)';

fraction = table.mev.fs;
fraction = fraction(1:1200,1:600);

r1 = table.mev.r(1:1200);
MeV = table.mev.e(1:600);
input.dNoiseMultiplier = 3; %1/30, etc;

np = 1E32; %number of protons
ne = numel(MeV);
nr = numel(r1);

%rs = 7.95774715459477e-012*(r1.^-2); %solid angle range scaling
s.r0 = fcnspecreactoremission(MeV).*fcnspecdetection(MeV)*np; % #*cm^2/1E32p/day/GWth
s.r0mat = (ones(nr,1)*s.r0);
[~, sop] = fcnrandosc(1, input, flags);  sop.dNoiseMultiplier=input.dNoiseMultiplier;
u1=sprintf('%.3g',sop.u(1));  u2=sprintf('%.3g',sop.u(2));  u3=sprintf('%.3g',sop.u(3));  u4=sprintf('%.3g',sop.u(4));

%apriori
su1=sprintf('%.3g',sop.su(1));  su2=sprintf('%.3g',sop.su(2));  su3=sprintf('%.2g',sop.su(3));  su4=sprintf('%.2g',sop.su(4));
sl1=sprintf('%.3g',sop.sl(1));  sl2=sprintf('%.3g',sop.sl(2));  sl3=sprintf('%.2g',sop.sl(3));  sl4=sprintf('%.2g',sop.sl(4));

%aposteriori
%su1=sprintf('%.3g',2E-7);  su2=sprintf('%.3g',1.5E-5);  su3=sprintf('%.2g',.0026);  su4=sprintf('%.2g',.0023);
%sl1=sprintf('%.3g',2E-7);  sl2=sprintf('%.3g',3.0E-5);  sl3=sprintf('%.2g',.0026);  sl4=sprintf('%.2g',.0023);

set(figure,'Units','centimeters','Position',[1 1 19 22],'Color','w')
subplot(311); ha = gca;
s.f = fcnspec1f(r1, MeV, sop.u);
pcolor(r1,MeV,(s.r0mat.*s.f)'); shading flat; xlabel('range (km)'); ylabel('E_{\nu_e} (MeV)'); 
h=title({'Conditional Reactor Oscillations','',['\deltam^2_{12}=' u1 'eV^2,  \Deltam^2_{13}=' u2 'eV^2,  sin^2(\theta_{12})=' u3 ',  sin^2(\theta_{13})=' u4]});
%hc=colormap;  set(hc,'Position')
set(gca,'Position',[.06 .715 .935 .23])
set(h,'Position',get(h,'Position').*[1 .95 1]);

sums = fraction.*s.r0mat;
subplot(312)
pcolor(r1,MeV,sums'); shading flat; xlabel('range (km)'); ylabel('E_{\nu_e} (MeV)'); 
h=title({'Marginal Reactor Oscillations','',['\deltam^2_{12}=' u1 '^{+' su1 '}_{-' sl1 '} eV^2,  \Deltam^2_{13}=' u2  '^{+' su2 '}_{-' sl2 '} eV^2' ...
    ',  sin^2(\theta_{12})=' u3 '^{+' su3 '}_{-' sl3 '},  sin^2(\theta_{13})=' u4 '^{+' su4 '}_{-' sl4 '}']})
set(gca,'Position',[.06 .3825 .935 .23])
set(h,'Position',get(h,'Position').*[1 .98 1]);

sums = fcnsmearenergy(input, table, MeV, fraction.*s.r0mat);
subplot(313)
pcolor(r1,MeV,sums'); shading flat; xlabel('range (km)'); ylabel('E_{\nu_e} (MeV)'); 
h=title({'10.03%{E}^{-1/2}  Energy Smeared Marginal Reactor Oscillations','',['\deltam^2_{12}=' u1 '^{+' su1 '}_{-' sl1 '} eV^2,  \Deltam^2_{13}=' u2  '^{+' su2 '}_{-' sl2 '} eV^2' ...
    ',  sin^2(\theta_{12})=' u3 '^{+' su3 '}_{-' sl3 '},  sin^2(\theta_{13})=' u4 '^{+' su4 '}_{-' sl4 '}']})
set(gca,'Position',[.06 .04 .935 .23])
set(h,'Position',get(h,'Position').*[1 .98 1]);

linkaxes(get(gcf,'Children'),'x');







% % %Detection Spectra
% % figure
% % plot(table.mev.es, fcnspecdetection(table.mev.es)); 
% % xlabel('Antineutrino Energy (MeV)'); 
% % ylabel('Detection Cross Section cm^2/1E32p'); 
% % title({'Antineutrino Detection Cross Section','Gd Doped LS Detector'})
% % legend('s_1(e)')
% % 
% % %Reactor Emission Spectra
% % figure 
% % plot(table.mev.es, fcnspecreactoremission(table.mev.es));
% % xlabel('Antineutrino Energy (MeV)'); 
% % ylabel('Fission Reactor Emission Spectra #/day/GWth'); 
% % title('Fission Reactor Antineutrino Emission Spectra');
% % legend('s_0(e)')
% 
% %plotyy
% figure
% x = table.mev.es(input.ecut.v1);
% [AX, H1, H2] = plotyy(x, fcnspecreactoremission(x), x, fcnspecdetection(x)); hold on
% y = fcnspecreactoremission(x).*fcnspecdetection(x);
% H3 = plot(x,y*7E42,'r');
% 
% ylim1 = get(AX(1),'YLim');
% ylim2 = get(AX(2),'YLim');
% set(AX(1),'YLim',[0 ylim1(2)],'XLim',[min(x) max(x)])
% set(AX(2),'YLim',[0 ylim2(2)],'XLim',[min(x) max(x)])
% set(get(AX(1),'Ylabel'),'String','Fission Reactor Emission Spectra #/day/GW_{th}') 
% set(get(AX(2),'Ylabel'),'String','Detection Cross Section cm^2/1E32p^+') 
% xlabel('$$E_{\bar{\nu}_e} (MeV)$$','Interpreter','latex')
% lh = legend([H1 H2 H3],'s_\theta Reactor Emission Spectrum', 's_d Detection Cross Section',['s_\thetas_d Measured Spectrum' sprintf('\n        (Units Not Shown)')]); legend boxoff
% title('$$\bar{\nu}_e$$  Emission and Detection Spectra','Interpreter','latex')
% fcnlinewidth(2)
% grid on
% 
%fraction spectra
r1 = linspace(.01,200,2000)';
E1 = linspace(1.71,6,1000);

np = 1E32; %number of protons
s.r0 = fcnspecreactoremission(E1).*fcnspecdetection(E1)*np; % #*cm^2/1E32p/day/GWth
r0mat = (ones(numel(r1),1)*s.r0);

f1 = fcnspec1f(r1, E1);
fig
Z = (f1.*r0mat)';
pcolor(r1', E1, Z)

shading flat;
ylabel('Antineutrino Energy (MeV)')
xlabel('Range (km)')
title('Electron Antineutrino Survival Fraction vs Range and Energy')
colorbar
% 
% %sigma plot
% 
% % figure
% % s = .4;
% % x2 = 1;
% % y2 = .01;
% % z2 = .01;
% % plot3([0 x2],[0 y2],[0 z2],'b','linewidth',3); hold on
% % plot3([-1 1]*s + x2, [-1 1]*0 + y2, [-1 1]*0 + z2,'r','linewidth',4);
% % plot3([-1 1]*0 + x2, [-1 1]*s + y2, [-1 1]*0 + z2,'r','linewidth',4);
% % plot3([-1 1]*0 + x2, [-1 1]*0 + y2, [-1 1]*s + z2,'r','linewidth',4);
% % 
% % axis equal vis3d
% % axis([-1 1 -1 1 -1 1]*norm([x2 y2 z2]+s))
% % box on
% % xlabel('x (mm)');
% % ylabel('y (mm)');
% % zlabel('z (mm)');