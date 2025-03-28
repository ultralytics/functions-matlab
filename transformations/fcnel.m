% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function el = fcnel(cc)
el = asin(-cc(:,3)./sqrt(cc(:,1).^2 + cc(:,2).^2 + cc(:,3).^2));
end


