function unix = now2unix(date)
if nargin==0; date=now; end
%**************TRY posixtime.m INSTEAD, 10X FASTER!! *****************

%http://www.mathworks.com/help/matlab/ref/now.html
%converts days from 0/0/000 (matlab 'now') to seconds since 1/1/1970 (unix time)
unix = datenum(date)*86400 - datenum('01-Jan-1970')*86400;

