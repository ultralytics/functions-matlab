function a = fcnrotateW2B(r,p,y,x)
sr=sin(r);  sp=sin(p);  sy=sin(y);
cr=cos(r);  cp=cos(p);  cy=cos(y);

a = zeros(numel(r),3);
a(:,1) = x(:,1).*(cp.*cy) + x(:,2).*(sr.*sp.*cy-cr.*sy) + x(:,3).*(cr.*sp.*cy+sr.*sy);
a(:,2) = x(:,1).*(cp.*sy) + x(:,2).*(sr.*sp.*sy+cr.*cy) + x(:,3).*(cr.*sp.*sy-sr.*cy);
a(:,3) = x(:,1).*(-sp)    + x(:,2).*(sr.*cp)            + x(:,3).*(cr.*cp);

        