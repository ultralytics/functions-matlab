% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function c = fcnstr2rgbcolor(c)
%  converts string 'r','g' etc to rgb triple
% see also fcnrgbcolor2str

if ischar(c)
    switch c
        case 'r'
            c = [1 0 0];
        case 'g'
            c = [0 1 0];
        case 'b'
            c = [0 0 1];
        case 'c'
            c = [0 1 1];
        case 'm'
            c = [1 0 1];
        case 'y'
            c = [1 1 0];
        case 'k'
            c = [0 0 0];
        case 'w'
            c = [1 1 1];
    end
end
