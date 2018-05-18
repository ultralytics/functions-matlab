function theta = fcndaz(az1,az2)
%difference between two azimuth angles, unwraps everything!!

%n = numel(az1);
%ov1 = ones(n,1);
%zv1 = zeros(n,1);

%n = numel(az2); cc2 = zeros(n,2);  cc2(:,1)=cos(az2(:));  cc2(:,2)=sin(az2(:));

cc2x=cos(az2(:));  cc2y=sin(az2(:));


%cc1 = fcnSC2CC([ov1 zv1 az1(:)]);
%theta = fcnangle(cc1,cc2); %rad

%[atan2(cc2(:,2),cc2(:,1))-atan2(cc1(:,2),cc1(:,1)) theta]*57.3
%DCM=fcnRPY2DCM_W2B([0 0 az1]);
%siny=sin(az1(1));
%cosy=cos(az1(1));
%C = [ cosy    siny    0
%     -siny    cosy    0
%         0       0    1  ];
%cc1*C'

siny=sin(az1);
cosy=cos(az1);
%[cc1(:,1).*cosy+cc1(:,2).*siny  cc1(:,2).*cosy-cc1(:,1).*siny  zeros(n,1)]
%cc3 = [cc2(:,1).*cosy+cc2(:,2).*siny  cc2(:,2).*cosy-cc2(:,1).*siny  zeros(n,1)]; %cc2 expressed in cc1 reference frame (cc1 = [1 0 0])
theta = atan2(cc2y.*cosy-cc2x.*siny, cc2x.*cosy+cc2y.*siny);
end

