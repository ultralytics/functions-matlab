% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function k = fcnconfidence2sigma(conf,n)
%converts confidence fraction (0 to 1) into a sigma multiple.
%i.e. 1.0006 = fcnconfidence2sigma(.683,1)

if nargin==1
    n = 1;
end

k = sqrt(qchisq(conf,n)); % n is the number of dimensions (degrees of freedom)
%k = erfinv(conf)*sqrt(2); %1 dim only!!


%---------------------------------------------------------------
function x=qchisq(P,n)
% QCHISQ(P,N) - quantile of the chi-square distribution.

s0 = P==0;
s1 = P==1;
s = P>0 & P<1;
x = 0.5*ones(size(P));
x(s0) = -inf;
x(s1) = inf;
x(~(s0|s1|s))=nan;

for ii=1:14
  dx = -(pchisq(x(s),n)-P(s))./dchisq(x(s),n);
  x(s) = x(s)+dx;
  if all(abs(dx) < 1e-6)
    break;
  end
end

%---------------------------------------------------------------
function F=pchisq(x,n)
% PCHISQ(X,N) - Probability function of the chi-square distribution.
F=zeros(size(x));

if rem(n,2) == 0
  s = x>0;
  k = 0;
  for jj = 0:n/2-1;
    k = k + (x(s)/2).^jj/factorial(jj);
  end
  F(s) = 1-exp(-x(s)/2).*k;
else
  for ii=1:numel(x)
    if x(ii) > 0
      F(ii) = integral(@(x)dchisq(x,n),0,x(ii));    %F(ii) = quadl(@dchisq,0,x(ii),1e-6,0,n); %OLD!
    else
      F(ii) = 0;
    end
  end
end

%---------------------------------------------------------------
function f=dchisq(x,n)
% DCHISQ(X,N) - Density function of the chi-square distribution.
f=zeros(size(x));
s = x>=0;
f(s) = x(s).^(n/2-1).*exp(-x(s)/2)./(2^(n/2)*gamma(n/2));
