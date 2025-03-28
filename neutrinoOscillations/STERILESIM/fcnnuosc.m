% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function Pab = fcnnuosc(varargin)
%varargin = [E(GeV),L(km),nflavors,dms,t,s2t,s22t,a,b]
%EXAMPLE: L = linspace(.002,100,600)'; E = (1.8:.01:10)/1000; a=1; b=1; Pab = fcnnuosc(E,L,3,[],[],[],[],a,b); fig; pcolor(L,E*1E3,Pab'); shading flat; xyzlabel('range (km)','energy (MeV)','',sprintf('P_%g_%g',a,b)); colorbar

%DEFAULT VALUES -----------------------------------------------------
a = 1; b = 1; %Pab
n = 3; %n flavors
zm = zeros(6);  dms=zm;  t=zm;  s2t=zm;  s22t=zm;
s22t(1,4) = 0.10;        dms(4,1) = 1.75; %red line    %14 %http://arxiv.org/abs/1303.3011v1
%s22t(1,4) = 0.057;      dms(4,1) = 0.9; %green line
%s22t(1,4) = 0.13;       dms(4,1) = 0.44; %blue line

%mu Fogli/Bari for theta12 and dm12    %Good 14 read: http://www2.warwick.ac.uk/fac/sci/physics/current/teach/module_home/px435/lec_oscillations.pdf, page 31
%Daya Bay 2/27/2014, http://arxiv.org/pdf/1402.6439.pdf for theta13 and dm13
%s22t13 =   0.090   +.008       /-.009;     %fcns22t13_2_s2t13([0 .008 -.009]+0.09)
%s2t13 =    0.02303 + 0.00210   /-0.00235;  %
%dm13 =     2.59    +.19        /-.20;      %(E-3)

dms(1,2) = 7.54e-005; % eV^2, http://journals.aps.org/prd/abstract/10.1103/PhysRevD.86.013012
dms(1,3) = 0.00259; % eV^2
s2t(1,2) = 0.307;
s2t(1,3) = 0.02303;
s2t(2,3) = 0.389; %http://en.wikipedia.org/wiki/PMNS_matrix
%DEFAULT VALUES -----------------------------------------------------


E = varargin{1}; %Energy (GeV)
L = varargin{2}; %Length (km)
if isempty(L); LoE = E; else LoE = bsxfun(@rdivide,L,E); end
if nargin>2; n = varargin{3}; end%number of flavors    
if nargin>3;
    c = varargin{4};  if ~isempty(c); s=size(c); i=find(c~=0); [row,col]=ind2sub(s,i); dms(sub2ind([6 6],row,col))  = c(i); end
    c = varargin{5};  if ~isempty(c); s=size(c); i=find(c~=0); [row,col]=ind2sub(s,i); t(sub2ind([6 6],row,col))    = c(i); end
    c = varargin{6};  if ~isempty(c); s=size(c); i=find(c~=0); [row,col]=ind2sub(s,i); s2t(sub2ind([6 6],row,col))  = c(i); end
    c = varargin{7};  if ~isempty(c); s=size(c); i=find(c~=0); [row,col]=ind2sub(s,i); s22t(sub2ind([6 6],row,col)) = c(i); end
end
if nargin>7;  a=varargin{8};  b=varargin{9};  end
[dms,t] = fcnpopulateop(dms,t,s2t,s22t,n,a,b);
c = cos(t);
s = sin(t);


