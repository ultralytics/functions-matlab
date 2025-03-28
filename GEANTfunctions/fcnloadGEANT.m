% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function G = fcnloadGEANT(filename,maxlines)
if nargin<2
    maxlines=1.2E7;   if nargin==0;  filename = [];  end
end

if isempty(filename); filename=evalin('base','input.directory'); end
    
G = fcnloadtextfile(filename,maxlines);
%G.x = double(G.x);

[G.ve,startrow,~,D] = fcnunique(double(G.x(:,1))); %vector of events
G.ne = numel(G.ve); %number of events

endrow=startrow+D-1;
G.ei = [startrow, endrow];

% G.xc=cell(G.ne,1);
% for i=1:G.ne
%     G.xc{i}=G.x(startrow(i):endrow(i),:); 
% end

%2008 BRIAN DOBBS FORMAT
%     [ 1]    '#EventNumber'               
%     [ 2]    'NeutrinoKineticEnergy(MeV)' 
%     [ 3]    'NeutrinoMomentumUnitVectorX'
%     [ 4]    'NeutrinoMomentumUnitVectorY'
%     [ 5]    'NeutrinoMomentumUnitVectorZ'
%     [ 6]    'StepNumber'                 
%     [ 7]    'PDGEncoding'                
%     [ 8]    'TrackID'                    
%     [ 9]    'ParentID'                   
%     [10]    'PreStepPositionX(mm)'       
%     [11]    'PreStepPositionY(mm)'       
%     [12]    'PreStepPositionZ(mm)'       
%     [13]    'PostStepPositionX(mm)'      
%     [14]    'PostStepPositionY(mm)'      
%     [15]    'PostStepPositionZ(mm)'      
%     [16]    'PreStepGlobalTime(ns)'      
%     [17]    'PostStepGlobalTime(ns)'     
%     [18]    'PreStepKineticEnergy(MeV)'  
%     [19]    'PostStepKineticEnergy(MeV)' 
%     [20]    'TotalEnergyDeposit(MeV)'    
%     [21]    'StepLength(mm)'             
%     [22]    'TrackLength(mm)'            
%     [23]    'ProcessType'                
%     [24]    'ProcessSubType'             
%     [25]    'TrackStatus'

%2008 BRIAN DOBBS FORMAT with strings
%     [ 1]    '#EventNumber'               
%     [ 2]    'NeutrinoKineticEnergy(MeV)' 
%     [ 3]    'NeutrinoMomentumUnitVectorX'
%     [ 4]    'NeutrinoMomentumUnitVectorY'
%     [ 5]    'NeutrinoMomentumUnitVectorZ'
%     [ 6]    'StepNumber'                 
%     [ 7]    'ParticleName'               
%     [ 8]    'PDGEncoding'                
%     [ 9]    'TrackID'                    
%     [10]    'ParentID'                   
%     [11]    'PreStepPositionX(mm)'       
%     [12]    'PreStepPositionY(mm)'       
%     [13]    'PreStepPositionZ(mm)'       
%     [14]    'PostStepPositionX(mm)'      
%     [15]    'PostStepPositionY(mm)'      
%     [16]    'PostStepPositionZ(mm)'      
%     [17]    'PreStepGlobalTime(ns)'      
%     [18]    'PostStepGlobalTime(ns)'     
%     [19]    'PreStepKineticEnergy(MeV)'  
%     [20]    'PostStepKineticEnergy(MeV)' 
%     [21]    'TotalEnergyDeposit(MeV)'    
%     [22]    'StepLength(mm)'             
%     [23]    'TrackLength(mm)'            
%     [24]    'ProcessName'                
%     [25]    'ProcessType'                
%     [26]    'ProcessSubType'             
%     [27]    'TrackStatus'   

%MICH FORMAT 2015
%     [ 1]    '#EventNumber'               
%     [ 2]    'PDGEncoding'                
%     [ 3]    'TrackID'                    
%     [ 4]    'ParentID'
%     [ 5]    'PostStepPositionX(mm)'      
%     [ 6]    'PostStepPositionY(mm)'      
%     [ 7]    'PostStepPositionZ(mm)'      
%     [ 8]    'PostStepGlobalTime(ns)'     
%     [ 9]    'PostStepKineticEnergy(MeV)' 
%     [10]    'TotalEnergyDeposit(MeV)'    


%GET OTHER GEANT FILE NAMES -----------------------------------------------
m = 0;
%x = fcnmacstr(ls(pathname));
a = dir(G.pathname);
for i=find([a.isdir]==0 & [a.bytes]>0)
    if numel(a(i).name)<5; continue; end
    str1 = deblank(a(i).name);  %remove trailing whitespace
    str2 = str1(max(end-3,1):end);
    if strcmp(str2,'.dat') || strcmp(str2,'.txt') || strcmp(str2,'.csv') %add other files too!
        m=m+1;
        G.files.names{m} = str1;
    end
end
G.particleName = '';
if regexpi(G.filename,'gamma'); G.particleName='Gamma'; end
if regexpi(G.filename,'neutron'); G.particleName='Neutron'; end
if regexpi(G.filename,'muon'); G.particleName='Muon'; end
if regexpi(G.filename,'neutrino'); G.particleName='Neutrino'; end
if regexpi(G.filename,'antineutrino'); G.particleName='Antineutrino'; end
if regexpi(G.filename,'point source'); G.particleName='PointSource'; end
if regexpi(G.filename,'line source'); G.particleName='LineSource'; end

try %#ok<TRYNC>
    h = evalin('base','handles.GUI.popupmenu1');
    set(h,'string',G.files.names);
    set(h,'value',find(strcmp(G.filename,G.files.names)));
    
    h=evalin('base','handles.GUI.checkbox52');
    a=regexpi(G.filename,{'gamma','muon','neutron','line'});
    if any([a{:}])
        h.Value=1;
    else
        h.Value=0;
    end
end
end

