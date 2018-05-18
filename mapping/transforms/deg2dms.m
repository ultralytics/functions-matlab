function dms=deg2dms(deg)
% deg2DMS  Converts degians to degrees-minutes-seconds. Vectorized.
% Version: 12 Mar 00
% Useage:  dms=deg2dms(deg)
% Input:   deg - vector of angles in degians
% Output:  dms - [d m s] array of angles in deg-min-sec, where
%                d = vector of degrees
%                m = vector of minutes
%                s = vector of seconds


deg1=abs(deg).*180/pi;
id=floor(deg1);
rm=(deg1-id).*60;
im=floor(rm);
s=(rm-im).*60;

%if deg<0
%  if id==0
%    if im==0
%      s = -s;
%    else
%      im = -im;
%    end
%  else
%    id = -id;
%  end
%end

ind=(deg<0 & id~=0);
id(ind)=-id(ind);

ind=(deg<0 & id==0 & im~=0);
im(ind)=-im(ind);

ind=(deg<0 & id==0 & im==0);
s(ind)=-s(ind);

dms=[id im s];
