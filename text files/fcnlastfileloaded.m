function pf = fcnlastfileloaded(pf)
if nargin==0; pf=''; end
pfs = [tempdir 'lastTextFileLoaded.txt'];

if exist(pf,'file')==2 %if file exists, save it to txt
    f = fopen(pfs, 'w+');
    fseek(f, 1024, 'bof');
    fwrite(f,pf,'char');
    fclose(f);
else %if no file exists, return last saved
    f = fopen(pfs, 'r+');  if f==-1; pf=''; return; end
    pf = fread(f,1024,'uint8=>char')';
    fclose(f);
end

% %EXAMPLE
%p='/Users/glennjocher/Downloads/';
%f='2017.3.2.SngFib.Sr90.col2.dat.mat';
%pf=[p f];