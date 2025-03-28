% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [lla, s] = fcnGoogleGeocodingAPI(address,region)
%https://developers.google.com/maps/documentation/geocoding/
%https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=YOUR_API_KEY

%lat lng in degrees, zero elevation

if iscell(address)
    n = numel(address);
else
    n = 1;
end
lla = zeros(n,3);
address = strrep(address,'?','e');

for i = 1:n
    if iscell(address); addressi=address{i}; else addressi=address; end
    if nargin==1
        urlstr = sprintf('https://maps.googleapis.com/maps/api/geocode/json?address=%s&key=%s',addressi,GoogleAPIkey);  
    else %2
        if iscell(region); regioni=region{i}; else regioni=region; end
        urlstr = sprintf('https://maps.googleapis.com/maps/api/geocode/json?address=%s&region=%s&key=%s',addressi,regioni,GoogleAPIkey);  
    end
    urlstr=strrep(urlstr,' ','+');
    %fprintf('Retrieving %.0f Locations from Google Geocoding API: %s\n',i,urlstr)
    [s, status] = urlread(urlstr);
    
    gs = regexpi(s,'"status" : "(.+)"','tokens'); gs=gs{1}{1};  %https://developers.google.com/maps/documentation/geocoding/#StatusCodes
    if status==0 || ~strcmpi(gs,'OK'); %no results were found :(
        fprintf('WARNING: Google Geocoding failure. Status code ''%s'' for ''%s''',gs,urlstr)
        continue
    end
    
    si = regexpi(s,'"location" : {','once'); %Find the first instance in case more than one return
    s=s(si:end);
    sj = regexpi(s,'lat" : ','once'); 
    sk = regexpi(s,'lng" : ','once'); 

    lla(i,:) = [eval(s(sj+7:sj+17)),   eval(s(sk+7:sk+17)), 0];
end




