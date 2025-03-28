% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function x = fcncell2mat(x)
if iscell(x)
    x = cell2mat(x);
end
