function y = fcntranspose3(x)
y = zeros(size(x,2), size(x,1), 3);
for i=1:3
    y(:,:,i) = x(:,:,i)';
end
end

