% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [x, y, z, h, VX,VY,VZ] = cube(length,p0,plotflag)
%length = [100 200 300]; p0 = [0 0 0];
if nargin==1
   p0=[0 0 0];
end
h=[];

x = length(1)*[ 1   1   1   1;  -1   -1   -1   -1;  -1   1   1  -1;  -1   1   1  -1]' + p0(1);
y = length(2)*[-1  -1   1   1;  -1   -1    1    1;   1   1  -1  -1;   1   1  -1  -1]' + p0(2);
z = length(3)*[ 1  -1  -1   1;   1   -1   -1    1;   1   1   1   1;  -1  -1  -1  -1]' + p0(3);

x = x([1 2 3 4 1],:);  x(end+1,:)=nan;
y = y([1 2 3 4 1],:);  y(end+1,:)=nan;
z = z([1 2 3 4 1],:);  z(end+1,:)=nan;

if nargin==3 && plotflag
    h=plot3(x, y, z,'Color',[.7 .7 .7]);
end


%VERTICES FOR PATCH OBJECTS
vx = [ 1  -1
       1  -1
      -1   1
      -1   1];

vy = [-1  -1
       1   1
       1   1
      -1  -1];
vz = [-1   1
      -1   1
      -1   1
      -1   1];
  
VX = [vx vz vy]*length(1); %patch vertices
VY = [vy vy vz]*length(2);
VZ = [vz vx vx]*length(3);
  
% fig
% hp = patch(1, 1, 1, 'w', ...
%       'EdgeColor','none', ...
%       'FaceColor',[1 1 1]*.7, ...
%       'FaceAlpha',.1);
% 
% hp.XData=VX;
% hp.YData=VY;
% hp.ZData=VZ;
% axis equal; fcnview('skew')