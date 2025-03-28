% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function mu = nonzeromean(x,dim)
if nargin==1; dim=1; end

nz=x~=0;
n=sum(nz,dim);
mu=sum(x,dim)./n;

%TO VERIFY (BUT SLOWER)
%x(x==0)=nan;  mu=nanmean(x,dim); 
