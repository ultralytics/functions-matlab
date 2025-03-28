% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function elevation = fcnGoogleElevation(lat,lng)
%elevation in meters above geoid, lat lng in degrees
%use 'llag2lla.m' for ellipsoid elevations

if nargin==1 %passed in nx2 or nx3
    lng = lat(:,2);
    lat = lat(:,1);
end


nl = numel(lat);    
elevation = zeros(nl,1);
done = false;

vi = 1:nl;
while ~done
    str = 'https://maps.googleapis.com/maps/api/elevation/xml?locations=';

    for i=1:numel(vi)
        j = vi(i);
        str = sprintf('%s%.5f,%.5f|',str,lat(j),lng(j));
        if numel(str)>1970 %URL limited to 2048 characters, need 58 free, each location takes 18 (2048-58-18 = 1978)
            break
        end
    end
    str = [str(1:end-1) '&key=' GoogleAPIkey]; %adds 58 characters

    fprintf('Retrieving %.0f Elevations from Google Elevation API: %s\n',i,str)
    urlstr = urlread(str);
    s1 = regexpi(urlstr,'<elevation>')+11;
    s2 = regexpi(urlstr,'</elevation>')-1;
    
    for i = 1:i
        j = vi(i);
        elevation(j) = eval(urlstr(s1(i):s2(i)));
    end

    if j==nl
       done = true;
    else
       vi = j+1:nl;
    end
end