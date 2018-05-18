flags.status.aprioribackground = 0;

r1 = table.mev.r;
r1 = linspace(1,300,1000)';
%MeV = table.mev.e;
MeV = 0.01:.01:11;

input.dNoiseMultiplier = 1; %1/30, etc;
%fname = sprintf('aposteriori osc fraction SNIFx%.0f',1/input.dNoiseMultiplier);
fname = sprintf('apriori osc fraction 2014 100k');

np = 1E32; %number of protons
ne = numel(MeV);
nr = numel(r1);

%rs = 7.95774715459477e-012*(r1.^-2); %solid angle range scaling
s.r0 = fcnspecreactoremission(MeV).*fcnspecdetection(MeV)*np; % #*cm^2/1E32p/day/GWth
s.r0mat = (ones(nr,1)*s.r0);
[~, sop] = fcnrandosc(1, input, flags);  sop.dNoiseMultiplier=input.dNoiseMultiplier;
u1=sprintf('%.3g',sop.u(1));  u2=sprintf('%.3g',sop.u(2));  u3=sprintf('%.3g',sop.u(3));  u4=sprintf('%.3g',sop.u(4));
su1=sprintf('%.3g',sop.su(1));  su2=sprintf('%.3g',sop.su(2));  su3=sprintf('%.2g',sop.su(3));  su4=sprintf('%.2g',sop.su(4));
sl1=sprintf('%.3g',sop.sl(1));  sl2=sprintf('%.3g',sop.sl(2));  sl3=sprintf('%.2g',sop.sl(3));  sl4=sprintf('%.2g',sop.sl(4));

