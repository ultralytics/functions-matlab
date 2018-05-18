function [] = fcncontextmenuexpand(h0)
%h0 = handle that a right click will instigate a context menu to open
%h2 = the axes that will open up larger in a new figure
if nargin==0
   h0=gcf; 
end

a = uicontextmenu;

uimenu(a,'Label', 'Resize Large',            'Callback', 'hf=gcf; hf.Position(3:4)=[19 19]*1.5; clear hf');
uimenu(a,'Label', 'Resize Medium',           'Callback', 'hf=gcf; hf.Position(3:4)=[19 19]*1; clear hf')
uimenu(a,'Label', 'Resize Small',            'Callback', 'hf=gcf; hf.Position(3:4)=[19 19]*.75; clear hf')
uimenu(a,'Label', 'Resize Very Small',       'Callback', 'hf=gcf; hf.Position(3:4)=[19 19]*.5; clear hf')


uimenu(a,'Label', 'Popout',                  'Callback', 'popoutsubplot(gca)','Separator','on');
uimenu(a,'Label', 'Copy Axes Here',          'Callback', 'cla; popoutsubplot([],gca)');
uimenu(a,'Label', 'Toggle Axes',             'Callback', 'if strcmp(get(gca,''Visible''),''off''); axis on; else; axis off; end');
uimenu(a,'Label', 'Match Axes (all to this one)',   'Callback', 'fcnmatchlims(gca)');
uimenu(a,'Label', 'Match Axes (one to this one)',   'Callback', 'ha=gca; pause; fcnmatchlims(ha,gca)');

uimenu(a,'Label', 'View Left',               'Callback', 'fcnrotateaxes(gca,[180  0])','Separator','on');
uimenu(a,'Label', 'View Right',              'Callback', 'fcnrotateaxes(gca,[0 0])');
uimenu(a,'Label', 'View Back',               'Callback', 'fcnrotateaxes(gca,[-90  0])');
uimenu(a,'Label', 'View Top',                'Callback', 'fcnrotateaxes(gca,[-90 90])');
uimenu(a,'Label', 'View Skew',               'Callback', 'fcnrotateaxes(gca,[150 20])');
uimenu(a,'Label', '4 View',                  'Callback', 'fcn4view(gca)');
uimenu(a,'Label', 'View NED format',         'Callback', 'set(gca,''xdir'',''normal'',''ydir'',''reverse'',''zdir'',''reverse'')');
uimenu(a,'Label', 'View 2:1',                'Callback', 'fcnfigaspectratio(gcf,2,1)');
uimenu(a,'Label', 'View 4:3',                'Callback', 'fcnfigaspectratio(gcf,4,3)');
uimenu(a,'Label', 'View 16:9',               'Callback', 'fcnfigaspectratio(gcf,16,9)');

uimenu(a,'Label', 'Rotate 360',              'Callback', 'axis vis3d; [az, el] = view;  fcnrotateaxes(gca,[az+360 el],500); axis normal image;');

uimenu(a,'Label', 'exported.jpg',            'Callback', 'rea; export_fig(gcf,''-q90'',''-r200'',''-a1'',fcnincrementfname(''f0.jpg''))','Separator','on');
uimenu(a,'Label', 'exported.png',            'Callback', 'rea; export_fig(gcf,''-q90'',''-r200'',''-a1'',fcnincrementfname(''f0.png''))');


%for i=1:numel(h0)
    ha = findobj(h0,'type','axes','-and','Type','axes');
    set(ha,'uicontextmenu',a);
%end
