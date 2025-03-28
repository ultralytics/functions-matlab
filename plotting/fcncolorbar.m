% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [] = fcncolorbar(alpha,units,hf)
%sets colorbar units and transparency (1=not transparent, 0=transparent);

if nargin<3
    h = findobj(gcf, 'Tag', 'Colorbar');
else
    if strcmp(get(hf,'type'),'figure')
       h = findobj(hf, 'Tag', 'Colorbar');
    else %hf=colorbar handle
       h = hf;
    end
end

if isempty(alpha)
    alpha=1;
end
updateunits=true;
if nargin<2 || isempty(units) || strcmp(units,'')
    updateunits=false;
end


for i = 1:numel(h);
    hc = get(h(i),'Children'); set(hc,'AlphaData',alpha);
    
    strmat = get(h(i),'YTickLabel');
    if ~isempty(strmat) && updateunits==true;
        x = str2double(strmat); %str2num
        for j = 1:numel(get(h(i),'YTick'))
            strmat{j} = [num2str(x(j)) units];
        end
        set(h(i),'YTickLabel',strmat)
    end
end

%LOG10 scale!
%h=colorbar; h.FontSize=30; set(h,'yticklabel',num2str(str2double(get(h,'yticklabel')),'10^{%g}'))
%h.Color = [1 1 1]*.45;  colormap(jet(256)); h.Position(3) = 0.03;