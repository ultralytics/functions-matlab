function [coefficients, sumSquaredResiduals] = polyfitOrthogonal(x,y,n)
%THIS FUNCTION fits a 1st order polynomial using orthogonal regression to the equation y=b1*x+b0
%CALL THIS FUNCTION LIKE THIS:
%[coeff,sumSquaredResiduals]=polyfitOrthogonal(x,y,1);

covMat=cov(x,y); %covariance matrix of the x,y data
%cov = [sxx sxy
%       sxy syy];
sxx=covMat(1,1); %sigma x * sigma x = sxx = x variance
sxy=covMat(1,2); %sigma x * sigma y = sxy = xy covariance
syy=covMat(2,2); %sigma y * sigma y = syy = y variance

%b1=sxy/sxx; %ORDINARY LEAST SQUARES REGRESSION (not orthogonal, use this to minimize y residual only!)
b1=(syy-sxx+sqrt((syy-sxx)^2+4*sxy^2))/(2*sxy+eps); %ORTHOGONAL REGRESSION, eps for divide by zero cases
b0=mean(y)-b1*mean(x);
coefficients=[b1 b0];

%GET YAW ANGLE FROM FIT LINE AND ROTATE ALL POINTS TO ZERO YAW, THEN X RESIDUALS = ORTHOGONAL RESIDUALS
yaw = pi/2-acos(1/sqrt(b1^2+1)); %roll angle of the fit line
DCM_Yaw2zeroYaw = [ cos(-yaw) sin(-yaw) ; -sin(-yaw) cos(-yaw)];

%xy2=zeros(length(x),2);
% for i=1:length(x)
%     xy2(i,1:2) = (DCM_Yaw2zeroYaw*[x(i); y(i)-b0]);
% end
xy2 = [x (y-b0)] * (DCM_Yaw2zeroYaw');

sumSquaredResiduals = sum(xy2(:,1).^2); %SUM OF SQUARED ORTHOGONAL RESIDUALS

%PLOT RESULTS--------------------------------------------------------------
% figure(1)
% plot(x,y,'b.')
% axis square
% axis equal
% axis([0 10 -1 10])
% hold on
% plot([0 x],b1*[0 x]+b0,'b-')
% grid on
% hold on
% plot(xy2(:,1),xy2(:,2),'r.')
end