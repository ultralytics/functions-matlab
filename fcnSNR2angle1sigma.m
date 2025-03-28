% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function x = fcnSNR2angle1sigma(snr,nz)
%converts angular SNR and measurement count n into angular 1 sigma

t = linspace(0,pi,10000); ct=cos(t);
apdf1 = fcnthetapdf(snr*sqrt(nz), ct).*sin(t);
apdf1 = apdf1/max(apdf1);

cdfy = cumsum(apdf1);
cdfx = t;
xi = .68269;

ny = numel(cdfy);


cdfy = cdfy(:);
cdfx = cdfx(:);


%ensure distinct x values, remove duplicate leading zeros and duplicate trailing ones
v0 = find(diff(cdfy)>0);
nv0 = numel(v0);
if nv0>0 && nv0<(ny-1)
    if v0(1)~=1 && nv0>1; %delete leading 0
        v0 = [v0(2:nv0); max(v0)+1];
    else
        v0 = [v0; max(v0)+1];
    end
    
    cdfy = cdfy(v0);
    cdfx = cdfx(v0);
    ny = numel(v0);
end

% %RECONDITION RANDOM NUMBER TO NEW CDFY
span = cdfy(ny) - cdfy(1);
r = xi*span + cdfy(1); %much FASTER than s=s/sum(s);
F = griddedInterpolant(cdfy,cdfx); x=F(r)*r2d;

% figure; plot(t*r2d,apdf1,'g'); hold on
% np = 1E6;
% x=ones(np,1)*[1 0 0] + (randn(np,3)/snr)./sqrt(nz);
% theta = fcnangle([1 0 0],x)*r2d;
% [y,x]=hist(theta,100);
% y=y/max(y);
% plot(x,y)

end

