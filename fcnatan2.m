% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function val = fcnatan2(y,x)
val = 2*atan((sqrt(x.^2+y.^2)-x)./y);


% t = linspace(-pi,pi,100);
% x = cos(t);
% y = sin(t);
% 
% z1 = atan(y./x);
% z2 = atan2(y,x);
% z3 = fcnatan2(y,x);
% 
% figure; plot(t,z1,'.r',t,z2,'g',t,z3,'.b','linewidth',2); legend('atan','atan2','fcnatan2'); axis tight; xlabel('theta (rad)')