% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function x = fcnrandcdf(cdfy,cdfx,nr,interptype)
%MUST BE COLUMN VECTOR INPUTS!!
if nr==0
    x=[]; return
elseif nargin==3
    interptype = 'linear';
end

if size(cdfy,1)==1
      cdfy=cdfy(:);
      cdfx=cdfx(:);
      fprintf('Warning Pass column vectors to fcnrandcdf\n')
end

%ensure distinct x values, remove duplicate leading zeros and duplicate trailing ones
i = cdfy>circshift(cdfy(:),1); i(1)=true;
if any(~i)
    cdfy=cdfy(i);
    cdfx=cdfx(i);
    if numel(cdfx)<2
        x=cdfx(1)*ones(nr,1); return
    end
end


r = cdfy(1) + rand(nr,1)*(cdfy(end) - cdfy(1)); %random number

F = griddedInterpolant(cdfy,cdfx,interptype);  %FASTER than interp1
x=F(r);



