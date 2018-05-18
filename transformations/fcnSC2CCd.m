function cc = fcnSC2CCd(r,el,az)
if nargin==1
    az = r(:,3);
    el = r(:,2);
    r  = r(:,1);
end
cc = zeros(numel(az),3); 
k1 = r.*cosd(el);  
 
cc(:,1) = k1.*cosd(az);  
cc(:,2) = k1.*sind(az);  
cc(:,3) = -r.*sind(el);
