function fcnplotaxes3(r)
%r = range of axes
if nargin==0; r = 1.25;  end

rt = r*1.08; %text range
x=[0 0 0];  y=[0 0 0];  z=[0 0 0];
u=[1 0 0];  v=[0 1 0];  w=[0 0 1];
c = [.7 .7 .7]*.2;
quiver3(x,y,z,u,v,w,r,'linewidth',2,'color',c);
text(rt,0,0,'x','color',c);  text(0,rt,0,'y','color',c);  text(0,0,rt,'z','color',c)