if a==1 && b==1
    switch n
        case 2
            P = 1 - 4*sin((1.27*dms(2,1))*LoE).^2*c(1,2)^2*s(1,2)^2;
            
        case 3
            P = 1 - 4*sin((1.27*dms(2,1))*LoE).^2*c(1,2)^2*c(1,3)^4*s(1,2)^2 ...
                - 4*sin((1.27*dms(3,1))*LoE).^2*c(1,2)^2*c(1,3)^2*s(1,3)^2 ...
                - 4*sin((1.27*dms(3,2))*LoE).^2*c(1,3)^2*s(1,2)^2*s(1,3)^2;
            
        case 4
            P = 1 - 4*sin((1.27*dms(4,3))*LoE).^2*c(1,4)^2*s(1,3)^2*s(1,4)^2 ...
                - 4*sin((1.27*dms(2,1))*LoE).^2*c(1,2)^2*c(1,3)^4*c(1,4)^4*s(1,2)^2 ...
                - 4*sin((1.27*dms(3,1))*LoE).^2*c(1,2)^2*c(1,3)^2*c(1,4)^4*s(1,3)^2 ...
                - 4*sin((1.27*dms(4,1))*LoE).^2*c(1,2)^2*c(1,3)^2*c(1,4)^2*s(1,4)^2 ...
                - 4*sin((1.27*dms(3,2))*LoE).^2*c(1,3)^2*c(1,4)^4*s(1,2)^2*s(1,3)^2 ...
                - 4*sin((1.27*dms(4,2))*LoE).^2*c(1,3)^2*c(1,4)^2*s(1,2)^2*s(1,4)^2;
            
        case 5
            P = 1 - 4*sin((1.27*dms(5,4))*LoE).^2*c(1,5)^2*s(1,4)^2*s(1,5)^2 ...
                - 4*sin((1.27*dms(4,3))*LoE).^2*c(1,4)^2*c(1,5)^4*s(1,3)^2*s(1,4)^2 ...
                - 4*sin((1.27*dms(5,3))*LoE).^2*c(1,4)^2*c(1,5)^2*s(1,3)^2*s(1,5)^2 ...
                - 4*sin((1.27*dms(2,1))*LoE).^2*c(1,2)^2*c(1,3)^4*c(1,4)^4*c(1,5)^4*s(1,2)^2 ...
                - 4*sin((1.27*dms(3,1))*LoE).^2*c(1,2)^2*c(1,3)^2*c(1,4)^4*c(1,5)^4*s(1,3)^2 ...
                - 4*sin((1.27*dms(4,1))*LoE).^2*c(1,2)^2*c(1,3)^2*c(1,4)^2*c(1,5)^4*s(1,4)^2 ...
                - 4*sin((1.27*dms(5,1))*LoE).^2*c(1,2)^2*c(1,3)^2*c(1,4)^2*c(1,5)^2*s(1,5)^2 ...
                - 4*sin((1.27*dms(3,2))*LoE).^2*c(1,3)^2*c(1,4)^4*c(1,5)^4*s(1,2)^2*s(1,3)^2 ...
                - 4*sin((1.27*dms(4,2))*LoE).^2*c(1,3)^2*c(1,4)^2*c(1,5)^4*s(1,2)^2*s(1,4)^2 ...
                - 4*sin((1.27*dms(5,2))*LoE).^2*c(1,3)^2*c(1,4)^2*c(1,5)^2*s(1,2)^2*s(1,5)^2;
            
        case 6
            P = 1 - 4*sin((1.27*dms(6,5))*LoE).^2*c(1,6)^2*s(1,5)^2*s(1,6)^2 ...
                - 4*sin((1.27*dms(5,4))*LoE).^2*c(1,5)^2*c(1,6)^4*s(1,4)^2*s(1,5)^2 ...
                - 4*sin((1.27*dms(6,4))*LoE).^2*c(1,5)^2*c(1,6)^2*s(1,4)^2*s(1,6)^2 ...
                - 4*sin((1.27*dms(4,3))*LoE).^2*c(1,4)^2*c(1,5)^4*c(1,6)^4*s(1,3)^2*s(1,4)^2 ...
                - 4*sin((1.27*dms(5,3))*LoE).^2*c(1,4)^2*c(1,5)^2*c(1,6)^4*s(1,3)^2*s(1,5)^2 ...
                - 4*sin((1.27*dms(6,3))*LoE).^2*c(1,4)^2*c(1,5)^2*c(1,6)^2*s(1,3)^2*s(1,6)^2 ...
                - 4*sin((1.27*dms(2,1))*LoE).^2*c(1,2)^2*c(1,3)^4*c(1,4)^4*c(1,5)^4*c(1,6)^4*s(1,2)^2 ...
                - 4*sin((1.27*dms(3,1))*LoE).^2*c(1,2)^2*c(1,3)^2*c(1,4)^4*c(1,5)^4*c(1,6)^4*s(1,3)^2 ...
                - 4*sin((1.27*dms(4,1))*LoE).^2*c(1,2)^2*c(1,3)^2*c(1,4)^2*c(1,5)^4*c(1,6)^4*s(1,4)^2 ...
                - 4*sin((1.27*dms(5,1))*LoE).^2*c(1,2)^2*c(1,3)^2*c(1,4)^2*c(1,5)^2*c(1,6)^4*s(1,5)^2 ...
                - 4*sin((1.27*dms(6,1))*LoE).^2*c(1,2)^2*c(1,3)^2*c(1,4)^2*c(1,5)^2*c(1,6)^2*s(1,6)^2 ...
                - 4*sin((1.27*dms(3,2))*LoE).^2*c(1,3)^2*c(1,4)^4*c(1,5)^4*c(1,6)^4*s(1,2)^2*s(1,3)^2 ...
                - 4*sin((1.27*dms(4,2))*LoE).^2*c(1,3)^2*c(1,4)^2*c(1,5)^4*c(1,6)^4*s(1,2)^2*s(1,4)^2 ...
                - 4*sin((1.27*dms(5,2))*LoE).^2*c(1,3)^2*c(1,4)^2*c(1,5)^2*c(1,6)^4*s(1,2)^2*s(1,5)^2 ...
                - 4*sin((1.27*dms(6,2))*LoE).^2*c(1,3)^2*c(1,4)^2*c(1,5)^2*c(1,6)^2*s(1,2)^2*s(1,6)^2;
    end
