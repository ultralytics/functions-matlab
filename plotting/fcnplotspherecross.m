% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function fcnplotspherecross(el0,az0,span,x0,r)
%el0 = elevation of cross
%az0 = azimuth of cross
%span of cross (in degrees)
%x0 = center of sphere
%r = radius of sphere

c = [.7 .7 .7]*.2; %color
n = 11; %number of points per cross line
zv = zeros(n,1);
sv = linspace(-span/2,span/2,n)';
C = fcnRPY2DCM_B2W([0 el0 az0]*pi/180);

x = [fcnSC2CCd(r,zv,sv); nan(1,3); fcnSC2CCd(r,sv,zv)]*C';

plot3(x(:,1)+x0(1),x(:,2)+x0(2),x(:,3)+x0(3),'linewidth',2,'color',c)




