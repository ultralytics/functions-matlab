function [pdf, lpdf] = fcnmultinormpdf(x, u, C)
%Multivariate normal distribution
%x = evaluation point (n x k)
%u = mean (k x 1)
%C = covariance matrix (k X k)
%DEFINE CONSTANTS
k = numel(u);

%GET DETERMINANT
scaling = mean(diag(C));
sdetC=abs(det(C/scaling)); %SCALED determinant of C
logdetC = log(sdetC) + scaling*k;

invC = C^-1;
%detC=abs(det(C));
%den = 1/((2*pi)^(k/2)*sqrt(detC)); %denominator
logden = - (log(2*pi)*(k/2) + logdetC/2);

%CHANGE u TO COLUMN
[rowsu, ~] = size(u);
if rowsu==1
    u=u';
end


if numel(x)==numel(u) && all(size(x)==size(u))
    dx1 = x-u;
    lpdf0 = sum((dx1*invC).*dx1,2);
    lpdf = (-1/2)*lpdf0 + logden;
    pdf = exp(lpdf);
    return
end


%RESHAPE x to 1D
sizex0 = numel(x);
if sizex0>1
    sizex0 = size(x);
    ne = numel(sizex0);
    if numel(sizex0)>2
        x = reshape(x, prod(sizex0(1:ne-1)), k);
    elseif sizex0(ne)~=k
        x = reshape(x, prod(sizex0), k);
    end
end

% dx1 = zeros(size(x));
% for i = 1:k
%     dx1(:,i) = x(:,i)-u(i);
% end
% lpdf0 = sum((dx1*invC).*dx1,2);
% lpdf = (-1/2)*lpdf0 + log(den);

for i = 1:k
    x(:,i) = x(:,i)-u(i);
end
lpdf = (-1/2)*sum((x*invC).*x,2) + logden;


%RESHAPE FROM 1D TO ORIGINAL FORMAT
if numel(sizex0)>2
    lpdf = reshape(lpdf, sizex0(1:ne-1));
elseif sizex0(ne)~=k
    lpdf = reshape(lpdf, sizex0);
end

pdf = exp(lpdf);
end

