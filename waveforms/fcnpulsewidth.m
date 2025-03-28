% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [hasdata, aout, w, xout, integral, yout, minout] = fcnpulsewidth(y,fraction,heightrange,widthrange,saturation,method)
% method = 'fraction', 'amplitude', or 'maximum'
% y = 256x10 = 256 samples and 10 channels
if nargin==0;  x=(-40:1:60)';  y=[normpdf(x,0,6), normpdf(x,20,6) normpdf(x,10,9)];  i=y(:,2)>max(y(:,2))/2; y(i,2)=-max(y(:,2)); fraction=0.5; end
if nargin==1;  fraction = 0.5; end %height up the pulse that width is measured at

[nr,nc0] = size(y);  yout=y; %[number of pulses, number of samples per pulse]
m = max(y,[],1)';  hasdata = m~=0;

if nargin<3
    candidates = 1:nc0;
else
    candidates  = find(m>heightrange(1) & m<heightrange(2));
end

y=y(:,candidates);  ys=y>(saturation*.99) | isnan(y); %> faster than ==
zv=zeros(nc0,1);  xout=zv;  w=zv;

%SET MEDIAN TO ZERO
%i=y==0; j=y==1600; y(i)=nan;  y=y-nanmedian(y,1);  y(i)=0;  y(j)=1600;

%RECONSTRUCT PULSES
y = fcnSplinePulseReconstruction(y,ys);
%fig; plot(ysr,'.-'); set(gca,'XLim',[2250 2350])

