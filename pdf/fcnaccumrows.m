function xc = fcnaccumrows(mat,subs,val,sz)
%max = matrix
%subs = row indices
%sz = size of xc (optional)
if nargin<3;  val=1; end %gain on each row
sa = size(mat);  
if sa(1)==1; xc=mat*val; return; end %only 1 row!


%DO NOT DO!!! FUCKS UP FCNMEANSPECTRA!!!!
%if numel(subs)==1
    %xc=mat; %DO NOT SET xc==mat, otherwise nsim breaks in fcnmeanspectra
    %when adding crust tiles!!!!
%    'PROBLEM IN ACCUMROWS.M, numel(subs)==1!!!!'
%    return
%end
%DO NOT DO!!! FUCKS UP FCNMEANSPECTRA!!!!


if nargin<4
    sz = [max(subs) sa(2:end)]; %size xc
end

if numel(sa)>2 
    mat = reshape(mat, [sa(1) prod(sa(2:end))] ); 
end
S = sparse(subs,1:sa(1),val,sz(1),sa(1));
xb = S*mat;


if issparse(xb)
    xb = full(xb);
    fprintf('Warning: Scalar subscript being passed to fcnaccumrows.m (Unnecessary to call this function!!!)\n')
end


sb = size(xb);
if numel(sb)~=numel(sz) || any(sb~=sz)
    xc = reshape(xb, sz);
else
    xc = xb;
end
