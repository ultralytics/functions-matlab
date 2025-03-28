% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function c = extension(a)
%returns file extension

i=find(a=='.',1,'last');
c = a(i+1:end);