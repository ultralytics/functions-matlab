% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function c = redwhite(m)
if nargin==0; m=64; end
i = m:-1:1;

colors = [ ...
    1 0 0
    .95 .95 1];

nc = size(colors,1);
f = linspace(1,m,nc);
c = interp1(f,colors,i,'*linear');
