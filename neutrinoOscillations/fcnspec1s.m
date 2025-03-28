% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function s = fcnspec1s(MeV, r1, op, rp, np, day, r0, f1) %specscaled
%s = fcnspec1s(Evector (MeV),range (km), oscillation parameters (optional), reactor power (GW), detector protons, observation time (days), optional, optional)
%s.r0 = [1x921 double] unscaled zero range spectrum vector
%s.f  = [1x921 double] fraction vector
%s.s  = [1x921 double] san onofre scaled spectrum vector
%s.n  = [1x1 double] integrated event count for ?day?
%s.flux  = [1x921 double] flux vector (#/cm^2/s)
%r1 = max(r1,0.9); %900m FLOOR!!
%np = 1.2429e+026 for MTC @2.4L, 9.9432e+033 for TREND @160M liters.
%cmPerkm  = 100000;
%FOR MTC: s=fcnspec1s(linspace(1.7,11,1000), .0039, [], .02, 1.2429E26, 1);

s.r0flux = fcnspecreactoremission(MeV)*rp;  %nuebar flux (#/day/GWth)
if exist('r0','var') && ~isempty(r0)
    s.r0 = r0;
else
    s.r0 = fcnspecreactoremission(MeV).*fcnspecdetection(MeV)*(rp*np); % # cm^2/day, zero range spectrum, %NO CANDIDATE FRACTION!!!
end
solidangle  = 7.95774715459477e-012*(r1(:).^-2); %1/(4*pi*(r1*cmPerkm)^2); %solid angle range scaling

if exist('f1','var') && ~isempty(f1)
    s.f = f1;
else
    %s.f = fcnspec1f(r1(:), MeV, op);
    
    a=1;
    b=1;
    dms=[];
    s2t=[];
    if exist('op','var') && ~isempty(op)
        dms(1,2)=op(1);  dms(1,3)=op(2);  s2t(1,2)=op(3);  s2t(1,3)=op(4);
    end
    %varargin = [E(GeV),L(km),nflavors,dms,t,s2t,s22t,a,b]
    Pab = fcnnuosc(MeV/1000,r1(:),3,dms,[],s2t,[],a,b);
    
    s.f = Pab;
end

s.s = (solidangle*s.r0).*s.f; %GET SCALED SPECTRUM VECTOR FOR TODAY ONLY
s.sflux = (solidangle*s.r0flux);

s.n = 0;
if numel(MeV)>1
    dMeV = MeV(2)-MeV(1);
    s.n = sum(s.s,2) * (dMeV*day); %event count
    s.nflux = sum(s.sflux,2) * (dMeV*day);
end
