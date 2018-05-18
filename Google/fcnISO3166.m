function countryName = fcnISO3166(countryCode)
load ISO3166-1.mat

i=strcmp(x(:,2),countryCode); %#ok<NODEF>
countryName=x{i,1};






