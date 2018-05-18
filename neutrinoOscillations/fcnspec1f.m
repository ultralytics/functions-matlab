function f1 = fcnspec1f(r1, MeV, op)
a=1;
b=1;
if nargin>2
    dms(1,2)=op(1);  dms(1,3)=op(2);  s2t(1,2)=op(3);  s2t(1,3)=op(4);
    f1 = fcnnuosc(MeV/1000,r1,3,dms,[],s2t,[],a,b);
else
    f1 = fcnnuosc(MeV/1000,r1,3,[],[],[],[],a,b);
end
%varargin = [E(GeV),L(km),nflavors,dms,t,s2t,s22t,a,b]



% MeV = 1.8:.01:11;
% r1 = (0:.1:300)';
% for i=1:3
%     ha=fig(1,1,1.5);
%     f1=fcnnuosc(MeV/1000,r1,3,[],[],[],[],1,i);
%     pcolor(r1,MeV,f1'); shading flat;
%     blue = 1-gray; blue(:,i)=1; colormap(blue)
%     xyzlabel('L (km)','E (MeV)','',sprintf('P_{1%g}',i)); axis tight
% end