else
    for i=1:n
        for j=find(1:n~=i)
            eval(sprintf('dms%g_%g=%16g;  t%g%g=%16g;',i,j,dms(i,j),i,j,t(i,j)));
        end
    end
    [U, V] = fcnbuildPMNS(n);
    P = fcnbuildP(U,a,b);
    %fcnMATLABeqns(P)
    %fcnlatexeqns(P,U,V)
    
    if a==b; Pa=1; else Pa=0; end; dab = Pa;
    P = eval(P);
end
Pab = P;

end


function [dms,t,s2t,s22t] = fcnpopulateop(dms,t,s2t,s22t,n,a,b)
i=1:n;  dms=dms(i,i);  t=t(i,i);  s2t=s2t(i,i);  s22t=s22t(i,i);

%SOLVE FOR THETAS
t1=asin(sqrt(s22t))/2;  i=t1~=0;  t(i)=t1(i);
t1=asin(sqrt(s2t));     i=t1~=0;  t(i)=t1(i);  s2t=sin(t).^2;  s22t=sin(2*t).^2;

%SOLVE FOR THE REMAINING DELTA MASSES SQUARED
i=find(dms==0); dmst=dms'; dms(i)=-dmst(i);
vi=find(dms+eye(n)==0)';
[row,col] = fcnind2sub([n n],vi);
for i = 1:numel(vi)
    ri = row(i); ci = col(i);
    if dms(ri,ci)==0
        v = dms(:,ci)-dms(:,ri);
        k = find(v~=0,1,'first');
        if any(k);  dms(ri,ci)=v(k);  dms(ci,ri)=-v(k);  end
    end
end
end


function [Uall, V] = fcnbuildPMNS(n) %---------------------------------------------
%http://en.wikipedia.org/wiki/Neutrino_oscillation
%n = size of each matrix (nxn)
m = sum(1:n-1); %numbeLr of matrices
t=sym('t_',[n n]);  %s=sym('s_',[n n]);  c=sym('c_',[n n]); 
U0 = sym('1')*diag(ones(1,n));  V=sym('0')*zeros(n,n,m);
printlatexflag = 0;

k=0;
for jj = 1:n
    for ii = find(1:n>jj)
        k=k+1;
        fprintf('%g%g\n',jj,ii)
        
        U = U0;
        U(jj,jj) =  cos(t(jj,ii));
        U(ii,ii) =  cos(t(jj,ii));
        U(jj,ii) =  sin(t(jj,ii));
        U(ii,jj) = -sin(t(jj,ii));
%          U(jj,jj) =  c(jj,ii); %for latex only
%          U(ii,ii) =  c(jj,ii);
%          U(jj,ii) =  s(jj,ii);
%          U(ii,jj) = -s(jj,ii);
        V(:,:,m+1-k) = U;
    end
end
Uall = eye(n); for i=1:m; Uall = Uall*V(:,:,i); end

for jj = 1:n
    for ii = find(1:n>jj)
        %Uall = subs(Uall,sprintf('cos(t_%g_%g)',jj,ii),sprintf('c_%g_%g',jj,ii));   %for latex only
        %Uall = subs(Uall,sprintf('sin(t_%g_%g)',jj,ii),sprintf('s_%g_%g',jj,ii));   %for latex only
        Uall = subs(Uall,sprintf('t_%g_%g',jj,ii),sprintf('t%g%g',jj,ii));
    end
