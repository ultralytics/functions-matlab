% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function x = edges2centers(x)
%inputs a 1D vector x of histogram bin edges
%outputs a 1D vector x of histogram bin centers

x = (x(1:end-1) + x(2:end))/2;

