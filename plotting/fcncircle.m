% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function h = fcncircle(r,x0)
if nargin==1; x0=0; end

n = 100;
sc = zeros(n,3);
sc(:,1) = r;
sc(:,2) = 0;
sc(:,3) = linspace(0,2*pi,n);

cc = fcnSC2CC(sc);

h=plot3(cc(:,1)+x0(1),cc(:,2)+x0(2),cc(:,3)+x0(3),'.-');