end

if printlatexflag
    clc
    for i=1:m; fprintf('%s\n',latex(V(:,:,i))); end
    fprintf('\n%s\n',latex(simplify(Uall)))
end
end


function Pab = fcnbuildP(U,a,b) %------------------------------------------
%Pab = probability that neutrino originally of flavor a will later be observed as having flavor b
n = size(U,1);
dms = sym('dms',[n n]); %delta masses squared
syms LoE dab real

Pab = dab;
for jj = 1:n
    for ii = find(1:n>jj)
        %P = P   -   4*(real( conj(U(a,ii))*U(b,ii)*U(a,jj)*conj(U(b,jj)) ) * sin(1.27*dms(ii,jj)*LoE)^2);
        Pab = Pab   -   4*( U(a,ii)*U(b,ii)*U(a,jj)*U(b,jj) * sin(1.27*dms(ii,jj)*LoE)^2);
    end
end
end



function []=fcnlatexeqns(P,U,V) %------------------------------------------
n = size(U,1);

for jj = 1:n
    for ii = find(1:n>jj)
        %P = subs(P,sprintf('sin(t%g%g)^2*cos(t%g%g)^2',jj,ii,jj,ii),sprintf('sin(2*t_%g_%g)^2/4',jj,ii));
        P = subs(P,sprintf('cos(t%g%g)',jj,ii),sprintf('c_%g_%g',jj,ii));
        P = subs(P,sprintf('sin(t%g%g)',jj,ii),sprintf('s_%g_%g',jj,ii));
        
        P = subs(P,sprintf('dms%g_%g',ii,jj),sprintf('dms_%g_%g',ii,jj));
    end
end
%P = subs(P,'LoE','L/E');
s=sprintf('\n%s\n',latex(simplify(P)));

for jj = 1:n
    for ii = 1:n
        s=strrep(s,sprintf('{{c_{%g}}}_{%g}',jj,ii),sprintf('c_{%g%g}',jj,ii));
        s=strrep(s,sprintf('{{s_{%g}}}_{%g}',jj,ii),sprintf('s_{%g%g}',jj,ii));
        s=strrep(s,sprintf('{{{c_{%g}}}_{%g}}^2',jj,ii),sprintf('c^2_{%g%g}',jj,ii));
        s=strrep(s,sprintf('{{{s_{%g}}}_{%g}}^2',jj,ii),sprintf('s^2_{%g%g}',jj,ii));
        s=strrep(s,sprintf('{{{c_{%g}}}_{%g}}^4',jj,ii),sprintf('c^4_{%g%g}',jj,ii));
        s=strrep(s,sprintf('{{{s_{%g}}}_{%g}}^4',jj,ii),sprintf('s^4_{%g%g}',jj,ii));
        %s=strrep(s,sprintf('{{\\mathrm{dms}_{%g}}}_{%g}',jj,ii),sprintf('\\Delta m^2_{%g%g}',jj,ii));
        s=strrep(s,sprintf('\\frac{127\\, \\mathrm{LoE}\\, {{\\mathrm{dms}_{%g}}}_{%g}}{100}',jj,ii),sprintf('\\frac{1.27 L \\Delta m^2_{%g%g}}{E}',jj,ii));
    end
end
sprintf('\n\n%s',s)
end


