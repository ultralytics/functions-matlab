function DCM_W2B = fcnRPY2DCM_W2B(RPY)
sr=sin(RPY(1));
sp=sin(RPY(2));
sy=sin(RPY(3));
cr=cos(RPY(1));
cp=cos(RPY(2));
cy=cos(RPY(3));

DCM_W2B = [ cp*cy                      cp*sy      -sp
            sr*sp*cy-cr*sy    sr*sp*sy+cr*cy    sr*cp
            cr*sp*cy+sr*sy    cr*sp*sy-sr*cy    cr*cp  ];
        
%phi = roll        
%theta = pitch
%psi = yaw
% Cr = ...
% [ 1,   0,  0
%   0,  cr, sr
%   0, -sr, cr]
% Cp = ...
% [ cp, 0, -sp
%    0, 1,   0
%   sp, 0,  cp]
% Cy = ...
% [  cy, sy, 0
%   -sy, cy, 0
%     0,  0, 1]
% C_W2B = Cr*Cp*Cy
% C_W2B =
% [            cp*cy,            cp*sy,   -sp]
% [ cy*sp*sr - cr*sy, cr*cy + sp*sr*sy, cp*sr]
% [ sr*sy + cr*cy*sp, cr*sp*sy - cy*sr, cp*cr]
% C_B2B = Cy'*Cp'*Cr'
% C_B2B =
% [ cp*cy, cy*sp*sr - cr*sy, sr*sy + cr*cy*sp]
% [ cp*sy, cr*cy + sp*sr*sy, cr*sp*sy - cy*sr]
% [   -sp,            cp*sr,            cp*cr]