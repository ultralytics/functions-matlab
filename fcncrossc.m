% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function c = fcncrossc(a,b)
%for column vectors. use fcncrossr for row vectors
%a and b are 3xn or 3x1
c = [a(2,:).*b(3,:)-a(3,:).*b(2,:);   a(3,:).*b(1,:)-a(1,:).*b(3,:);   a(1,:).*b(2,:)-a(2,:).*b(1,:)];
end