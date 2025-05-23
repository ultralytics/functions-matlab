% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function deg=dms2deg(dms)
% DMS2DEG  Converts degrees-minutes-seconds to decimal degrees.
%   Vectorized.
% Version: 12 Mar 00
% Usage:  deg=dms2deg(dms)
% Input:   dms - [d m s] array of angles in deg-min-sec, where
%                d = vector of degrees
%                m = vector of minutes
%                s = vector of seconds
% Output:  deg - vector of angles in decimal degrees
d=dms(:,1);
m=dms(:,2);
s=dms(:,3);
deg=abs(d)+abs(m)./60+abs(s)./3600;
ind=(d<0 | m<0 | s<0);
deg(ind)=-deg(ind);
