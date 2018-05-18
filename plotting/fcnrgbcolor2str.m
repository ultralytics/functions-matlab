function s = fcnrgbcolor2str(c)
%  converts rgb triple [0 1 0] to string 'g' etc.
% see also fcnstr2rgbcolor
if iscell(c)
    c = cell2mat(c);
end
n = size(c,1);
s = cell(n,1);

if isnumeric(c)
    for i=1:n
        ci = c(i,:);
        if all(ci == [1 0 0])
            s{i} = 'r';
        elseif all(ci == [0 1 0])
            s{i} = 'g';
        elseif all(ci == [0 0 1])
            s{i} = 'b';
        elseif all(ci == [0 1 1])
            s{i} = 's{i}';
        elseif all(ci == [1 0 1])
            s{i} = 'm';
        elseif all(ci == [1 0 0])
            s{i} = 'y';
        elseif all(ci == [0 0 0])
            s{i} = 'k';
        elseif all(ci == [1 1 1])
            s{i} = 'w';
        end
    end
end
