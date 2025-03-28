% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function F = lowPassFilter(passband,stopband,sps)
if nargin==0
    passband = 60E6; % (Hz)  
    stopband = 200E6; % (Hz)
    sps = 5E9; % (Hz) samples per second
end

%F = designfilt('lowpassiir','FilterOrder',3,'SampleRate',sps,'StopbandFrequency',200E6,'StopbandAttenuation',3);   
F=designfilt('lowpassiir', 'PassbandFrequency', passband,'StopbandFrequency', stopband,'PassbandRipple',.01,'StopbandAttenuation',3,'SampleRate',sps,'MatchExactly','stopband'); 


%a=output(1).D; a=a(:,a,1,1)
a=[ 0, 0, 0, 0, 9.77e-4, 9.77e-4, 0, 0, 0, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9.77e-4, 0, 9.77e-4, 9.77e-4, 0, 0, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 0.00195, 0.00293, 0.00293, 0.00488, 0.00488, 0.00586, 0.00684, 0.00781, 0.00977, 0.0127, 0.0146, 0.0156, 0.0186, 0.0195, 0.0215, 0.0225, 0.0225, 0.0234, 0.0244, 0.0254, 0.0273, 0.0283, 0.0303, 0.0322, 0.0342, 0.0361, 0.0371, 0.0371, 0.0381, 0.0361, 0.0352, 0.0342, 0.0312, 0.0293, 0.0273, 0.0254, 0.0225, 0.0195, 0.0176, 0.0156, 0.0127, 0.00977, 0.00781, 0.00586, 0.00488, 0.00293, 9.77e-4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9.77e-4, 9.77e-4, 9.77e-4, 0, 0, 0, 0, 0, 0, 0, 0, -9.77e-4, -9.77e-4, -9.77e-4, -9.77e-4, 0, -9.77e-4, -9.77e-4, -9.77e-4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9.77e-4, 0, 0, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 0, 0, 0, 9.77e-4, 9.77e-4, 0, 9.77e-4, 0, 0, 9.77e-4, 9.77e-4, 9.77e-4, 0.00195, 9.77e-4, 9.77e-4, 0.00195, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 0.00195, 0.00195, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 0, 0, 0, 0, -9.77e-4, -9.77e-4, -9.77e-4, -9.77e-4, -9.77e-4, -9.77e-4, -9.77e-4, -9.77e-4, -9.77e-4, -9.77e-4, -9.77e-4, 0, 0, 9.77e-4, 9.77e-4, 0, 9.77e-4, 0, 0, 0, 0, 9.77e-4, 0, 9.77e-4, 0, 9.77e-4, 9.77e-4, 0.00195, 0.00195, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 0, 0, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 9.77e-4, 0, 0];
a=a./max(a); %normalize
na=numel(a); x=1:na;  stepx=zeros(na,1); stepx(round(na*.1):end)=1;
b=filter(F,a);

%str = sprintf('%gMHz Passband - %gMHz Stopband Lowpass IIR',passband/1E6,stopband/1E6);

hf=fvtool(F);  hfc=hf.Children(end);
ha=fig(1,3,'9.5x28.5cm');
sca; h=ha(1); fcncopyaxes(hfc,h); fcnlinewidth(h,2); h.YLim=[-3 0]; xd=h.Children(2).XData; yd=h.Children(2).YData; i=find(yd>-3,1,'last'); h.XLim=[0 xd(i)*1.01];


%h=legend('show','Location','SouthWest');  h.String{2}=str; h.String{1}='Response';
sca; plot(x,stepx,'.-','DisplayName','Step Input'); plot(x,filter(F,stepx),'.-','DisplayName','Filter Response'); legend('show','Location','best'); xyzlabel('T (sample)','V')
sca; plot(x,a,'.-','DisplayName',sprintf('%g GSPS Pulse',sps/1E9)); plot(x,b,'.-','DisplayName','Filter Response'); legend('show','Location','best'); xyzlabel('T (sample)','V')
fcntight(ha(2:3)); fcnfontsize(14)
end

