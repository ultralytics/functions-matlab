function [sigma, mu, n] = nonzerostd(x,dim)
if nargin==1; dim=1; end

nz=x~=0;
n=sum(nz,dim);
mu=sum(x,dim)./n;

if isa(x,'single')
    dx=(x-mu).*single(nz);
else
    dx=(x-mu).*double(nz);
end
sigma=sqrt((1./(n-1)).*sum(dx.^2,dim)); %#ok<*PFOUS>

%TO VERIFY (BUT SLOWER)
%x(x==0)=nan;  mu=nanmean(x,dim);  sigma=nanstd(x,[],dim);  %to verify
