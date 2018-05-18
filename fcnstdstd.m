function s = fcnstdstd(y0, k)
%standard deviation of the standard deviation (y0) after (k) MC runs
%(approximation)

s = y0./sqrt(2*k-1); 
%s = y0.*sqrt(2./(k-1))./2; %Chris
%s = sqrt( 1./k.*(k-1-(2*gamma(k/2).^2)/(gamma((k-1)./2).^2)).*(k.*y0^2./(k-1)) ); %wolfram mathworld
end

