function str = waitbarParfor(N)
if nargin>0 && N>0
    parfor_progress(N);
    return;
end


% hw=findall(0,'Tag','TMWWaitbar'); 
% if isempty(hw)
%      hw=waitbar(0,'Please wait...');
% end


[pc,te,progress,todo] = parfor_progress();  tl=(100-pc)/pc*te; %percentComplete, timeElapsed, timeLeft
[tl,tlu]=timeUnits(tl);
[te,teu]=timeUnits(te);

str = sprintf('%3.1f%% Complete (%g/%g), %3.1f %s Elapsed, %3.1f %s Left',pc,progress,todo,te,teu,tl,tlu);
%waitbar(pc/100,hw);


end


function [t,u]=timeUnits(t)
if t<60
    u='s';
elseif t<3600
    t=t/60;
    u='minutes';
elseif t<86400
    t=t/3600;
    u='hours';
else
    t=t/86400;
    u='days';
end
end


function [percent, elapsedTime,progress,todo] = parfor_progress(N)
if nargin < 1
    N = -1;
end
%fname = fullfile(tempdir,'parfor_progress.bin');
fname = [tempdir 'parfor_progress.bin'];

percent = 0;
elapsedTime = 0;


if N > 0
    f = fopen(fname, 'w');
    if f<0
        error('Do you have write permissions for %s?', pwd);
    end
    fwrite(f,N,'uint32');
    fwrite(f,0,'uint32');
    fwrite(f,posixtime(datetime),'uint32');
    fclose(f);
    
    progress = 0;
    todo = N;
else
    %if ~exist(fname, 'file')
    %    error('parfor_progress.bin not found. Run PARFOR_PROGRESS(N) before PARFOR_PROGRESS to initialize parfor_progress.bin.');
    %end
    
    f = fopen(fname, 'r+');
    A = fread(f,3,'uint32');
    todo = A(1);
    progress = A(2) + 1;
    elapsedTime = posixtime(datetime)-A(3);
    fseek(f, 4, 'bof');
    fwrite(f,progress,'uint32');
    fclose(f);
    
    percent = progress/todo * 100;
    
    if N==0;
         delete(fname);
    end
end

end

