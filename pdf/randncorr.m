% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [X] = randncorr(ns,T)
%ns = number of samples [streams, samples], i.e. ns=[1 256]
%T = autocorrelation constant (in samples), i.e. T=20
%http://www.atmos.washington.edu/~dennis/552_Notes_6a.pdf
%ns = [10 256];  T = 20;

s = 1; %sigma, noise amplitude
t = 1:ns(2);  dt=t(2)-t(1);

X = zeros(ns);
a = exp(-dt/T);
Q = 1-a^2;
randnum = randn(ns);

w = (s*sqrt(Q)) * randnum; %sqrtm(Q) if 2x2 or bigger!
X(:,1) = s*randn(ns(1),1);

for i=2:ns(2)
    X(:,i) = X(:,i-1)*a + w(:,i);
end

%figure; plot(t(1:128),X3(1:3,1:128)); axis tight; grid('on'); xlabel('sample')
return


% %focus point position wander ----------------------------------------------
% B1 = 1/100; %seconds
% B2 = 1/1; %seconds
% 
% [s2, P0] = KF2_simple_baseline_april_10_2012_init_cov(1/B1, 1/B2, focuspointwander); %meters
% s1 = 0*s2/2; %deg/s
% [Phi, Q] = fcngetPhiQ(s1,s2,B1,B2,dt);
% wfpw = sqrtm(Q)*randn(2,ni);
% Xfpw = zeros(2,ni);
% 
% %propagate X and P --------------------------------------------------------
% Phi(1,2) = 0;
% Phi(2,2) = 0;
% Phi
% for i=2:ni
%     Xfpw(:,i) = Phi*Xfpw(:,i-1) + wfpw(:,i);
% end
% X = Xfpw;%(1,:)';
% close all; fig; plot(1:ni,X); legend('1','2')
end


% function [Phi2, Q2] = fcngetPhiQ(s1,s2,B1,B2,dt)
% zm = zeros(2);
% Phi2 = [ exp(-B1*dt)                      (B2-B1)^-1*(exp(-B1*dt)-exp(-B2*dt))
%         0                                 exp(-B2*dt)                                 ];
% 
% 
% Q2 = zm;
% Q2(1,1) = s2^2*(B2-B1)^-2*(.5*B1^-1*(1-exp(-2*B1*dt))+.5*B2^-1*(1-exp(-2*B2*dt))-2*(B1+B2)^-1*(1-exp(-(B1+B2)*dt)))  +  s1^2*.5*B1^-1*(1-exp(-2*B1*dt));
% Q2(1,2) = s2^2*(B2-B1)^-1*((B1+B2)^-1*(1-exp(-(B1+B2)*dt)) - .5*B2^-1*(1-exp(-2*B2*dt)));
% Q2(2,1) = Q2(1,2);
% Q2(2,2) = s2^2*.5*B2^-1*(1-exp(-2*B2*dt));
% end
% 
% 
% 
% function [ sigma_w2, cov_init ] = KF2_simple_baseline_april_10_2012_init_cov( T1, T2, sigma_offset )
% 
% B1=1/T1;
% B2=1/T2;
% 
% cov_init=zeros(2,2);
% 
% k11=(B2-B1)^-2*(0.5/B1+0.5/B2-2/(B1+B2));
% k22=0.5/B2;
% k12=(B2-B1)^-1*(1/(B1+B2)-0.5/B2);
% 
% sigma_w2=sigma_offset/sqrt(k11);
% 
% cov_init(1,1)=sigma_w2^2*k11;
% cov_init(2,2)=sigma_w2^2*k22;
% cov_init(1,2)=sigma_w2^2*k12;
% cov_init(2,1)=cov_init(1,2);
% end
