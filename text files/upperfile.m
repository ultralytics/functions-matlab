function [] = upperfile()

[fname, pname] = uigetfile('*.*','Select text file:',fcnlastfileloaded()); 
fid=fopen([pname fname]);
fie=fopen([pname fname '.upper'],'w+t','n');

while ~feof(fid)
   str=[upper(fgetl(fid)) '\n']; 
   fprintf(fie, str, 'char');
end
fclose(fid);
fclose(fie);

movefile([pname, fname],[pname, fname '.original'])
movefile([pname, fname '.upper'],[pname, fname])


end

