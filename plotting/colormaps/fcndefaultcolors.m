function [colormat, colorcell] = fcndefaultcolors(i,n)
%see function c = fcnstr2rgbcolor(c)


if nargin<2;
    if nargin==0
        i=1:8;
    end
    n = max(8,max(i));
end
ni = numel(i);


if n>10
    colormat = hsv(n);
else
%     r = [1 0 0];
%     g = [0 1 0];
%     b = [0 0 1];
%     c = [0 1 1];
%     m = [1 0 1];
%     y = [1 1 0];
%     k = [0 0 0];
%     orange = [1 .8 0];
%     gray = [.7 .7 .7];
%     lr = [1 .5 .5];
%     lg = [.7 1 .7];
%     lb = [.5 .5 1];
%     w = [1 1 1];
%     colormat = [b;r;g;c;m;y;orange;gray;lr;lg;lb;k;w];
    
    colormat = get(groot,'defaultAxesColorOrder'); %CMYK dull colors
end
colormat = colormat(i,:);


colormat = colormat*.9;


if nargout>1 %output in cell format
    colorcell = cell(ni,1);
    for j=1:ni
        colorcell{j} = colormat(j,:);
    end
end


