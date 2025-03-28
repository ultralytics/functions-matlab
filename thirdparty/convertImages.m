% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function []=convertImages()

[fname, pname] = uigetfile([pwd '/*.*'],'Select text file:','MultiSelect','on');
if isequal(fname,0) || isequal(pname,0); fprintf('No file selected ... Done.\n'); A = []; return; end

extension = 'jpg';

if ischar(fname)
    fn = [pname fname];  fnn=fn(1:(find(fn=='.',1,'last')-1));  imshow(fn,'InitialMagnification',100); set(gcf,'color',[1 1 1]);
    export_fig(gcf,'-native','-a1','-q101',sprintf('%s.%s',fnn,extension));
    close(gcf);
else %more than one file
    nf = numel(fname);
    for i=1:nf
        fn = [pname fname{i}];   fnn=fn(1:(find(fn=='.',1,'last')-1));  imshow(fn,'InitialMagnification',100); set(gcf,'color',[1 1 1]);
        export_fig(gcf,'-native','-a1','-q90',sprintf('%s.%s',fnn,extension));
        close(gcf);
    end
end