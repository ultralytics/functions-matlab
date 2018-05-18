function [x, inliers] = fcnsigmarejection(x,srl,ni,str)
if nargin==1
    srl = 3; %rejection sigma level (i.e. 3sigma)
    ni = 3; %number of iterations
end
s=size(x);
x=x(:);

recastflag = ~isfloat(x);
if recastflag
    classx=class(x);
    x=single(x);
end


inliers = isfinite(x);  % remove nans;
for j=1:ni    
    newoutliers = ~inliers & ~isnan(x);  if j>1 && ~any(newoutliers); break; end
    np=sum(inliers);  if np<3; break; end

    x(newoutliers)=nan;
    mu = sum(x,'omitnan')/np;
    xms=(x-mu).^2;  sigma = sqrt((1/(np-1))*sum(xms,'omitnan'));  if sigma==0; break; end
    inliers = xms<(srl*sigma)^2;
end
inliers=reshape(inliers,s);
if nargin==4 && strcmp(str,'onlyIndices'); return; end
x=x(inliers);

if recastflag
    x=cast(x,classx);
end
    

% inliers = isfinite(x);  % remove nans;
% x = x(inliers);
% for j=1:ni
%     np = numel(x);  if np<3; return; end
%     
%     %residual ranges
%     r = x;
%     mu = sum(r)/np;  sigma = sqrt((1/(np-1))*sum((r-mu).^2));  if sigma==0; return; end
%     valid = r<(mu+srl*sigma) & r>(mu-srl*sigma); 
%     x = x(valid);
%     inliers(inliers) = valid;
% 
%     if numel(x)==np; return; end %premature exit criteria
% end
