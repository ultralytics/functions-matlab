function [] = fcnLAPPDnu()
clc
%pname = uigetdir();
%pname = '/Users/glennjocher/Desktop/LAPPD/2014/10.29/data_storage4';
pname =              '/Volumes/LaCie/LAPPD/2014/10.29/data_storage4';
s = dir(pname);
i = find(~[s.isdir]);
fname = {s(i).name}; n = numel(fname);  if n==0; fprintf('No MTC events in this directory.\n'); return; end

% p = 'demount_2700V_x(.+)_y(.+)_board2.txt'; %pattern
% j=0; x=0; y=0;
% for i=1:n
%     a = regexpi(fname(i),p,'tokens');  a=a{1};
%     if ~isempty(a)
%         j=j+1;
%           a=a{1};
%         x(j)=eval(a{1}); y(j)=eval(a{2});
%     end
% end
% %100,000 = 23mm in transverse to striplines
% %100,000 = 37mm in parallel
% x = x*23/1E5; %encoder to mm
% y = y*37/1E5; %encoder to mm
% fig; plot(x(1:3),y(1:3),'.','markersize',25)
% cube([100 100 100],[0 0 0],1); fcnlinewidth(3); xyzlabel('(mm)','(mm)'); axis([-1 1 -1 1]*110)


