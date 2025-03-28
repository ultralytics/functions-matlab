% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function c = fcncross1(a,b)
%for single row or column vectors, 3x1 or 1x3
c = [a(2)*b(3)-a(3)*b(2);   a(3)*b(1)-a(1)*b(3);   a(1)*b(2)-a(2)*b(1)];
end