ha = fig(3,1,2,1);
sca(ha(1))
s.f = fcnspec1f(r1, MeV, sop.u);
pcolor(r1,MeV,(s.r0mat.*s.f)'); shading flat; xlabel('range (km)'); ylabel('E_{\nu} (MeV)'); 
title({'Conditional Reactor Oscillations Plot','',['\deltam^2_{12}=' u1 'eV^2,  \Deltam^2_{13}=' u2 'eV^2,  sin^2(\theta_{12})=' u3 ',  sin^2(\theta_{13})=' u4]})

tic
n=100;
fraction = zeros(size(s.r0mat));
op = fcnrandosc(n, input, flags);
%matlabpool 4
for i=1:n
    fprintf('%.0f/%.0f\n',i,n)
    f1 = fcnspec1f(r1, MeV, op(i,:));
    fraction = fraction + f1;
end
fraction=fraction./n;
toc
save('-v6',fname,'fraction','r1','MeV','sop')

sums = fraction.*s.r0mat;
sca(ha(2))
pcolor(r1,MeV,sums'); shading flat; xlabel('range (km)'); ylabel('E_{\nu} (MeV)'); 
title({'4D Marginal Reactor Oscillations Plot','',['\deltam^2_{12}=' u1 '^{+' su1 '}_{-' sl1 '}eV^2,  \Deltam^2_{13}=' u2  '^{+' su2 '}_{-' sl2 '}eV^2' ...
    ',  sin^2(\theta_{12})=' u3 '^{+' su3 '}_{-' sl3 '},  sin^2(\theta_{13})=' u4 '^{+' su4 '}_{-' sl4 '}']})

sums = fcnsmearenergy(input, table, MeV, fraction.*s.r0mat);
sca(ha(3))
pcolor(r1,MeV,sums'); shading flat; xlabel('range (km)'); ylabel('E_{\nu} (MeV)'); 
title({'Energy Smeared 4D Marginal Reactor Oscillations Plot','',['\deltam^2_{12}=' u1 '^{+' su1 '}_{-' sl1 '}eV^2,  \Deltam^2_{13}=' u2  '^{+' su2 '}_{-' sl2 '}eV^2' ...
    ',  sin^2(\theta_{12})=' u3 '^{+' su3 '}_{-' sl3 '},  sin^2(\theta_{13})=' u4 '^{+' su4 '}_{-' sl4 '}']})

linkaxes(ha,'x');
fcntight



% %PLOT FOR PAPER
% flags.status.aprioribackground = 0;
% MeV = linspace(1.8,7.8,1200); ei=fcnindex1c(table.mev.e,MeV);
% %MeV = 1.8:.01:7.8; ei=fcnindex1c(table.mev.e,MeV);
% r1 = linspace(1,850,2000)';  ri=fcnindex1c(table.mev.r,r1);
% 
% np = 1E32; %number of protons
% ne = numel(MeV);
% nr = numel(r1);
% 
% %rs = 7.95774715459477e-012*(r1.^-2); %solid angle range scaling
% s.r0 = fcnspecreactoremission(MeV).*fcnspecdetection(MeV)*np; % #/day/GWth*cm^2/1E32p^+
% s.r0mat = (ones(nr,1)*s.r0);
% [~, sop] = fcnrandosc(1, input, flags);  sop.dNoiseMultiplier=input.dNoiseMultiplier;
% u1=sprintf('%.3g',sop.u(1));  u2=sprintf('%.3g',sop.u(2));  u3=sprintf('%.3g',sop.u(3));  u4=sprintf('%.3g',sop.u(4));
% su1=sprintf('%.3g',sop.su(1));  su2=sprintf('%.3g',sop.su(2));  su3=sprintf('%.2g',sop.su(3));  su4=sprintf('%.2g',sop.su(4));
% sl1=sprintf('%.3g',sop.sl(1));  sl2=sprintf('%.3g',sop.sl(2));  sl3=sprintf('%.2g',sop.sl(3));  sl4=sprintf('%.2g',sop.sl(4));
% 
% h=fig(3,1);
% axes(h(1))
% s.f = fcnspec1f(r1, MeV, sop.u);
% pcolor(r1,MeV,(s.r0mat.*s.f)' * 7.95774715459477e-012); shading flat; xlabel('range (km)'); ylabel('E_{\nu_e} (MeV)'); 
% title({'{\bf\it A priori} {\bfConditional} Electron Antineutrino Measurements','',['conditional on: \Deltam^2_{12}=' u1 'eV^2,  \Deltam^2_{13}=' u2 'eV^2,  sin^2(\theta_{12})=' u3 ',  sin^2(\theta_{13})=' u4]})
% colorbar; % #*cm^2/1E32p/day/GWth*r(km)^2
% text(962,1.8,'#/MeV/1E32p^+/day/GW_{th}*range(km)^2','Rotation',90,'fontsize',8)
% 
% sums = fraction(ri,ei).*s.r0mat * 7.95774715459477e-012;
% axes(h(2))
% pcolor(r1,MeV,sums'); shading flat; xlabel('range (km)'); ylabel('E_{\nu_e} (MeV)'); 
% title({'{\bf\it A posteriori} {\bfMarginal} Electron Antineutrino Measurements','',['marginal over: \Deltam^2_{12}=' u1 '^{+' su1 '}_{-' sl1 '}eV^2,  \Deltam^2_{13}=' u2  '^{+' su2 '}_{-' sl2 '}eV^2' ...
%     ',  sin^2(\theta_{12})=' u3 '^{+' su3 '}_{-' sl3 '},  sin^2(\theta_{13})=' u4 '^{+' su4 '}_{-' sl4 '}']})
% colorbar; % #*cm^2/1E32p/day/GWth*r(km)^2
% text(962,1.8,'#/MeV/1E32p^+/day/GW_{th}*range(km)^2','Rotation',90,'fontsize',8)
% 
% sums = fcnsmearenergy(input, table, MeV, fraction(ri,ei).*s.r0mat * 7.95774715459477e-012);
% axes(h(3))
% pcolor(r1,MeV,sums'); shading flat; xlabel('range (km)'); ylabel('E_{\nu_e} (MeV)'); 
% title({'{\bf\it A posteriori} {\bfMarginal} Electron Antineutrino Measurements {\bf(8.9% Energy Resolution @1MeV)}','',['marginal over: \Deltam^2_{12}=' u1 '^{+' su1 '}_{-' sl1 '}eV^2,  \Deltam^2_{13}=' u2  '^{+' su2 '}_{-' sl2 '}eV^2' ...
%     ',  sin^2(\theta_{12})=' u3 '^{+' su3 '}_{-' sl3 '},  sin^2(\theta_{13})=' u4 '^{+' su4 '}_{-' sl4 '}']})
% colorbar; % #*cm^2/1E32p/day/GWth*r(km)^2
% text(962,1.8,'#/MeV/1E32p^+/day/GW_{th}*range(km)^2','Rotation',90,'fontsize',8)
% 
% linkaxes(get(gcf,'Children'),'x');








