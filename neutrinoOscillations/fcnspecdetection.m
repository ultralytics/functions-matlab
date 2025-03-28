% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function val = fcnspecdetection(E)
%detection cross section
%E in MeV
%val = (MeV-1.43).^2; %simple version

%mp=938.272013; %mass proton
%mn=939.565560; %mass neutron
%me=0.510998910; %mass electron
%val = real(0.0952.*(E-mn+mp).*sqrt((E-mn+mp).^2-me.^2))*(1E-42); %cm^2
val = (1E-42)*real((0.0952*E - 0.12314567439999900670954957604408).*sqrt((E - 1.2935469999999895662767812609673).^2 - 0.26111988602118807456520244159037)); %cm^2/p^+
%vpa(val)

val(val<0)=0; %only needed when E<1.8MeV!
