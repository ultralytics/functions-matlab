% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function hObject = fcncheckuncheck(hObject)
if ischecked(hObject)
    hObject.Checked='off';
else
    hObject.Checked='on';
end
