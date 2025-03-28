% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function y = fcnrms(x)
y = sqrt(mean(x(:).^2));


