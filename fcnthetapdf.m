% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function L = fcnthetapdf(snr, ct, st)
%DAN BONDY'S ANGLE LIKELIHOOD FOR A 3D WHITE NOISE VECTOR ANGLE
%ct = cosine theta;
%st = sin theta;
%snr = (vector magnitude) / (vector uncertainty) uncertainty is mean 1-sigma std in each dimension

%DEFINE SIN THETA SQUARED
%st = (1 - ct.^2).^(1/2);
if nargin==2
    sts = (1-ct.^2);
else
    sts = st.^2;
end

%DEFINE COSINE THETA TIMES SNR
ctsnr = ct.*snr;
b  = (-1/2)*snr.^2;

%GET LIKELIHOODS
L = ( (ctsnr.^2+1).*erfc((-1/sqrt(2))*ctsnr).*exp(b.*sts)/2  +  ctsnr.*(exp(b)/(sqrt(2*pi))) ); %CDF=1 OVER 1D PLOT FROM ct=-1 to ct=1
%L = L / (2*pi); %CDF=1 OVER 4pi SPHERE
end

%EXAMPLE PLOT
%ct=linspace(-1,1,100);  pdf=fcnthetapdf(.33,ct); fig; plot(ct,pdf); xyzlabel('cos(\theta)','pdf'); fcnlinewidth(2); fcntight('y0')