function fcnMATLABeqns(P)
clc
%P11 for 2 through 6 flavors
f{2} = 'dab - 4.0*sin(1.27*LoE*dms2_1)^2*cos(t12)^2*sin(t12)^2';
f{3} = 'dab - 4.0*sin(1.27*LoE*dms2_1)^2*cos(t12)^2*cos(t13)^4*sin(t12)^2 - 4.0*sin(1.27*LoE*dms3_1)^2*cos(t12)^2*cos(t13)^2*sin(t13)^2 - 4.0*sin(1.27*LoE*dms3_2)^2*cos(t13)^2*sin(t12)^2*sin(t13)^2';
f{4} = 'dab - 4.0*sin(1.27*LoE*dms4_3)^2*cos(t14)^2*sin(t13)^2*sin(t14)^2 - 4.0*sin(1.27*LoE*dms2_1)^2*cos(t12)^2*cos(t13)^4*cos(t14)^4*sin(t12)^2 - 4.0*sin(1.27*LoE*dms3_1)^2*cos(t12)^2*cos(t13)^2*cos(t14)^4*sin(t13)^2 - 4.0*sin(1.27*LoE*dms4_1)^2*cos(t12)^2*cos(t13)^2*cos(t14)^2*sin(t14)^2 - 4.0*sin(1.27*LoE*dms3_2)^2*cos(t13)^2*cos(t14)^4*sin(t12)^2*sin(t13)^2 - 4.0*sin(1.27*LoE*dms4_2)^2*cos(t13)^2*cos(t14)^2*sin(t12)^2*sin(t14)^2';
f{5} = 'dab - 4.0*sin(1.27*LoE*dms5_4)^2*cos(t15)^2*sin(t14)^2*sin(t15)^2 - 4.0*sin(1.27*LoE*dms4_3)^2*cos(t14)^2*cos(t15)^4*sin(t13)^2*sin(t14)^2 - 4.0*sin(1.27*LoE*dms5_3)^2*cos(t14)^2*cos(t15)^2*sin(t13)^2*sin(t15)^2 - 4.0*sin(1.27*LoE*dms2_1)^2*cos(t12)^2*cos(t13)^4*cos(t14)^4*cos(t15)^4*sin(t12)^2 - 4.0*sin(1.27*LoE*dms3_1)^2*cos(t12)^2*cos(t13)^2*cos(t14)^4*cos(t15)^4*sin(t13)^2 - 4.0*sin(1.27*LoE*dms4_1)^2*cos(t12)^2*cos(t13)^2*cos(t14)^2*cos(t15)^4*sin(t14)^2 - 4.0*sin(1.27*LoE*dms5_1)^2*cos(t12)^2*cos(t13)^2*cos(t14)^2*cos(t15)^2*sin(t15)^2 - 4.0*sin(1.27*LoE*dms3_2)^2*cos(t13)^2*cos(t14)^4*cos(t15)^4*sin(t12)^2*sin(t13)^2 - 4.0*sin(1.27*LoE*dms4_2)^2*cos(t13)^2*cos(t14)^2*cos(t15)^4*sin(t12)^2*sin(t14)^2 - 4.0*sin(1.27*LoE*dms5_2)^2*cos(t13)^2*cos(t14)^2*cos(t15)^2*sin(t12)^2*sin(t15)^2';
f{6} = 'dab - 4.0*sin(1.27*LoE*dms6_5)^2*cos(t16)^2*sin(t15)^2*sin(t16)^2 - 4.0*sin(1.27*LoE*dms5_4)^2*cos(t15)^2*cos(t16)^4*sin(t14)^2*sin(t15)^2 - 4.0*sin(1.27*LoE*dms6_4)^2*cos(t15)^2*cos(t16)^2*sin(t14)^2*sin(t16)^2 - 4.0*sin(1.27*LoE*dms4_3)^2*cos(t14)^2*cos(t15)^4*cos(t16)^4*sin(t13)^2*sin(t14)^2 - 4.0*sin(1.27*LoE*dms5_3)^2*cos(t14)^2*cos(t15)^2*cos(t16)^4*sin(t13)^2*sin(t15)^2 - 4.0*sin(1.27*LoE*dms6_3)^2*cos(t14)^2*cos(t15)^2*cos(t16)^2*sin(t13)^2*sin(t16)^2 - 4.0*sin(1.27*LoE*dms2_1)^2*cos(t12)^2*cos(t13)^4*cos(t14)^4*cos(t15)^4*cos(t16)^4*sin(t12)^2 - 4.0*sin(1.27*LoE*dms3_1)^2*cos(t12)^2*cos(t13)^2*cos(t14)^4*cos(t15)^4*cos(t16)^4*sin(t13)^2 - 4.0*sin(1.27*LoE*dms4_1)^2*cos(t12)^2*cos(t13)^2*cos(t14)^2*cos(t15)^4*cos(t16)^4*sin(t14)^2 - 4.0*sin(1.27*LoE*dms5_1)^2*cos(t12)^2*cos(t13)^2*cos(t14)^2*cos(t15)^2*cos(t16)^4*sin(t15)^2 - 4.0*sin(1.27*LoE*dms6_1)^2*cos(t12)^2*cos(t13)^2*cos(t14)^2*cos(t15)^2*cos(t16)^2*sin(t16)^2 - 4.0*sin(1.27*LoE*dms3_2)^2*cos(t13)^2*cos(t14)^4*cos(t15)^4*cos(t16)^4*sin(t12)^2*sin(t13)^2 - 4.0*sin(1.27*LoE*dms4_2)^2*cos(t13)^2*cos(t14)^2*cos(t15)^4*cos(t16)^4*sin(t12)^2*sin(t14)^2 - 4.0*sin(1.27*LoE*dms5_2)^2*cos(t13)^2*cos(t14)^2*cos(t15)^2*cos(t16)^4*sin(t12)^2*sin(t15)^2 - 4.0*sin(1.27*LoE*dms6_2)^2*cos(t13)^2*cos(t14)^2*cos(t15)^2*cos(t16)^2*sin(t12)^2*sin(t16)^2';

