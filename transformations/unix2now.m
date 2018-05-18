function now = unix2now(unix)
%http://www.mathworks.com/help/matlab/ref/now.html
%converts seconds since 1/1/1970 (unix time) to days from 0/0/000 (matlab 'now' time)
now = unix/86400 + datenum('01-Jan-1970');