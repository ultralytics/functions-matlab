% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function x = fcnvec2uvec(x, r)
%This function turns each row in the matrix into a unit vector, nx3

if nargin==1
    r = sqrt(sum(x.^2,2));
end
x = x./r;