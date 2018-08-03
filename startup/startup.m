function [] = startup()
%CHANGES USERPATH TO userpath('C:\Users\gjocher\Google Drive\MATLAB') on PC or '/Users/glennjocher/Google Drive/MATLAB/' on mac

%NEW INSTALL ONLY ---------------------------------------------------------
a = mfilename('fullpath');      a = a(1:find(a==filesep,1,'last')); %this file's folder
b = userpath;                   %if b(end)==filesep; b=b(1:end-1); end%current userpath
fprintf('Running %sstartup.m ... ',a)
if ~strcmp(a,b) %new computer or new matlab install   
    fprintf('\nDetected first-time use of this file by this MATLAB install...\nSetting userpath to ''%s''...\n',a)
    userpath(a)
end

%CRASHES MATLAB FOR SOME REASON
c = [a filesep 'functions-matlab'];  addpath(genpath(c))
cd(a);

%opengl('OpenGLWobbleTesselatorBug',1)
%opengl('OpenGLLineSmoothingBug',1)

%set(0,'DefaultAxesLooseInset',[0,0,0,0])
%set(0,'DefaultAxesFontSmoothing','off');
%set(0,'DefaultAxesTitleFontWeight','normal')
set(0,'DefaultFigureColormap',parula(256)); 
%set(0,'DefaultFigureGraphicsSmoothing','off');
%close(gcf);

set(0,'DefaultLineMarkerSize',15)
set(0,'DefaultLineLineWidth',1)

co = [      0        0.447        0.741
         0.85        0.325        0.098
        0.929        0.694        0.125
        0.494        0.184        0.556
        0.466        0.674        0.188
        0.301        0.745        0.933
        0.635        0.078        0.184];
co = [co; .3 .3 .3;     0.7500         0    0.7500];
set(0,'defaultAxesColorOrder',[co; fcnlightencolor(co); co*.7])

format compact
format short g
fprintf('Done.\n')


% %FUNCTIONS SHORTCUT -------------------------------------------------------
% a = userpath;  a = a(1:end-1); %current userpath
% b = [a filesep 'functions'];
% addpath(genpath(b));  cd(b)
% clear a b
% 
% %nSIM SHORTCUT ------------------------------------------------------------
% a = userpath;  a = a(1:end-1); %current userpath
% b = [a filesep 'neutrinos' filesep 'nSimGUI'];
% addpath(genpath(b));  cd(b)
% clear a b
% if ~exist('input','var'); iDND; end
%
% %nView SHORTCUT -----------------------------------------------------------
% a = userpath;  a = a(1:end-1); %current userpath
% b = [a filesep 'neutrinos' filesep 'nViewGUI'];
% addpath(genpath(b));  cd(b)
% clear a b
% if ~exist('handles','var'); nView; end
% 
% %VSM SHORTCUT -------------------------------------------------------------
% a = userpath;  a = a(1:end-1); %current userpath
% b = [a filesep 'VSM'];
% addpath(genpath(b));  cd(b)
% clear a b

a = userpath;  a = a(1:end-1); %current userpath
addpath(genpath([a filesep 'functions']));
addpath(genpath([a filesep 'VSM']));
addpath(genpath([a filesep 'SPEEDTRAP']));
addpath(genpath('/Users/glennjocher/Downloads/DATA/'));
%addpath(genpath([a filesep 'neutrinos' filesep 'nViewGUI']));

addpath(genpath(fullfile(matlabroot,'toolbox','plotly')),'-end');

%TURN OFF WARNINGS:
warning off MATLAB:structOnObject %when converting obj to structure i.e. mystruct=struct(obj) https://undocumentedmatlab.com/blog/accessing-private-object-properties