%P12 for 3 flavors
f{7} = 'dab + 4.0*sin(1.27*LoE*dms2_1)^2*cos(t12)*cos(t13)^2*sin(t12)*(cos(t12)*cos(t23) - 1.0*sin(t12)*sin(t13)*sin(t23))*(cos(t23)*sin(t12) + cos(t12)*sin(t13)*sin(t23)) - 4.0*sin(1.27*LoE*dms3_2)^2*cos(t13)^2*sin(t12)*sin(t13)*sin(t23)*(cos(t12)*cos(t23) - 1.0*sin(t12)*sin(t13)*sin(t23)) + 4.0*sin(1.27*LoE*dms3_1)^2*cos(t12)*cos(t13)^2*sin(t13)*sin(t23)*(cos(t23)*sin(t12) + cos(t12)*sin(t13)*sin(t23))';

%P13 for 3 flavors
f{8} = 'dab + 4.0*sin(1.27*LoE*dms2_1)^2*cos(t12)*cos(t13)^2*sin(t12)*(sin(t12)*sin(t23) - 1.0*cos(t12)*cos(t23)*sin(t13))*(cos(t12)*sin(t23) + cos(t23)*sin(t12)*sin(t13)) - 4.0*sin(1.27*LoE*dms3_1)^2*cos(t12)*cos(t13)^2*cos(t23)*sin(t13)*(sin(t12)*sin(t23) - 1.0*cos(t12)*cos(t23)*sin(t13)) + 4.0*sin(1.27*LoE*dms3_2)^2*cos(t13)^2*cos(t23)*sin(t12)*sin(t13)*(cos(t12)*sin(t23) + cos(t23)*sin(t12)*sin(t13))';


for n=2:numel(f)
    s = f{n};
    s=strrep(s,'.0*','*');
    s=strrep(s,'dab','1');
    s=strrep(s,' - ',' ...\n- ');
    %s=strrep(s,' + ',' ...\n+ ');
    for j = 1:n
        for k = 1:n
            s=strrep(s,sprintf('dms%g_%g)^2',j,k),sprintf('dms%g_%g).^2',j,k));
            s=strrep(s,sprintf('(1.27*LoE*dms%g_%g)',j,k),sprintf('((1.27*dms%g_%g)*LoE)',j,k));
            s=strrep(s,sprintf('dms%g_%g',j,k),sprintf('dms(%g,%g)',j,k));
            
            s=strrep(s,sprintf('sin(t%g%g)',j,k),sprintf('s(%g,%g)',j,k));
            s=strrep(s,sprintf('cos(t%g%g)',j,k),sprintf('c(%g,%g)',j,k));
            %s=strrep(s,sprintf('sin(t%g%g)^2',j,k),sprintf('s2(%g,%g)',j,k));
            %s=strrep(s,sprintf('cos(t%g%g)^2',j,k),sprintf('c2(%g,%g)',j,k));
            %s=strrep(s,sprintf('sin(t%g%g)^4',j,k),sprintf('s2(%g,%g)^2',j,k));
            %s=strrep(s,sprintf('cos(t%g%g)^4',j,k),sprintf('c2(%g,%g)^2',j,k));
        end
    end
    s(end+1) = ';';
    s = sprintf('\nP = %s\n',s);
    fprintf(s)
end

end



function b = fcns2t_2_t(a)
b = asin(sqrt(a));

end
