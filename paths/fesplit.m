% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [b,c] = fesplit(a)
%filename and extension split.
%i.e ['test','m'] = fesplit('test.m')

i=find(a=='.',1,'last');

b = a(1:i-1);
c = a(i+1:end);