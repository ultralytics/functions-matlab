% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [ffty, f, w] = fcnfft(y,t,plotflag)
if nargin==1
    t = 0:numel(y)-1;
    plotflag = 0;
elseif nargin==2
    plotflag = 0;
end

dt = t(2)-t(1);
NFFT = numel(t);
frequency=1/dt;
df=frequency/NFFT;
f=(0:NFFT/2-1)*df;
w=1./f;

ffty = fft(y-mean(y))*2/NFFT; %fy1=fft(y)*2/NFFT;
ffty = abs(ffty(1:NFFT/2));

if plotflag
    h=fig(1,3,1.5);
    sca(h(1));  plot(t,y); xlabel('Signal (samples)');
    sca(h(2));  plot(f,ffty); xlabel('FFT - Frequency (1/samples)'); ylabel('response');
    sca(h(3));  plot(w,ffty); xlabel('FFT - Wavelength (samples)'); ylabel('response');
    fcntight('xy')
end





% clc; close all
% t=linspace(4,4.5,300);  dt = t(2)-t(1);  NFFT = numel(t);
% y=sin(2*pi*10*t)+2*sin(2*pi*50*t)+1.1; %10Hz and 5Hz
% 
% Fs = 1/dt;
% 
% h=fig(4,1,3,1);
% sca(h(1));  plot(t,y); xlabel('time (s)'); title ('signal'); grid
% sca(h(2));  [y1,f1,w1] = fcnfft(y,t);  plot(f1,y1,'.-'); xlabel('frequency (Hz)'); ylabel('response'); title('fft'); grid
% sca(h(3));  [y1, f1] = pwelch(y-mean(y),[],[],[],Fs);  plot(f1,y1,'g')% Uses default window, overlap & NFFT. 
% sca(h(4));
% 
% N = length(y);
% xdft = fft(y-mean(y));
% xdft = xdft(1:N/2+1);
% psdx = (1/(Fs*N)).*abs(xdft).^2;
% psdx(2:end-1) = 2*psdx(2:end-1);
% freq = 0:Fs/length(y):Fs/2;
% plot(freq,10*log10(psdx)); grid on;
% title('Periodogram Using FFT');
% xlabel('Frequency (Hz)'); ylabel('Power/Frequency (dB/Hz)');
% 
% fcntight(h(2:end),'jointx')

