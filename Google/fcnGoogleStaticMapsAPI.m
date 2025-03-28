% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [] = fcnGoogleStaticMapsAPI(lat,lng,zoom,fname)
tic

scale = 2;
mapType = 'satellite';
address=['http://maps.google.com/maps/api/staticmap?center=' sprintf('%.6f',lat) ',' sprintf('%.6f',lng) '&zoom=' sprintf('%.0f',zoom) '&size=640x640&scale=' sprintf('%.0f',scale) '&maptype=' mapType];
address = sprintf('%s&markers=color:red|label:R|size:mid|%.6f,%.6f',address,lat,lng);

% latlongs = getIAEAMarkers(gm, input);
% if numel(latlongs>0)
%     address = [address '&markers=color:yellow|label:R|size:mid|' latlongs];
% end
% 
% [latlongs, nA]  = getDetectorMarkers(input);
% if nA
%     address = [address '&markers=color:green|label:D|size:mid|' latlongs];
% end
% 
% [latlongs, nA]  = getReactorMarkers(input, flags);
% if nA
%     address = [address '&markers=color:red|label:R|size:mid|' latlongs];
% end

address = [address '&key=' GoogleAPIkey];
%warning('off', 'all')
try
    [I, map]=imread(address);
catch
    I=ones(640*scale,640*scale,1);
    map = jet;
end
imwrite(I,map,fname)

%fprintf('Google Static Maps API URL retrieved (%.2fs): %s\n',toc,address)
