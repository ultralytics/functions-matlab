function a = fcnrotateB2W(r,p,y,x)
sr=sin(r);  sp=sin(p);  sy=sin(y);
cr=cos(r);  cp=cos(p);  cy=cos(y);

a = zeros(size(x));
a(:,1) = x(:,1).*(cp.*cy)            + x(:,2).*(cp.*sy )           + x(:,3).*(-sp);
a(:,2) = x(:,1).*(sr.*sp.*cy-cr.*sy) + x(:,2).*(sr.*sp.*sy+cr.*cy) + x(:,3).*(sr.*cp);
a(:,3) = x(:,1).*(cr.*sp.*cy+sr.*sy) + x(:,2).*(cr.*sp.*sy-sr.*cy) + x(:,3).*(cr.*cp);