%SMOOTH PULSES
%y=fcnsmooth(y,3);  %fig; j=i(1:2,:); plot(fcnsmooth(y(j)',5),'b.-'); plot(y(j)','r.-')


% %MULTIPULSE
% multipulseflag = true; 
% if multipulseflag
%     mpi = 1; %multipulse index (pulse you want stats from)
%     mpg = 20; %minimum pulse gap (helps stop [35 50 48 51 45] as showing up two pulses)
%     y=fcnmultipulse(y,heightrange,mpi,mpg);
% end
switch method
    case {'fraction','amplitude'}
        if strcmp(method,'amplitude'); fixedAmplitude=true; else; fixedAmplitude=false; end
        [maxima, maxrow] = max(y,[],1);  maxrow=maxrow(:);
        nf = numel(fraction);  n = zeros(nc0,1);
        for k=1:nf
            if fixedAmplitude
                ak = fraction(k);
            else %CFD
                ak = maxima * fraction(k);
            end
            j0=y>ak;  j0=j0~=circshift(j0,1,1);  j0(1,:)=false;  sumj=sum(j0);
            
            singles = sumj==1;
            multiples = sumj>1;
            if any(multiples)
                j=j0;
                j(:,~multiples)=false;  av=candidates(multiples);
                j = find(j);
                
                try
                    mode = 'firstTwo'; %track only 1 pulse, eliminate multipulses
                    switch mode
                        case 'nearestTwo' %nearest 50% crossings before and after max amplitude
                            col = ceil(j/nr);
                            row = j-col*nr+nr;
                            drow = row - maxrow(col); %distance between 50% crossing and maxima
                            
                            %dsd = [false; diff(sign(drow),2)==2]; %diff=2 means went from -1 to 1, before to after maxima
                            dsd = [false; false; diff(sign(drow),2)>0]; %diff=2 means went from -1 to 1, before to after maxima
                            sj = dsd | circshift(dsd,-1);
                        case 'firstTwo'
                            sj = [true; true; diff(ceil(j/nr),2)~=0]; %first two 50% crossings
                    end
                    j=j(sj);
                    
                    i = j-1;
                    y1 = y(i);
                    y2 = y(j);
                    
                    x1 = mod(i,nr);  %x2=x1+1;
                    if fixedAmplitude; yi=ak;  else;  yi=repmat(ak(multiples),[2 1]);  end %y intercept
                    
                    %linear interpolation
                    slope = y2-y1;
                    f = (yi(:)-y1)./slope;
                    xi = x1 + f;%.*(x2-x1);
                    xi = reshape(xi,[2 numel(av)]);
                    w(av) = w(av) + (xi(2,:)-xi(1,:))';
                    %if fixedThresholdFlag;  zeroIntercept = xi-yi./reshape(slope,[2 numel(av)]);  xi=zeroIntercept; end % plus slope
                    
                catch
                    ''
                end
                
                xout(av) = xout(av) + xi(1,:)';
                n(av)=n(av)+1;
            end
            
            if any(singles)
                j=j0;
                j(:,~singles)=false;  av=candidates(singles);
                j = find(j);
                
                i = j-1;
                y1 = y(i);
                y2 = y(j);
                
                x1 = mod(i,nr);  %x2=x1+1;
                if fixedAmplitude; yi=ak;  else;  yi=ak(singles);  end %y intercept
                
                %linear interpolation
                slope = y2-y1;
                f = (yi(:)-y1)./slope;
                xi = x1 + f;%.*(x2-x1);
                %if fixedThresholdFlag;  zeroIntercept = xi-yi./slope;  xi=zeroIntercept; end % plus slope
                
                xout(av) = xout(av) + xi;
                n(av)=n(av)+1;
            end
        end
    case {'maximum','max'}
        n = ones(nc0,1);
        xout(candidates) = fcnSplinePulseMaxima(y);
end
i=n~=0;
w(i)=w(i)./n(i);
xout(i)=xout(i)./n(i);






% %DECONVOLUTION TIMES INSTEAD!
% try
%     if any(candidates)
%         input = evalin('base','input');
%         flags = evalin('base','flags');
%         [V, QT] = fcnphotondeconvolution(input,flags,full(y));
%         xout=xout*0;
%         xout(candidates(QT(:,1))) = QT(:,2);
%     end
% catch
%     'FAILED DECONVOLUTION'
% end

if nargout>5
    yout(:,candidates) = y;
    aout = double(max(yout,[],1)');
    minout = double(min(yout,[],1)');
    integral = double(nansum(yout,1)');
else
    aout=zv;        aout(candidates)=max(y,[],1);
    minout=zv;      minout(candidates)=min(y,[],1);
    integral=zv;    integral(candidates)=getIntegral(y,xout(candidates),w(candidates),'FWHM');
end

% if nargin>=4
%     i = aout>0 & (w<widthrange(1) | w>widthrange(2) | aout<heightrange(1) | aout>heightrange(2));
%     w(i) = 0;
%     aout(i) = 0;
%     xout(i) = 0;
%     integral(i) = 0;
%     hasdata(i) = false;
% end
end


function y=getIntegral(y,t,w,type)
switch type
    case 'FWHM'
        a=round(t-w*.5)';
        b=round(t+w*1.5)';
        r=(1:size(y,1))';
        y(r<a | r>b)=0;
    case 'all'
end
y=sum(y,1,'omitnan');
end

function y = fcnmultipulse(y,heightrange,mpi,mpg)
if isempty(y); return; end
%This function suppresses all pulses except the mpi pulse
i = y(3:end,:)>heightrange(1) & diff(sign(diff(y)))<0;  i=padarray(i,[2 0],0,'pre');
i = i & ~circshift(i,1); %helps with flat pulse peaks (i.e. [...50 52 52 49...]
sy = size(y); nr=sy(1); ny=sy(2); oy=ones(1,ny);

k = find(i)+1;
[row,col]=ind2sub(sy,k);
vpg = [true; diff(row)>mpg | diff(col)~=0];  row=row(vpg);  col=col(vpg);  k=k(vpg); %valid pulse gap

[~,~,~,n] = fcnunique(col);
C = arrayfun(@(x,y) x:y,n*0+1,n,'UniformOutput', false); C=[C{:}]';

ia = 1:nr:(nr*ny); %first time bin of each channel
ib = ia + (nr-1);  %last time bin of each channel

i = [ia,     ib, k'     ];
f = [oy*(mpi==1), oy, C'==mpi];
j = sortrows([i' f'],1);  [~,J] = fcnunique(j(:,1)); j=j(J,:);

F = griddedInterpolant(j(:,1)',j(:,2)','nearest','nearest');
y = y.*reshape(F(1:(nr*ny)),sy);
%A=[row col C k]; A(1:20,:)
end