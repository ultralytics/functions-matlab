% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function f = quadratic(a,b,c)
%a = - 0.02903;
%b = 9.807;
%c = - 836.9;
f = (-b+sqrt(b.^2-4*a.*c))./(2*a);

