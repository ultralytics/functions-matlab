function x = centers2edges(x)
%inputs a 1D vector x of histogram bin centers
%outputs a 1D vector x of histogram bin edges

dx = x(2)-x(1);
x = [x x(end)+dx] - dx/2;

