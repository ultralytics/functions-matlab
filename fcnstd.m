% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [su, sl, mu] = fcnstd(x,mu)
%standard deviation of each column with an option mu argument of each column!
%su = sigma upper. if only one output argument then just sigma
%sl = sigma lower.
i = isfinite(x);
ni = sum(i);
a=x; a(~i)=0;

if nargin==1;  mu=sum(a)./ni;  end

if numel(x)==numel(mu)
    dx = a-mu;
else
    dx = x-mu; %ONLY WORKS FOR SU RIGHT NOW!
    dx(~i)=0;
end

if nargout<2 %traditional sigma
    su=sqrt((1./(ni-1)).*sum(dx.^2));
else %find separate upper and lower sigmas   
    j = (x>mu) & i;
    su=sqrt(sum(j.*(a-mu).^2)./(sum(j)-1));
    
    j = (x<mu) & i;
    sl=sqrt(sum(j.*(a-mu).^2)./(sum(j)-1));
end




