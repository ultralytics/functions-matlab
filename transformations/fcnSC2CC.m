function cc = fcnSC2CC(r,el,az)
%angles in radians
if nargin==1
    az = r(:,3);
    el = r(:,2);
    r  = r(:,1);
end
cc = zeros(numel(az),3); 
k1 = r.*cos(el);  
 
cc(:,1) = k1.*cos(az);  
cc(:,2) = k1.*sin(az);  
cc(:,3) = -r.*sin(el);
