% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function cc = fcnelaz2CC(el,az)
%angles in radians
if nargin==1
    az = el(:,2);
    el = el(:,1);
end
cc = zeros(numel(az),3); 
k1 = cos(el);  
 
cc(:,1) = k1.*cos(az);  
cc(:,2) = k1.*sin(az);  
cc(:,3) = -sin(el);