Z = zeros(30,200);
zv = midspace(-100,100,30);
zmm = midspace(-100,100,200);
for i=2:1:65
    A = loadnewfile([pname filesep fname{2*i-1}]);
    B = loadnewfile([pname filesep fname{2*i-0}]);    B.xe = flipdim(B.xe,2);
    
    fig(3,2); 
    for j=30:35
        sca; fcnLAPPDGUIplot1event(A,j); 
        fcnLAPPDGUIplot1event(B,j); 
    end; 
    fcnview(gcf,'skew')

    psf = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.00132, 0.001236, 0.005921, 0.006331, 0.004879, 0.01468, 0.02173, 0.02303, 0.02907, 0.0405, 0.06466, 0.0814, 0.1043, 0.135, 0.1677, 0.2007, 0.2396, 0.2877, 0.3374, 0.4064, 0.4903, 0.5756, 0.6686, 0.763, 0.8346, 0.9098, 0.9726, 0.9945, 1.0, 0.985, 0.9518, 0.9063, 0.8481, 0.7892, 0.7227, 0.6524, 0.5875, 0.5145, 0.4403, 0.372, 0.2933, 0.2436, 0.2012, 0.1319, 0.08917, 0.0638, 0.01832, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    nsr = 10;
    threshold=20;
    sxe = size(A.xe);
    
    %WIENER DECONVOLUTION
    Sl = reshape(A.xe,[sxe(1) sxe(2)*sxe(3)])'; %S=30x256;
    Vl = deconvwnr(Sl,psf,nsr);  %fig; plot(V')
    [pix1, t1] = findlocalmaximaregions(-Vl',threshold);
    
    Sr = reshape(B.xe,[sxe(1) sxe(2)*sxe(3)])'; %S=30x256;
    Vr = deconvwnr(Sr,psf,nsr);  %fig; plot(V')
    [pix2, t2] = findlocalmaximaregions(-Vr',threshold);
    
    [~,indA,~,n] = fcnunique(pix1);
    l = indA(n==1);  pix1=pix1(l);  t1=t1(l);
    
    [~,indA,~,n] = fcnunique(pix2);
    l = indA(n==1);  pix2=pix2(l);  t2=t2(l);
    
    k = bsxfun(@eq,pix1,pix2');
    l = any(k,2);  pix1=pix1(l);  t1=t1(l);
    l = any(k,1);  pix2=pix2(l);  t2=t2(l);
    
    dt = (t1'-t2')/10; %(ns)
    l = abs(dt)<.95; dt=dt(l); pix1=pix1(l); pix2=pix2(l);
    
    v = 200; %(mm/ns)
    y = dt*v/2;
    x = rem(pix1,30)*6.7-100;
    
    X{i} = x;
    Y{i} = y;
    Zi = hist3([x y],{zv,zmm});  Z = Z + Zi;%./numel(dt);
    nc = numel(dt); %number of candidates
    
    fig; pcolor(zmm,(zv+100)/6.7,Zi); shading flat; axis tight; xyzlabel('mm','strip','',sprintf('''%s'' (%.2f eff)',str_(A.pf2),nc/A.ne))
    
%     ei=7;
%     fig(1,2,1.5); plot(Sl(pix1(ei),:)','r'); plot(Sr(pix1(ei),:)','b')
%     sca; plot(Vl(pix1(ei),:)','r'); plot(Vr(pix1(ei),:)','b')
%     
%     std(fcnsigmarejection(dt,2.5,3))
%     fig; fcnhist(dt)
    
    %t1 = left side;
    %t2 = right side;
    %origin = center tile, +x to top (strip 30), +y to right side
end

fig; pcolor(zmm,(zv+100)/6.7,Z); shading flat; axis tight; xyzlabel('mm','strip','','All Files')

X = cell2mat(X(:));
Y = cell2mat(Y(:));
fig; [a,b]=hist3([X Y],{zv,zv}); pcolor(a); shading flat; axis tight; xyzlabel('mm','strip','','All Files')


end






function G = loadnewfile(fname)
G = fcnloadtextfile(fname,1E6);  if isempty(G); return; end
xn = G.x;

ne = size(xn,1)/256; %number of events
xe = reshape(xn,[256 ne 32]);
xe = permute(xe,[1 3 2]); %[256 32 ne]
pqi = fcncol(xe(3,end,:)); %pedestal quad indicator (1 of 4 possible values)
xe = xe(:,2:end-1,:);

%AUTO-PEDESTALS
%xe = xe - mean(xe(:));
%xe = bsxfun(@minus,xe,mean(xe,3));

%PEDESTALS
a = regexpi(fname,'_board(\d+).txt','tokens'); a=a{1};
%pedfile = ['/Users/glennjocher/Desktop/LAPPD/2014/10.29/calibrations/PED_DATA_' a{1} '.txt'];
pedfile = [             '/Volumes/LaCie/LAPPD/2014/10.29/calibrations/PED_DATA_' a{1} '.txt'];
E = fcnloadtextfile(pedfile);  ped=E.x(:,2:end);  pedoffsets = rem(90+[0 1 2 3]*64,256);
for i=1:4 %for each trigger quadrant
    j = find(pqi==(i-1));
    pi = circshift(ped,-pedoffsets(i));
    xe(:,:,j) = bsxfun(@minus,xe(:,:,j),pi);
end

% %SECOND GEN PEDESTALS FROM EMPTY EVENTS
% xf = reshape(xe,[256*30 ne]);
% i = find(all(xf>-50,1)); %these have no signal
% mxe = mean(xe(:,:,i),3);
% fig; for j=1:min(numel(i),100); plot(mean(xe(:,:,i(j)))); end; xyzlabel('LAPPD strip','mean strip value','',str_(G.pf2))
% %xe = bsxfun(@minus,xe,-mxe);

G.xe=xe;
G.ne=ne;
G.ve=1:ne;
assignin('base','G',G)

set(findobj(gcf,'Type','uicontrol','-and','Tag','eventselector'),'value',1);
%closeallexcept(findobj(0,'Name','LAPPD GUI'));

if isempty(fname)
    plot1event
    plotfilestats
end
end





function [cols, tmax, maxval] = findlocalmaximaregions(y,threshold)
%y = nxm, finds the maxima down dimension x above threshold
cols=[]; tmax=[]; maxval=[]; sy=size(y);
if nargin<2;  threshold=150;  end;  y0=y;  y(y<threshold)=0;

dy = fcndiff(y,1);  dsdy = fcndiff(sign(dy),1);
ind = find(dsdy==-2) - 1; %falling zero crossings

row = mod(ind,sy(1));  ind=ind(row>2 & row<(sy(1)-2));  ni=numel(ind);
if ni==0; return; end

[i, cols] = ind2sub(size(y),ind); %i=row, j=col
i = bsxfun(@plus,i,-2:2);
ind = bsxfun(@plus,ind,-2:2);

%UPSAMPLE
nss = 300; %number spline samples
xi = linspace(1,3,nss);
yi = interp1((0:4)',y0(ind)',xi,'spline');  if ni>1; yi=yi'; end
xip = bsxfun(@plus, xi, i(:,1));

[maxval, j]=max(yi,[],2);
tmax = xip(sub2ind(size(yi),1:numel(j),j'));

%PLOT
%y(y<threshold) = nan;  x=(1:size(y,1))';
%fig; plot(x,y,'.-'); plot(i,y(ind),'b.','markersize',20); plot(xip,yi,'r.','Markersize',5); plot(tmax,maxval,'mo')
end
