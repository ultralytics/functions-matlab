% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [r,c] = fcnind2sub(s,i)
% i = [ 1   3
%       2   4 ];

% r = [ 1   1       c = [  1    2
%       2   2 ];           1    2 ];
        

c = ceil(i/s(1));
r = i - (c-1)*s(1);
