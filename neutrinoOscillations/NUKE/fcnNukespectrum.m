function [rate, rateX, rtot] = fcnNukespectrum(n_Ebins, E_min, dE, mass, distance, power)
%*  uses fitted function to rate calculations for 10kilotons at 50km from San Onofre/year/MeV
%*  call with number of energy bins bins, E_min/EmV, dE/MeV and array rate(n_Ebins)

rate = zeros(1,n_Ebins);
rateX = zeros(1,n_Ebins);

%c	data rr0/4.25E7/ ! normalizing rate.. not right, change units.
%	data rr0/8.50E3/ ! normalizing rate
rr0 = 8.5e3;
%	data E1/0.8/    ! MeV
E1 = 0.8;
%	data E2/1.43/   ! MeV
E2 = 1.43;
%	data E3/3.2/    ! MeV
E3 = 3.2;

%* rescale rate for this run
r0 = rr0*(mass/10.0) ; % scaled from 10 kilotons
r0 = r0*(50.0/distance)^2; % scaled to distance from 50 km
r0 = r0*(power/7.0) ;% scale to San Onofre nominal power in GW

ie = 1:n_Ebins;
E = E_min + (ie-1)*dE;
rateX(ie) = E;

v1 = find(E>1.8 & E<10);
rate(v1) = r0*(E(v1)-E2).^2.*exp(-((E(v1)+E1)/E3).^2)*dE;
rtot = sum(rate);
end

%	print *,' spectrum called with E_min = ',E_min,' MeV'
%	print *,'   total rate = ',rtot,'/yr'
%	print *,'   with detector mass = ',mass,' kilotons'
%	print *,'   distance = ',distance,' km'
%	print *,'   and power = ',power,' GWt'