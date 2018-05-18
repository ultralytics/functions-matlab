function [] = fcncopyaxes(hin,hout)
copyobj(get(hin,'Children'), hout)

%xlabel(hout,    hin.XLabel.String, 'Interpreter', hin.XLabel.Interpreter)
%ylabel(hout,    get(get(hin,'YLabel'),'String'), 'Interpreter', get(get(hin,'YLabel'),'Interpreter'))
%zlabel(hout,    get(get(hin,'ZLabel'),'String'), 'Interpreter', get(get(hin,'ZLabel'),'Interpreter'))
%title(hout,     get(get(hin,'Title'), 'String'), 'Interpreter', get(get(hin,'Title'),'Interpreter'))
xyzlabel(hout,hin.XLabel.String,hin.YLabel.String,hin.ZLabel.String,hin.Title.String);



set(hout, 'XTick', get(hin,'XTick'), 'XTickLabel', get(hin,'XTickLabel'), ...
    'YTick', get(hin,'YTick'), 'YTickLabel', get(hin,'YTickLabel'), ...
    'XGrid', get(hin,'XGrid'), 'YGrid', get(hin,'YGrid'), ...
    'PlotBoxAspectRatio', get(hin,'PlotBoxAspectRatio'), ...
    'PlotBoxAspectRatioMode', get(hin,'PlotBoxAspectRatioMode'), ...
    'DataAspectRatio', get(hin,'DataAspectRatio'), ...
    'DataAspectRatioMode', get(hin,'DataAspectRatioMode'), ...
    'CLim', hin.CLim, ...
    'View', hin.View, ...
    'XLim', hin.XLim, 'XDir', get(hin,'XDir'), 'XScale', get(hin,'XScale'), ...
    'YLim', hin.YLim, 'YDir', get(hin,'YDir'), 'YScale', get(hin,'YScale'), ...
    'ZLim', hin.ZLim, 'ZDir', get(hin,'ZDir'), 'ZScale', get(hin,'ZScale'), ...
    'ALim', hin.ALim, ...
    'XTickMode',hin.XTickMode,'YTickMode',get(hin,'YTickMode'),'ZTickMode',get(hin,'ZTickMode'), ...
    'XTickLabelMode',hin.XTickLabelMode,'YTickLabelMode',get(hin,'YTickLabelMode'),'ZTickLabelMode',get(hin,'ZTickLabelMode'));

hl = legend(hin);
if ~isempty(hl)
    hoc = findobj(hout.Children,'-Property','DisplayName');
    str = hl.String;  na = numel(str);
    dnin = get(hoc,'DisplayName');
    
    a = zeros(na,1);
    for i=1:na
        b=strcmp(str{i},dnin);
        a(i) = find(b);
    end

    hlnew = legend(hoc(a));
    %set(hlnew,'Location',hl.Location)
    set(hlnew,'box',hl.Box,'EdgeColor',hl.EdgeColor)
end


try %#ok<TRYNC>
    fcncontextmenuexpand(hout)
end
end