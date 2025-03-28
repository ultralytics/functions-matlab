% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function C0 = fcnNvintercept(A,ux1,uy1,uz1)
[nf, ntp] = size(ux1);

% C0 = zeros(ntp,3);
% for j=1:cam.msv.ntp;
%     vi = [ux1(:,j) uy1(:,j) uz1(:,j)];  S1 = zeros(3);  S2 = zeros(3,1);
%     for i=1:cam.msv.nf %nf vectors
%         a1 = eye(3) - vi(i,:)'*vi(i,:);
%         S1 = S1 + a1;
%         S2 = S2 + a1*A(i,:)';
%     end
%     C0(j,:) = S1\S2;
% end

v1 = 1-ux1.^2;      v2 = -ux1.*uy1;     v3 = -ux1.*uz1;
v4 = v2;            v5 = 1-uy1.^2;      v6 = -uy1.*uz1;
v7 = v3;            v8 = v6;            v9 = 1-uz1.^2;

S1mat = zeros(9,ntp);
S1mat(1,:) = sum(v1);  S1mat(2,:) = sum(v2);  S1mat(3,:) = sum(v3);
S1mat(4,:) = sum(v4);  S1mat(5,:) = sum(v5);  S1mat(6,:) = sum(v6);
S1mat(7,:) = sum(v7);  S1mat(8,:) = sum(v8);  S1mat(9,:) = sum(v9);

S2mat = zeros(3,ntp);  Ax = A(:,1)';  Ay = A(:,2)';  Az = A(:,3)';
S2mat(1,:) = Ax*v1 + Ay*v2 + Az*v3;
S2mat(2,:) = Ax*v4 + Ay*v5 + Az*v6;
S2mat(3,:) = Ax*v7 + Ay*v8 + Az*v9;

C0 = zeros(ntp,3);
S1m = reshape(S1mat,3,3,ntp);
for j=1:ntp
    C0(j,:) = S1m(:,:,j)\S2mat(:,j);
end
