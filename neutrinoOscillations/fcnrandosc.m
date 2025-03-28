% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [op, s] = fcnrandosc(nr, input, flags)
%[dm^2_12, dm^2_13, sin^2theta12, sin^2theta13];

if flags.status.aprioribackground %apriori
    %s.sl = [  2.6e-006    9e-005      0.016    0.007]; %Original
    %s.su = [  2.2e-006    0.00012     0.017    0.007]; %Original
    %s.sl = [  2.6e-006    9e-005      0.016    0.0038]; %Fogli + Daya Bay 2011
    %s.su = [  2.2e-006    0.00012     0.017    0.0038]; %Fogli + Daya Bay 2011
     s.sl = [  1.8333e-006 0.00020     0.016    0.00235]; %Fogli/Bari + Daya Bay 2012
     s.su = [  2.1333e-006 0.00019     0.017333 0.00210]; %Fogli/Bari + Daya Bay 2012
else %aposteriori
    tsl=[   1.0621e-06   5.0457e-05    0.0074998    0.0014755%ML1 = SNRx100;
            2.0695e-07   1.2179e-05    0.0024938    0.0014271%ML2 = SNRx10;
            1.9487e-07   1.2165e-05    0.0023706    0.0014432%ML3 = SNRx1;
            1.9523e-07   1.1307e-05    0.0024578    0.0014377%ML3x10 = SNR/10;
            1.8524e-07   1.1302e-05    0.0025689    0.0014037%ML3x20 = SNR/20
            1.8091e-07   1.1824e-05     0.002367    0.0014304];    %ML3x30 = SNR/30
    
    tsu=[   1.2135e-06   3.7384e-05    0.0074421    0.0014763%ML1 = SNRx100;
            2.0558e-07   1.1898e-05    0.0026061     0.001364%ML2 = SNRx10;
            2.0425e-07   1.2416e-05     0.002701    0.0014306%ML3 = SNRx1;
            1.9137e-07   1.2334e-05     0.002557    0.0014672%ML3x10 = SNR/10;
            1.9089e-07   1.1892e-05    0.0023888    0.0014327%ML3x20 = SNR/20
            1.8669e-07   1.3082e-05    0.0024707    0.0014039];    %ML3x30 = SNR/30

    s.sl=interp1([0 1/30 1/20 1/10 1 10 100 inf]', tsl([6 6:-1:1 1],:), input.dNoiseMultiplier);
    s.su=interp1([0 1/30 1/20 1/10 1 10 100 inf]', tsu([6 6:-1:1 1],:), input.dNoiseMultiplier);
end

n=100;
s.u = [    7.54e-005   0.00259    0.307    0.02303]; %April 2014
s.lf = zeros(1,4);
op = zeros(nr,4);
s.x = zeros(4,n);
s.pdf = s.x;
for i = 1:4
    x1 = linspace(s.u(i)-s.sl(i)*3, s.u(i)+s.su(i)*3, n);
    vl1 = normpdf(x1(x1<s.u(i)),s.u(i),s.sl(i)); vl1=vl1/max(vl1);
    vu1 = normpdf(x1(x1>=s.u(i)),s.u(i),s.su(i)); vu1=vu1/max(vu1);
    
    v1 = [vl1 vu1];  
    s.lf(i)=sum(vl1)/sum(v1);  %lower fraction
    v1=v1/sum(v1);
    
    s.x(i,:) = x1;
    s.pdf(i,:) = v1;
    op(:,i)=fcnrandcdf(cumsum(v1(:)),x1(:),nr);
end

% fig(2,2,1);
% my = max3(s.pdf);
% sca
% plot(s.x(1,:),s.pdf(1,:)); title(['\Deltam^2_{12}=' num2str(s.u(1)) '^{+' num2str(s.su(1)) '}_{-' num2str(s.sl(1)) '}eV^2']); axis([minmax(s.x(1,:)) 0 my]); plot([s.u(1) s.u(1)],[0 my],'k')
% sca
% plot(s.x(2,:),s.pdf(2,:)); title(['\Deltam^2_{13}=' num2str(s.u(2))  '^{+' num2str(s.su(2)) '}_{-' num2str(s.sl(2)) '}eV^2']); axis([minmax(s.x(2,:)) 0 my]); plot([s.u(2) s.u(2)],[0 my],'k')
% sca
% plot(s.x(3,:),s.pdf(3,:)); title(['sin^2(\theta_{12})=' num2str(s.u(3)) '^{+' num2str(s.su(3)) '}_{-' num2str(s.sl(3)) '}']); axis([minmax(s.x(3,:)) 0 my]); plot([s.u(3) s.u(3)],[0 my],'k')
% sca
% plot(s.x(4,:),s.pdf(4,:)); title(['sin^2(\theta_{13})=' num2str(s.u(4)) '^{+' num2str(s.su(4)) '}_{-' num2str(s.sl(4)) '}']); axis([minmax(s.x(4,:)) 0 my]); plot([s.u(4) s.u(4)],[0 my],'k')
% fcnlinewidth(2)

% clc
% vy = 10:13;
% for i=1:4
%     v1 = systematic.true(:,vy(i))<s.u(i);
%     sl(i) = std(systematic.true( v1,vy(i)) - systematic.est( v1,vy(i)));
%     su(i) = std(systematic.true(~v1,vy(i)) - systematic.est(~v1,vy(i)));
% end
% sl
% su



