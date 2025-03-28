% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [zi, ETOPO] = etopo1(lat,lon,ETOPO)
if nargin==2 || isempty(ETOPO)  %LOAD .MAT FILE
    fprintf('Loading ETOPO Ice Data... '); tic
    ETOPO = load('ETOPO1_Ice_g.mat');
    fprintf('Done (%.2fs)\n',toc)
end

lon = longitude360to180(lon);

% ETOPOsingle=single(ETOPO.ETOPO1_Ice_g);
% F = griddedInterpolant({ETOPO.lats(:),ETOPO.lngs(:)},ETOPOsingle);
% zi=F(-lat,lon);

xi = interp1c(ETOPO.lats,numel(ETOPO.lats):-1:1,lat);
yi = interp1c(ETOPO.lngs,1:numel(ETOPO.lngs),lon);
zi = double( interp2cint16(ETOPO.ETOPO1_Ice_g,single(yi),single(xi)) );

%fig; pcolor(reshape(xi,[401 401]),reshape(yi,[401 401]),reshape(double(zi3)-zi2,[401 401])); shading flat; axis tight

