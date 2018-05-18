function c = fcncrossr(a,b)
%for row vectors. use fcncrossc for column vectors
%a and b are nx3 or 1x3
c = [a(:,2).*b(:,3)-a(:,3).*b(:,2),   a(:,3).*b(:,1)-a(:,1).*b(:,3),   a(:,1).*b(:,2)-a(:,2).*b(:,1)];
end