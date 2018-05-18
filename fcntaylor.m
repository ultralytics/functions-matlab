function y = fcntaylor(F,order)
%fifth order taylor series expansion
%for EKF, Phi=exp(A*dt)=fcntaylor(A*dt), where A is the continuous (state-space) version of Phi

y = eye(size(F)) + F + F^2/2 + F^3/6 + F^4/24 + F^5/120;

if nargin==2 && order>5
    for i=6:order
       y = y + F^i/factorial(i); 
    end
end
end

