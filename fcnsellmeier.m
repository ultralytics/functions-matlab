% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function n = fcnsellmeier(wl,b1,c1,b2,c2,b3,c3)
%http://refractiveindex.info/?shelf=organic&book=polystyren&page=Sultanova
x = (wl/1E3).^2; %wavelength in micrometers squared

if ischar(b1)
    switch b1
        case 'Air' %http://refractiveindex.info/?shelf=other&book=air&page=Ciddor
            b1=0.05792105; c1=238.0185; b2=0.00167917; c2=57.362;
            ix = 1./x;  n = 1 + b1./(c1-ix) + b2./(c2-ix);  n = max(n,1);  return
        case 'N-BK7'
            b1=1.03961212; c1=0.00600069867; b2=0.231792344; c2=0.0200179144; b3=1.01046945; c3=103.560653;
        case 'N-BK10'
            b1=0.888308131; c1=0.00516900822; b2=0.328964475; c2=0.0161190045; b3=0.984610769; c3=99.7575331;
        case 'PMMA'
            b1=1.18190; c1=.011313;
        case 'PS'
            b1=1.4435; c1=0.020216;
        case 'EJ-254'
            b1=1.4395; c1=0.0066852;
    end
end


if exist('b2','var')
    n = sqrt(1 + b1*x./(x-c1) + b2*x./(x-c2) + b3*x./(x-c3));
else
    n = sqrt(1 + b1*x./(x-c1));
end
n = max(abs(n),1); %prevent faster than speed of light photons at ir<1
end


% microns2nm = 1/1000;
% %CAUCHY EQUATION from John Learned
% A = input.fluid.refractiveIndex-.02; %John Learned says A=1.4580;
% B = .00354;
% t.ir = A+B./(t.wlx*microns2nm).^2;