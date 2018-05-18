function s = fcnstdnonlin(x,cl,mu)
%this function recovers the extent of x from the mean which contains 68.3% of the population
%cl = confidence level (fraction)
%mu = mean(x), where confidence bounds are centered
if nargin==1 || isempty(cl)
    cl = .682689492;
end
n = numel(x);
if nargin < 3;  mu = sum(x(:))/n; end
x = x(:) - mu;
    
s = sort(abs(x));
s = s(round(n*cl));




