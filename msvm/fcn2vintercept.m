% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function C0 = fcn2vintercept(A,ux1,uy1,uz1)
[nf, ntp] = size(ux1);
ova=ones(1,nf);
a = 1:nf; 
j = tril(a(ova,:), -1); j=j(j~=0); 
k = tril(a(ova,:)',-1); k=k(k~=0); njk=numel(j);
BAx=A(j,1)-A(k,1);  BAy=A(j,2)-A(k,2);  BAz=A(j,3)-A(k,3);

%COMBINATIONS
vx=ux1(k,:);  vy=uy1(k,:);  vz=uz1(k,:);
ux=ux1(j,:);  uy=uy1(j,:);  uz=uz1(j,:);

%VECTOR INTERCEPTS
d = ux.*vx + uy.*vy + uz.*vz;
e = ux.*BAx + uy.*BAy + uz.*BAz;
f = vx.*BAx + vy.*BAy + vz.*BAz;
g = 1 - d.*d;
s1 = (d.*f - e)./g; %multiply times u
t1 = (f - d.*e)./g; %multiply times v

%MISCLOSURE VECTOR RANGE RESIDUALS
% r = sqrt((t1.*vx-BAx-s1.*ux).^2 + (t1.*vy-BAy-s1.*uy).^2 + (t1.*vz-BAz-s1.*uz).^2) ; %sum of the squared ranges of the misclosure vectors

%TIE POINT CENTERS
C0 = zeros(ntp,3);
den = njk*2; %denominator = number of permutations times 2
B = sum(A)*(nf-1);
C0(:,1) = (sum(t1.*vx+s1.*ux,1)+B(1)) / den;
C0(:,2) = (sum(t1.*vy+s1.*uy,1)+B(2)) / den;
C0(:,3) = (sum(t1.*vz+s1.*uz,1)+B(3)) / den;
