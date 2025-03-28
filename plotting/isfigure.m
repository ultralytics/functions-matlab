% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function a = isfigure(h)
n = numel(h);

a = false(n,1);
for i=1:n
    a(i)=any(regexpi(get(h(i),'type'),'figure'));
end