% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

%Lifting code from Stephen Dye's fortran:  (nuclear detonation)
%B.Dobbs Feb 13,2010.
function [ xE, return_spec ] = fcnNuke(n_Ebins, E_min, E_max, mass_kg, range, yield, t_min, t_max)
%Using the inputs listed below, (assuming a detecter with %85 efficiency) 
%will result in 2-3 detections in a 'few' seconds according to the 
%Bernstein paper.  This result closely matches the nuke papers.  
%(section 3.1, page 9)

% n_Ebins = 1001;
% E_min = 1.5;
% E_max = 9;
% mass_kg = 1000000000;
% range = 250; %Distance between reactor and detector (in kilometers)
% yield = 10;%ktons
% %Davy Crokett = 0.01-1 kt
% %wwii = 12-22
% %Tsara Bomba = 50,000kt
% t_min = 0;
% t_max = 3; 
% 
% do_osc = 1;
% do_smear = 1;
% [ xE, return_spec ] = fcnNuke(n_Ebins, E_min, E_max, mass_kg, range, yield, t_min, t_max, do_osc, do_smear);
% sum(return_spec)

dE = (E_max - E_min)/(n_Ebins-1);

mass_tons = mass_kg/1000;%tons
mass_kt = mass_tons/1000;%in kilotons
mass_megatons = mass_tons*10^(-6);

%Looks like the LWR (Light water reactor), PWR (Pressurized water reactor),
%using LUE (Low enrichment Uranium) is a very common generator.  (wiki says
%75% are light water reactors.)

%replacing 'power' with unity.  This is a linear scaling factor, and the
%whole spectrum is scaled later, so it should be oK.
[Rn_E, xE, rtot] = fcnNukespectrum(n_Ebins,E_min,dE,mass_kt,range,1);%This should return the actual rates, not just the weighting probability function

%Here we have to figure out the fraction of neut. not accounted for by the
%oscillations.

%Ok, here Rn_E is the total number of aneutrino interaction expected.

%this is the total number of a.n. expected from a nuke blast, including oscillations:
NT = 2.25*yield*mass_megatons*(100/range)^2;
%total of Rn_E
%this was done just to the the correction factor for the oscillations.
%the above total includes oscillations.  
tot = sum(Rn_E);
Rn_E = Rn_E/tot;

%procedure:
%Normalize the regular spectrum (add to 1), then divide it by itself, after
%oscillations.  The sum of the UNoscillated spectrum divided by the sum of
%the OSCILLATED spectrum (at 100 km) will give a factor to multiply det_t by 

%This factor turns out to be 1.70150297273881 for a distance of 100km.

scale_d = 1.70150297273881;
Rn_E = Rn_E*NT*scale_d;

%This should give us the correct spectrum for a nuclear explosion at
%distance, withOUT oscillations.  This is total events, with no time
%dependnacy....

return_spec = Rn_E; 

%From the FORTRAN 
%Ro_E is the energy spectrum expected after oscillation
%P_E (osc, here) is the probability of detection due to oscillation
%Rn_E is the original (unoscillated) energy spectrum 
%so Ro_E = osc.* Rn_E

%range_m = range*1000;    roverxE = (range_m./xE);    fraction = 0.02878679656440357*cos(6.1468*roverxE) + 0.07121320343559644*cos(6.35*roverxE) + 0.3678575741549828*cos(0.2032*roverxE) + 0.5321424258450172;
fraction = fcnnuosc(range, xE);
return_spec = return_spec.*fraction;

%Ro_E is now an neutrino interactions per day at a spectrum of energies.  
%next step is to assign a temporal decay.  I simply used the graph in 
%figure 9.

%accounting for the smear.  This may be an observational phenomena, which
%may change depending on our event capture method.  It should effect the
%PMT, and any conventional imaging scheme.  Might not be relevant in the
%direct gamma observation scheme.


%exponential time decay of neutrino production %ONLY works for this resolution.  
begin_index = (t_min*1000)+1;
end_index = (t_max*1000)+1;

dt = 0.001;
%NOTE: The time range must be 0-10 s to match up with the function.  
t = [0:dt:10];
y = exp(-t/2);
y = y/sum(y);

return_spec = return_spec * sum(y(begin_index:end_index));
