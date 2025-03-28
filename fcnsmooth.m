% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function x = fcnsmooth(x,n)
%smooths each column. Moving average window n samples wide. n must be odd!
if nargin==1; n=5;  end
if n==0; return; end
if n<1; n=round(numel(x)*n); end; %n is fraction of numel(x)
if mod(n,2)==0; n=n+1; end %must be odd!
[nr,nc]=size(x);
si = (0:n-1) - (n-1)/2;

%Try matrix multiplication smearing method, i.e. (1024x1024)*(1024*300000)
r=(1:nr)' + zeros(1,n);
c=(1:nr)' + si;  c=max(c,1);  c=min(c,nr);
S = sparse(c(:),r(:),1/n,nr,nr);  %fig; pcolor(S); shading flat; axis tight

if isa(x,'single')
    x = single(S*double(x));
else %double
    x = S*x;
end

%SLOWER METHOD
%vi = max(min( (1:nr)-si(:) ,nr),1);
%x=permute( sum(reshape(x(vi,:),[n nr nc])), [2 3 1]) / n;  %slower for large matrices


