function [prefix,n]=numberPrefix(n)
if n<1E-9
    prefix='p';  n=n/1E-12; %pico
elseif n<1E-6
    prefix='n';  n=n/1E-9; %nano
elseif n<1E-3;
    prefix='u';  n=n/1E-6; %mico
elseif n<1
    prefix='m';  n=n/1E-3; %milli
elseif n<1000;
    prefix='';
elseif n<1E6;
    prefix='k';  n=n/1E3; %kilo
elseif n<1E9;
    prefix='M';  n=n/1E6; %Mega
elseif n<1E12
    prefix='G';  n=n/1E9; %Giga
end
end