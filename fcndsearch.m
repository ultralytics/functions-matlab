function [x, np] = fcndsearch(v,fraction)
v=v(:);
vs = sort(v);
nv = numel(vs);
vs = vs(1:round(nv*.995));
cs = cumsum(vs);

[~, i] = min(abs(cs/max(cs) - (1-fraction)));
x=vs(i);
np = numel(vs)-i;
