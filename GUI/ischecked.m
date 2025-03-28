% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function a = ischecked(h)
%'true' if a checkbox is checked: get(h,'checked')=='on' 
%'false' otherwise: get(h,'checked')=='off'
%a = numel(get(h,'checked'))==2; %'on'

if islogical(h)
    a=h;
elseif isgraphics(h)
	a=strcmp(h.Checked,'on');
else
    disp('WARNING: ischecked called inappropriately ---------------------------')
    a=evalin('caller',sprintf('strcmp(get(%.16f,''checked''),''on'');',h));
end
