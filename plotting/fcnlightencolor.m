% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function b = fcnlightencolor(a,x)
%a = input colors as cell or nx3 matrix
%x = optional lightening amount (0 to 1), default = .7
%negative lightening darkens the colors (0 to -1)

if nargin==1
    x = .7;
end


if x>0
    lighten = true;
else %darken
    lighten = false;
end

if iscell(a)
    b = cell(size(a));
    for i = 1:numel(a)
        c = fcnstr2rgbcolor(a{i});
        b{i} = c + (1-c)*x;
        if lighten;
            b{i} = c + (1-c)*x;
        else %darken
            b{i} = c*(1+x);
        end
    end
else
    na = size(a,1);
    b = zeros(na,3);
    for i = 1:na
        c = fcnstr2rgbcolor(a(i,:));
        if lighten
            b(i,:) = c + (1-c)*x;
        else %darken
            b(i,:) = c*(1+x);
        end
    end
end
end



