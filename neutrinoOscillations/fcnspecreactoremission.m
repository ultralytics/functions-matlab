% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [ sourceSpectrum ] = fcnspecreactoremission(E)
% E (MeV) i.e. E=[1.8 1.81 ... 11] MeV

%from http://arxiv.org/pdf/1011.3850.pdf
epf = 205; %(MeV) mean energy released per fission
npf = 6; %number of neutrinos emitted per fission
fpg = 6.24E21; %number of fissions per GWth per second
npg = fpg/epf*npf; %number of neutrinos emitted per GWth per second (all energies 0-11MeV)
% emissioncurve = exp(-(0.3125*E+0.25).^2)/2.0523; %the 2.0523 normalizes the curve to 1
secondsperday = 60*60*24;
% sourceSpectrum = secondsperday*npg*emissioncurve; %#/day/GWth
sourceSpectrum = (secondsperday*npg/2.0523) * exp(-(0.3125*E+0.25).^2); %#/day/GWth



% %Step 1 - Shape of Spectrum
% %--------------------------
% spectrum=(1.4075)*exp(-(0.3125.*E+0.25).^2);
% 
% %Note: Normalization error can occur for coarse delta Energy spacing
% %Values will be too high by 0.03% at dE=0.1
% %Values will be too high by 0.13% at dE=0.2
% 
% %Step 2 - Absolute Scaling
% %-------------------------
% %Source: "Nuclear Security Applications of Antineutrino Detectors: Current Capabilities and Future Prospects", A. Bernstein et al, White Paper, 2009
% %Assumes 200MeV per fission and 6 anti-neutrinos (all energies) per fission
% constant=1.872E20;    %anti-neutrinos per Gwth per second
% 
% % %Source: "Undeclared Nuclear Activity Monitoring", R. Reboulleau, T. Lasserre, & G. Mention, The 6th International Workshop on Applied Anti-Neutrino Physics, AAP 2010, Sendai Japan
% % constant=1.9E20;    %anti-neutrinos per GWth per second 
% 
% %Source: "The Double Chooz reactor neutrino experiment", I. Gil-Botella, DISCRETE?08: Symposium on Prospects in the Physics of Discrete, Symmetries,Journal of Physics: Conference Series 171 (2009) 012067
% fraction=2/6;   %Fractional number of anti-neutrinos above 1.8MeV
% 
% spectrum=spectrum*constant*fraction; %Units: number per GWth per second per Energy Bin
% end