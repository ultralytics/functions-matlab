% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function stdAz = fcnstdAz(vCC,stdCC)
%This function takes in an nx3 matrix whos columns are the x y z components
%of each row's cartesian vectors. It uses a rational equation fit to determine the
%correct azimuth angle standard deviation. This azimuth angle should
%encompass 68.3% of the input vectors.


%GET SIGNAL TO NOISE RATIO FOR INPUT CARTESIAN VECTORS --------------------
if nargin==1
    r = norm(mean(vCC)); %length of mean vector
    stdCC = mean(std(vCC)); %cartesian std per axis
else
    r = norm(vCC); %length of mean vector
    stdCC = mean(stdCC);
end
SNR = r./stdCC;

t = linspace(0,180,1E4);

pdf = fcnthetapdf(SNR, cosd(t), sind(t)).*sind(t);
cdfy = cumsum(pdf); cdfy = cdfy/max(cdfy);
randnumber = 68.2689492/100;
cdfx = t;
%stdAz = interp1(cdf, t, confidence);
ny = numel(cdfy);
interptype = 'linear';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%RESIZE CDFY TO ROW VECTOR
if size(cdfy,1) == 1 %row vector
    cdfy = cdfy';
end
if size(cdfx,1) == 1
    cdfx = cdfx';
end

%ensure distinct x values, remove duplicate leading zeros and duplicate trailing ones
v0 = find(diff(cdfy)>0);
nv0 = numel(v0);
if nv0<(ny-1)
    if v0(1)~=1; %delete leading 0
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
r = randnumber*span + cdfy(1); %much FASTER than s=s/sum(s);
if nargin==3
    x = interp1(cdfy,cdfx,r,'nearest');
else
    x = interp1(cdfy,cdfx,r,interptype);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stdAz = x;
