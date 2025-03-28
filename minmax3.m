% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function y = minmax3(x)
xv=x(:);
y(1) = min(xv);
y(2) = max(xv);
