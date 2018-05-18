function ha = fcn4view(h,str,hscale)
if nargin==0; h=gca; end
if nargin<3; hscale = 2; end

ha = fig(2,2,hscale);
popoutsubplot(h,ha(1)); fcnview(ha(1),'skew')
popoutsubplot(h,ha(2)); fcnview(ha(2),'top')
popoutsubplot(h,ha(3)); fcnview(ha(3),'left')
popoutsubplot(h,ha(4)); fcnview(ha(4),'back')


if nargin>1
    if regexpi(str,'title')
        title(ha(1),'skew')
        title(ha(2),'top')
        title(ha(3),'left')
        title(ha(4),'back')
   end
end