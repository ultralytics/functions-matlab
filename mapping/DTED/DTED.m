% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function alt = DTED(lat,lon)
%INPUTS: lat (deg -90 to 90), lng (deg -180 to 180)
%OUTPUTS: DTED alt above EGM96 geoid (m). Try 'llag2lla.m' for ellipsoid elevations
%distributed under CC by 4.0 International: https://creativecommons.org/licenses/by/4.0/
%written by Glenn Jocher, 2015, Ultralytics LLC, glenn.jocher@ultralytics.com


%USER SETTINGS ------------------------------------------------------------
DTEDlevel = 2; %DTED level (i.e. 0 (900m postings), 1 (90m postings), 2 (30m postings))
DTEDpath = ''; %DTED folder (i.e. '/Users/glennjocher/MATLAB/functions/mapping/DTED/'). Optional. If empty function downloads .dt2 tiles online
%USER SETTINGS ------------------------------------------------------------


alt = zeros(size(lat));
for i=1:numel(lat)
    if alt(i)~=0; continue; end
    if lat(i)<-56 || lat(i)>60; fprintf('Warning: Requested Coordinate Lies Outside of DTED Coverage Range (-56 to 60 deg Lat)\n'); continue; end
    files = dteds([1 1]*lat(i),[1 1]*lon(i),DTEDlevel);

    f = files{1};  f=f(6:end);  j=find(f=='/');
    folder = f(1:j-1); %longitude folder (i.e. 'w079')
    file = f(j+1:end); %latitude file (i.e. 'n38.dt2')
    
    if isempty(DTEDpath) %find online and save locally
        a = mfilename('fullpath');  a = a(1:find(a=='/',1,'last'));
        lonpath = [a folder filesep]; %local folder to save dted
        if ~exist([lonpath file],'file')
            url = ['http://cloudcapsupport.com/elevation/DTED-Worldwide-30m/' f];  fprintf('Downloading ''%s''...',url) %construct url
            try
                if ~exist(lonpath,'dir'); mkdir(lonpath); end % create folder if necessary
                tic; websave([lonpath file], url);  fprintf(' Done (%.1fs).\n',toc) %download dted file
            catch me
                fprintf('Warning: %s\n',me.message); continue
            end
        end
    else
        lonpath = [DTEDpath folder filesep]; %use local DTEDpath
    end

    [Z, R] = dted([lonpath file]);  n=size(Z,1);
    [latlim,lonlim] = limitm(Z,R);
    [ilat,ilon] = ndgrid(linspace(latlim(1),latlim(2),n), linspace(lonlim(1),lonlim(2),n) );

%     %PLOT
%     R = georasterref('LatitudeLimits', latlim, 'LongitudeLimits', lonlim,'RasterSize', size(Z), 'RasterInterpretation', 'postings'); %postings, not cells
%     worldmap(Z,R); meshm(Z,R,size(Z),Z);

    F = griddedInterpolant(ilat,ilon,Z); %linear interpolant
    j = lat>=latlim(1) & lat<=latlim(2) & lon>=lonlim(1) & lon<=lonlim(2);
    alt(j) = F(lat(j),lon(j));
end













































% files = dteds(minmax(lat(:)'),minmax(lon(:)'),DTEDlevel);
% alt = zeros(size(lat));
% for i=1:numel(files)
%     f = files{i};  f=f(6:end);  j=find(f=='/');
%     folder = f(1:j-1); %longitude folder (i.e. 'w079')
%     file = f(j+1:end); %latitude file (i.e. 'n38.dt2')
%     
%     if isempty(DTEDpath) %find online and save locally
%         a = mfilename('fullpath');  a = a(1:find(a=='/',1,'last'));
%         lonpath = [a folder filesep]; %local folder to save dted
%         if ~exist([lonpath file],'file')
%             url = ['http://cloudcapsupport.com/elevation/DTED-Worldwide-30m/' f];  fprintf('Downloading ''%s''...',url) %construct url
%             try
%                 if ~exist(lonpath,'dir'); mkdir(lonpath); end % create folder if necessary
%                 tic; websave([lonpath file], url);  fprintf(' Done (%.1fs).\n',toc) %download dted file
%             catch me
%                 fprintf('Warning: %s\n',me.message); continue
%             end
%         end
%     else
%         lonpath = [DTEDpath folder filesep]; %use local DTEDpath
%     end
%     
%     [Z, R] = dted([lonpath file]);  n=size(Z,1);
%     [latlim,lonlim] = limitm(Z,R);
%     [ilat,ilon] = ndgrid(linspace(latlim(1),latlim(2),n), linspace(lonlim(1),lonlim(2),n) );
% 
% %     %PLOT
% %     R = georasterref('LatitudeLimits', latlim, 'LongitudeLimits', lonlim,'RasterSize', size(Z), 'RasterInterpretation', 'postings'); %postings, not cells
% %     worldmap(Z,R); meshm(Z,R,size(Z),Z);
% 
%     F = griddedInterpolant(ilat,ilon,Z); %linear interpolant
%     j = lat>=latlim(1) & lat<=latlim(2) & lon>=lonlim(1) & lon<=lonlim(2);
%     alt(j) = F(lat(j),lon(j));
% end

