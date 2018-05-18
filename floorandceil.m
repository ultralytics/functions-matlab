function x = floorandceil(x,a,b)
if nargin==2; b=a(2); a=a(1); end
    
x = min( max(x,a), b);


