function [ellipse, cross, h] = fcnerrorellipse( C , mu, conf, plotflag)
%      'C' - Alternate method of specifying the covariance matrix
%      'mu' - Alternate method of specifying the ellipse (-oid) center
%      'conf' - A value betwen 0 and 1 specifying the confidence interval.
if nargin<4; plotflag=false; end
h=gobjects(2);

[r,c] = size(C);
x0=mu(1);
y0=mu(2);

if conf==.9 && r==2
    k=2.14597;
elseif conf==.9 && r==3
    k=2.50028;
else
    % Compute quantile for the desired percentile
    k = fcnconfidence2sigma(conf,r); % r is the number of dimensions (degrees of freedom)
    %k = erfinv(conf)*sqrt(2); %1 dim only!!
end


if r==3
    z0=mu(3);
    [eigvec,eigval] = eig(C);
    
    [X,Y,Z] = ellipsoid(0,0,0,1,1,1,100);
    XYZ = [X(:),Y(:),Z(:)]*sqrt(eigval)*eigvec';
    
    X(:) = k*XYZ(:,1)+x0;
    Y(:) = k*XYZ(:,2)+y0;
    Z(:) = k*XYZ(:,3)+z0;
    ellipse.x=X; ellipse.y=Y; ellipse.z=Z;
    
    %cross
    XYZ = [1.3  0  0
        -1  0  0
        0  0  0
        0  1  0
        0 -1  0
        0  0  0
        0  0  1
        0  0 -1] * sqrt(eigval)*eigvec';
    cross.x = k*XYZ(:,1)+x0;
    cross.y = k*XYZ(:,2)+y0;
    cross.z = k*XYZ(:,3)+z0;
    
    if plotflag
        h(1)=surf(X,Y,Z,'FaceColor',[0 0 0],'FaceAlpha',.2,'FaceLighting','gouraud','EdgeColor','none');%,'AmbientStrength',1E6);
        h(2)=plot3(cross.x,cross.y,cross.z,'b-','linewidth',1.2);
        box on; axis vis3d; light; camlight headlight
    end
elseif r==2
    n=100; % Number of points around ellipse
    p=(0:pi/n:2*pi)'; % angles around a circle
    
    [eigvec,eigval] = eig(C); % Compute eigen-stuff
    xy = k * [cos(p) sin(p)] * sqrt(eigval) * eigvec'; % Transformation
    ellipse.x=xy(:,1)+x0;  ellipse.y=xy(:,2)+y0;
    
    %cross
    p = [0 180 0 90 270 0 0 0]';
    gain = [1 1 0 1.3 1 0 0 0]';
    xy = k * [cosd(p).*gain, sind(p).*gain] * sqrt(eigval) * eigvec'; % Transformation
    cross.x=xy(:,1)+x0;  cross.y=xy(:,2)+y0;
    
    if plotflag
        h(1)=plot(ellipse.x,ellipse.y,'b.-');
        h(2)=plot(cross.x,cross.y,'b-');
    end
end








% %INPUT 2X2 COVARIANCE MATRIX, AND PERCENTILE YOU WANT ERROR ELLIPSE TO
% %ENCOMPASS. For example, if percentile=90, then the error ellipse will show
% %the region that encloses a 90% probability. If percentile=68.3, then you
% %will get a 1sigma error ellipse.
% 
% %MEAN XY POINTS ARE THE CENTER OF THE ELLIPSE. Input [0 0] if you don't need that part.
% 
% sigmaMultiple = erfinv(conf/100)*sqrt(2);
% 
% %SET NUMBER OF DATA POINTS TO RETURN, AND CENTER OF CIRCLE
% t=(1:1:361)'*pi/180; %theta, angles on the circle.
% cx=mu(1); %center of circle
% cy=mu(2); %center of circle
% 
% %GET EIGENVALUES AND EIGENVECTORS OF 2x2 XY COVMAT
% [eigVec eigVal] = eigs(C(1:2,1:2));
% a=sqrt(eigVal(1,1))*sigmaMultiple;
% b=sqrt(eigVal(2,2))*sigmaMultiple;
% phi=atan2(eigVec(2,1),eigVec(1,1));
% 
% %CALCULATE CIRCLE XY POINTS
% x=cx+a*cos(t)*cos(phi)-b*sin(t)*sin(phi);
% y=cy+b*sin(t)*cos(phi)+a*cos(t)*sin(phi);
% 
% %DEFINE OUTPUT ELLIPSE
% xyOut = [x y]; %move ellipse to mean point
% 
% %DEFINE OUTPUT CROSS
% cross(:,:,1) = [x(360)*0     x(90)*0    x(180)*0    x(270)*0
%                 x(360)*1.1   x(90)*1    x(180)*1    x(270)*1] + ones(2,4)*mu(1);
% cross(:,:,2) = [y(360)*0     y(90)*0    y(180)*0    y(270)*0
%                 y(360)*1.1   y(90)*1    y(180)*1    y(270)*1] + ones(2,4)*mu(2);
%             
% end
