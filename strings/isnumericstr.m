% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function i = isnumericstr(str)
%inputs a string, outputs true if the string is a number

s = size(str);
x = any(str(:)=='-.0123456789',2);
i = reshape(x,s);

