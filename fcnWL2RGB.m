% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function rgb = fcnWL2RGB(wl)
n = numel(wl);

v0 = find(wl>=200 & wl<=379);
v1 = find(wl>=380 & wl<=439);
v2 = find(wl>=440 & wl<=489);
v3 = find(wl>=490 & wl<=509);
v4 = find(wl>=510 & wl<=579);
v5 = find(wl>=580 & wl<=644);
v6 = find(wl>=645 & wl<=780);


r = zeros(n,1);
g = r;
b = r;

%v1 ----------------------------------
r(v0) = ((wl(v0) - 200)/(380 - 200));
g(v0) = 0.0;
b(v0) = ((wl(v0) - 200)/(380 - 200));
%v1 ----------------------------------
r(v1) = -((wl(v1) - 440)/(440 - 380));%.*((wl(v1)-0)/(440-0));
g(v1) = 0.0;
b(v1) = 1.0 ;%* (wl(v1)-0)/(440-0);
%v2 ----------------------------------
r(v2) = 0.0;
g(v2) = (wl(v2) - 440) / (490 - 440);
b(v2) = 1.0;
%v3 ----------------------------------
r(v3) = 0.0;
g(v3) = 1.0;
b(v3) = -(wl(v3) - 510) / (510 - 490);
%v4 ----------------------------------
r(v4) = (wl(v4) - 510) / (580 - 510);
g(v4) = 1.0;
b(v4) = 0.0;
%v5 ----------------------------------
r(v5) = 1.0;
g(v5) = -(wl(v5) - 645) / (645 - 580);
b(v5) = 0.0;
%v6 ----------------------------------
r(v6) = 1.0 - (wl(v6)-645)/(780-645);
g(v6) = 0.0;
b(v6) = 0.0;

rgb = zeros(n,3);
rgb(:,1) = r;
rgb(:,2) = g;
rgb(:,3) = b;
