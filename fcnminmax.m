function varargout = fcnminmax(x)

if nargout<2
    varargout{1} = [min3(x) max3(x)];
else
    varargout{1} = min3(x);
    varargout{2} = max3(x);
end

