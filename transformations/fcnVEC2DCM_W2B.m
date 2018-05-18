function DCM_W2B = fcnVEC2DCM_W2B(cc)
%roll=0;
%pitch=asin(-cc(3)/norm(cc));
%yaw=atan2(cc(2),cc(1));
%rpy = [0,  asin(-cc(3)/norm(cc)),  atan2(cc(2),cc(1))];
DCM_W2B = fcnRPY2DCM_W2B([0,  asin(-cc(3)/norm(cc)),  atan2(cc(2),cc(1))]);





% %ZERO ROLL SOLUTION
% syms x y z p y cp sp cy sy real
% p = asin(-z/1); %unit vector!
% y = atan2(y,x);
% cp=cos(p);  sp=sin(p);
% cy=cos(y);  sy=sin(y);
% 
% 
% DCM_W2B =   [ cp*cy, cp*sy, -sp
%                 -sy,    cy,   0
%               cy*sp, sp*sy,  cp]  %ZERO ROLL