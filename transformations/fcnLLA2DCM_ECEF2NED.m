function DCM_ECEF2NED = fcnLLA2DCM_ECEF2NED(LLA)
%http://www.mathworks.com/help/toolbox/aeroblks/directioncosinematrixeceftoned.html
lat = LLA(1);
lon = LLA(2);

% C1 = [  -sin(lat)   0           cos(lat)
%         0           1           0
%         -cos(lat)   0           -sin(lat)];
%     
% C2 = [  cos(lon)    sin(lon)    0
%         -sin(lon)   cos(lon)    0
%         0           0           1];
%     
% DCM_ECEF2NED = C1*C2;

DCM_ECEF2NED =  [ -cos(lon)*sin(lat), -sin(lat)*sin(lon),  cos(lat)
                           -sin(lon),           cos(lon),         0
                  -cos(lat)*cos(lon), -cos(lat)*sin(lon), -sin(lat)];


