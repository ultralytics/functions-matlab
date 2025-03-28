% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function R = fcnfresnel(n1,n2,ct)
%http://en.wikipedia.org/wiki/Fresnel_equations
%equations for photon reflection and refraction between two materials
%n1 = index of refraction material 1
%n2 = index of refraction material 2
%theta = photon incoming angle off normal. parallel with surface = zero deg.
%ct = cos(theta);

%n1 = 1.5801; %glass
%n2 = 1.0; %outside detector
%theta = acos(linspace(0,1,1000));

%ct = cos(theta);
%st = sin(theta);
%st = sqrt(1-ct.^2);
%k1 = sqrt(1-((n1./n2).*st).^2);
k1 = real( sqrt(1-(n1./n2).^2.*(1-ct.^2)) );

n1ct = n1.*ct;
n1k1 = n1.*k1;
n2ct = n2.*ct;
n2k1 = n2.*k1;
Rs = ( (n1ct - n2k1)./(n1ct + n2k1) ).^2;
Rp = ( (n1k1 - n2ct)./(n1k1 + n2ct) ).^2;
R = min( (Rs+Rp)/2, 1);

R(ct<0) = 0;

% fig(1,1,2);
% plot(theta*r2d,R,'color',[1 1 1]*.8);
% plot(theta*r2d,Rs,'b',theta*r2d,Rp,'r'); grid on
% legend('R = (Rs+Rp)/2','Rs (perpendicular polarized)','Rp (parallel polarized)'); 
% xlabel('Incident Angle Off Normal (deg)')
% ylabel('Reflectance R (fraction)')
% title(sprintf('Reflected light going from %.4f to %.4f IOR',n1,n2))
% fcnlinewidth(1.5); axis tight
% 
% fcnlinewidth(2); fcnfontsize(12)
% export_fig(gcf,'-q95','-r200','-a4','exported.jpg','-native')
end

% n1 = 1.58; %EJ-254
% n2 = 1.00; %outside detector
% theta = acos(linspace(0,1,1000));
% 
% ct = cos(theta);
% st = sin(theta);
% %st = sqrt(1-ct.^2);
% %k1 = sqrt(1-((n1./n2).*st).^2);
% k1 = real( sqrt(1-(n1./n2).^2.*(1-ct.^2)) );
% 
% n1ct = n1.*ct;
% n1k1 = n1.*k1;
% n2ct = n2.*ct;
% n2k1 = n2.*k1;
% Rs = ( (n1ct - n2k1)./(n1ct + n2k1) ).^2;
% Rp = ( (n1k1 - n2ct)./(n1k1 + n2ct) ).^2;
% R = min( (Rs+Rp)/2, 1);
% 
% Rs(ct<0) = 0;
% Rp(ct<0) = 0;
% R(ct<0) = 0;
% 
% fig(1,1,2);
% plot(theta*r2d,R,'color',[1 1 1]*.8);
% plot(theta*r2d,Rs,'b',theta*r2d,Rp,'r'); grid on
% legend('R = (Rs+Rp)/2','Rs (perpendicular polarized)','Rp (parallel polarized)'); 
% xlabel('Incident Angle Off Normal (deg)')
% ylabel('Reflectance R (fraction)')
% title(sprintf('reflected light travelling from %.2f to %.2f index',n1,n2))
% fcnlinewidth(2); axis tight

%fcnlinewidth(2); fcnfontsize(12)
%export_fig(gcf,'-q95','-r200','-a4','exported.jpg','-native')