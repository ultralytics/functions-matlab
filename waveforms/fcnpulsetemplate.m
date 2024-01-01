function [template,h]=fcnpulsetemplate(y,t)
% y are waveforms (nr samples by nc waveforms, i.e. 256x30000)
% t are alignment points for each waveform, i.e. 1x30000

[nr,nc]=size(y);
that = single(1:nr) - single(t);
timem=single(0:nr-1)-round(nr/2); %monotonic 5 GSPS time vector
T = zeros(1,nr,'single');
a=max(y,[],1);
%y=y./a;
for i=1:nc
    %Ti = interp1cfloat(that(i,:),y(:,i),timem);
    Ti = interp1(that(i,:),y(:,i),timem);
    Ti(~isfinite(Ti))=0;
    T=T+Ti;
end
template = double(T)/nc;  %template=double(T/max(T));
mt=max(template);

if mt>0
    rt = risetime(template,'StateLevels',[0 mt]);
    pw = pulsewidth(template,'StateLevels',[0 mt]);
else
    rt=nan;
    pw=nan;
end

if nargout==0 || nargout==2
    %fig; 
    h=plot(template,'.-','DisplayName',sprintf(' \\mu (%.3g rise, %.3g FWHM)',rt,pw));
end

