function ned = ecef2ned(DEM,ecef)

if nargin==1
    ecef = DEM;
    ecef0 = mean(ecef);
    lla0 = ecef2lla(ecef0);
    C = fcnLLA2DCM_ECEF2NED(lla0);
    
    dx = [ecef(:,1)-ecef0(1), ecef(:,2)-ecef0(2), ecef(:,3)-ecef0(3)]; %translation
    ned = dx*C'; %rotation
    return
end

dx = [ecef(:,1)-DEM.centerecef(1), ecef(:,2)-DEM.centerecef(2), ecef(:,3)-DEM.centerecef(3)]; %translation
ned = dx*DEM.DCM_ECEF2NED'; %rotation
