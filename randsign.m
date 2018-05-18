function s = randsign(n)
if numel(n)>1
    s = sign(rand(n)-.5);
    return
end
s = sign(rand(n,1)-.5);
