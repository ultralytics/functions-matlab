function v = fcnstdvar(y0, k)
%standard deviation of the variance (y0) after (k) MC runs
%(approximation)

v = sqrt(    y0.^2.*sqrt(2/k)    ); %bar shalom std of a variance
end

