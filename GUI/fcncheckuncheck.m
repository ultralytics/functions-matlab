function hObject = fcncheckuncheck(hObject)
if ischecked(hObject)
    hObject.Checked='off';
else
    hObject.Checked='on';
end
