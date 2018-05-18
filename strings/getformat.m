function [str, nn, vn, ns, vs] = getformat(fid)
%returns format string of text file, i.e. str='%f%f%s%f';
%nn = number of number columns
%vn = vector of number columns
%ns = number of string columns
%vs = vector of string columns

pos = ftell(fid);
a = textscan(fgetl(fid),'%s'); b=a{1};  n2=numel(b);
numeric = false(1,n2);  str = cell(1,n2);

for i=1:n2
    try  j=eval(b{i}); numeric(i)=true; end %#ok<NASGU> %only works for numbers!
end
str(numeric)={'%f32'};
str(~numeric)={'%s'};  % '%*s' to skip string

str = [str{:}];
vn = find(numeric); %vector of numeric columns
nn = numel(vn); %number of numeric columns
vs = find(~numeric); %vector of string columns
ns = numel(vs); %number of string columns
fseek(fid,pos,'bof'); %return pointer to original location
