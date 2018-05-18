function combinepdfs()

[fname, pname] = uigetfile([pwd '/*.*'],'Select pdf files:','MultiSelect','on'); 
if isequal(fname,0) || isequal(pname,0); fprintf('No file selected ... Done.\n'); fname = []; return; end

startclock = clock;
fprintf('Combining %g files into ''%s%s%s'':\n',numel(fname),pwd,filesep,'combined pdfs.pdf')
fprintf('\n%s',fname{:})
fprintf('...')
append_pdfs('combined pdfs.pdf',fname{:});
fprintf(' Done (%.1fs)\n',etime(clock,startclock))
