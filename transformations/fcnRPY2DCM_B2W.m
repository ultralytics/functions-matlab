% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function DCM_B2W = fcnRPY2DCM_B2W(RPY)
sr=sin(RPY(1));
sp=sin(RPY(2));
sy=sin(RPY(3));
cr=cos(RPY(1));
cp=cos(RPY(2));
cy=cos(RPY(3));

DCM_B2W = [ cp*cy       sr*sp*cy-cr*sy    cr*sp*cy+sr*sy
            cp*sy       sr*sp*sy+cr*cy    cr*sp*sy-sr*cy
              -sp                sr*cp             cr*cp];

%phi = roll        
%theta = pitch
%psi = yaw
% Cr =
% [ 1,   0,  0]
% [ 0,  cr, sr]
% [ 0, -sr, cr]
% Cp =
% [ cp, 0, -sp]
% [  0, 1,   0]
% [ sp, 0,  cp]
% Cy =
% [  cy, sy, 0]
% [ -sy, cy, 0]
% [   0,  0, 1]
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