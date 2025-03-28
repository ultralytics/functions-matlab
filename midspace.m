% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function a = midspace(x1,x2,n)
%like linspace but returns the middle of the bins rather than the edges

dx = (x2-x1)/n;
a = linspace(x1+dx/2,x2-dx/2,n);



