function NLSexample()
%Nonlinear Least Squares example
clc;

% n = 20000;
% e = 20000;
% np = [0 5000    0       ];
% ep = [0 15000   30000   ];

n = 40000;
e = 20000;
np = [0     0       0       ];
ep = [10000 15000   25000   ];

damping = .2;
sigma = 1/57.3;
for i = 1:3
    z(i,1) = atan((e-ep(i))/(n-np(i))) + sigma*randn;
end

%PLOT INITIAL FIGURE WINDOW -----------------------------------------------
fig;
plot(n,e,'.g','MarkerSize',12); hold on
plot(np,ep,'.b','MarkerSize',12)
axis([-10000 50000 -10000 50000])
view([90 -90]);


%PLOT CRLB ----------------------------------------------------------------
dx=.00001;
dy=.00001;

h0 = atan((e-ep)./(n-np)); %true h 
h2 = atan((e   -ep)./(n+dx-np));
h3 = atan((e+dy-ep)./(n+0 -np));

hgradient = [(h2-h0)/dx; (h3-h0)/dy]
J=0;
for col = 1:3
    J = J + hgradient(1:2,col)/sigma^2*hgradient(1:2,col)';
end
CRLBn = J^-1;

mu = [n e];
fcnerrorellipse( CRLBn , mu, .90, true);


for col = 1:3
    dhdn(col) = (ep(col)-e) / ((n-np(col))^2*(1+(e-ep(col))^2/(n-np(col))^2));
    dhde(col) = 1           / ((n-np(col))  *(1+(e-ep(col))^2/(n-np(col))^2));
end
hg = [  dhdn
        dhde    ]

R = diag([sigma^2 sigma^2 sigma^2]);
J = hg*R^-1*hg';
CRLBn = (J)^-1;
mu = [n e];
fcnerrorellipse(CRLBn, mu, .90, true);




%LS ITERATIONS ---------------------------------------------------------------
handles=gobjects(1);
button=1;
while button==1 
    [n, e, button] = ginput(1);
    if button~=1
        break
    end
    
    deleteh(handles); handles = gobjects(1,30);
    handles(1) = plot(n,e,'.r','MarkerSize',5,'LineWidth',2);
    x = [n e]';
    R = eye(3)*sigma^2;
    Ri = inv(R);
    
    for j = 1:30 %30 iterations
        for i = 1:3
            zhat(i,1) = atan((e-ep(i))/(n-np(i))) ;
        end
        J = [   -(e-ep(1))/(n^2-2*n*np(1)+np(1)^2+e^2-2*e*ep(1)+ep(1)^2)  (n-np(1))/(n^2-2*n*np(1)+np(1)^2+e^2-2*e*ep(1)+ep(1)^2)
            -(e-ep(2))/(n^2-2*n*np(2)+np(2)^2+e^2-2*e*ep(2)+ep(2)^2)  (n-np(2))/(n^2-2*n*np(2)+np(2)^2+e^2-2*e*ep(2)+ep(2)^2)
            -(e-ep(3))/(n^2-2*n*np(3)+np(3)^2+e^2-2*e*ep(3)+ep(3)^2)  (n-np(3))/(n^2-2*n*np(3)+np(3)^2+e^2-2*e*ep(3)+ep(3)^2)    ];

        x = x + (J'*Ri*J)^-1*J'*Ri*(z-zhat)*damping;
        
        n = x(1);
        e = x(2);
        handles(j+1) = plot(n,e,'.k','MarkerSize',15,'LineWidth',2);
    end

    %APPLY COVARIANCE MATRIX TO FINAL ESTIMATE ----------------------------
    eps = eye(2) * 1E-8;
    C = (J'*Ri*J + eps)^-1; %covmat
    mu = [n e];
    [~, ~, h] = fcnerrorellipse(C, mu, .9, true);
    handles = [handles h(:)'];
end






