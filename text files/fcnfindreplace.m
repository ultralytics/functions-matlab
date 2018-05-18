function [] = fcnfindreplace(oldstr, newstr, folder, optionalExtension)
%find and replace in all files in ALL folder and subfolders
%extension (Optional) = '.kml' or '.txt' 
%EXAMPLE: fcnfindreplace('input.fluid.remean','input.volume(1).mu(4)',pwd,'.kml')
if nargin<3 || isempty(folder); a = genpath(pwd); else a=folder; end %if no folder specified, use current folder (and subfolders)
extensionFlag = nargin==4;


i = find(a==':');  n=numel(i);  paths=cell(n,1); i=[1 i];
for j=1:n
    paths{j} = a(i(j):i(j+1));
end
paths=strrep(paths,':','');

m = zeros(n,1);
for i = 1:n
    fprintf('%g/%g directories...',i,n)
    a = [paths{i} filesep];
    
    if extensionFlag
        A=dir(a); k=0; b=[];
        for j=1:numel(A);
            if strfind(A(j).name,optionalExtension); k=k+1; b{k}=A(j).name; end %ANY TYPE OF FILE
        end
    else
        b = what(a);  b = b.m; % M-FILE ONLY
    end
    
    
    for j = 1:numel(b)
        fidr  = fopen([a b{j}], 'r'); %read text
        filetext = fscanf(fidr,'%c');
        fclose(fidr);
        
        %filetextnew = strrep(filetext, oldstr, oldstr); %change text
        filetextnew = regexprep(filetext,oldstr,newstr);
        
        if ~strcmp(filetext,filetextnew)
            m(i)=m(i)+1;
            fidw = fopen([a b{j}], 'w'); %write text
            fprintf(fidw, '%c', filetextnew);
            fclose(fidw);
        end
    end
    fprintf('%g updated files\n',m(i))
end
fprintf('Updated %g files total\n',sum(m))


