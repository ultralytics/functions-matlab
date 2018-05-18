function [ha, hf] = fig(nr,nc,hscale,wscale,border)
%example:
%fig(2,1,1.5,1);
%fig(1,1,'9x9cm');
%fig(1,1,'9cm','18cm');
%fig(1,1,'9cm')
%[ha,hf]=fig; hf.Units='pixels'; hf.Position(3:4) = [1920 1080];

switch nargin
    case 0
        nc = 1;
        nr = 1;
        hc = 9.5*2*.75; %centimeters in height (default to 'small')
        wc = 9.5*2*.75; %centimeters in width
    case 2
        hc = 9.5*nr;
        wc = 9.5*nc;
    case 3
        if isempty(hscale)
            hc = 9.5*nr;
            wc = 9.5*nc;
        elseif ischar(hscale)
            if any(hscale=='x') %'9x9cm'
                gs=regexpi(hscale,'(.+)x(.+)cm','tokens');  gs=gs{1};  hc=eval(gs{1});  wc=eval(gs{2});
            else
                gs=regexpi(hscale,'(.+)cm','tokens');  gs=gs{1};  hc=eval(gs{1});
                wc=hc;
            end
        else
            hc = 9.5*nr*hscale;
            wc = 9.5*nc*hscale;
        end
    case {4, 5}
        if isempty(hscale)
            hc = 9.5*nr;
            wc = 9.5*nc;
        elseif ischar(hscale)
            gs=regexpi(hscale,'(.+)cm','tokens');  gs=gs{1};  hc=eval(gs{1});
            gs=regexpi(wscale,'(.+)cm','tokens');  gs=gs{1};  wc=eval(gs{1});
        else
            hc = 9.5*nr*hscale;
            wc = 9.5*nc*wscale;
        end
end



cp = [2.5 .2 wc hc]; %position centimeters
hf = figure; 
hf.Color=[1 1 1]; hf.Units='centimeters'; hf.Position=cp;

sh = 2; %spacing horizontal
sv = 2; %spacing vertical

lb = 1.9; %left border
rb = 0.9; %right border
bb = 1.9; %bottom border
tb = 1.2; %top border

%border = [2, 2, 1.9, 0.9, 1.9, 1.2];
%border = [spacingHoriztontal, spacingVertical, leftBorder, rightBorder, bottomBorder, topBorder];
if nargin==5; sh=border(1); sv=border(2); lb=border(3); rb=border(4); bb=border(5); tb=border(6); end


h = (hc - tb - bb - sv*(nr-1))/nr; %height
w = (wc - lb - rb - sh*(nc-1))/nc; %width

k = 0;
ha = gobjects(1,nr*nc);
for r=1:nr
    for c=1:nc
        k = k + 1;
        pos = [lb+(w+sh)*(c-1),  bb+(h+sv)*(nr-r),  w,  h];
        posn = [pos(1)/wc pos(2)/hc pos(3)/wc pos(4)/hc];
        ha(k) = axes('position',posn);
        ha(k).NextPlot='add';
        grid(ha(k),'on')
        %ha(k).XLabel.VerticalAlignment='bottom';
    end
end
%colormap(hf,jet(256));
fcncontextmenuexpand(hf);
if ismac; fcnfontsize(12); else fcnfontsize(8); end
sca(ha(1));
