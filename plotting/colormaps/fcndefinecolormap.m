function cmap = fcndefinecolormap(colors)
%colors = [rgb1; ... rgbn]; %[nx3]
c = colors;

if nargin==0 %get colors from image
    [fname, pathname] = uigetfile({'*.*',  'All Files (*.*)'}, ...
        'Pick an image file to copy colormap from', ...
        'MultiSelect', 'off');
    
    cdata = imread([pathname fname]);
    imshow(cdata)
    
    c = zeros(1,1:3);
    for i=1:100
        [x, y, button]=ginput(1);
        if button~=1; break; end
        c(i,1:3) = cdata(y,x,:);
    end
    c = double(c);
    close(gcf);
end

if iscell(c)
    for i=1:numel(c)
        c{i} = fcnstr2rgbcolor(c{i});
    end
    c=cell2mat(c(:));
end


n = size(c,1);
c = c/max3(c);

x = linspace(1,256,n);
xi = 1:256;
cmap = interp1(x,c,xi,'linear'); %64x3




% colors = [0 0 1; 0 1 1; 0 1 0; 1 1 0; 1 .5 0; 1 0 0; 1 0 1];
% cmap = fcndefinecolormap(colors)
% colormap(cmap)