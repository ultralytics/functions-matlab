% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function G1 = fcnGEANT2G1(G,input)
offset = input.neutrino.pN.CC_detector;
C_G2N = [   0 0 1
            0 1 0
            1 0 0   ]; %GEANT 2 NED
nuebar_rpy = [0 0 0]; %rad
C = C_G2N*fcnRPY2DCM_W2B(nuebar_rpy);

v1 = find(G.all.x(:,1)==input.eventNumber);
G1.pname = G.all.pname(v1);
x = G.all.x(v1,:);  x(:,10:12)=x(:,10:12)*C;  x(:,13:15)=x(:,13:15)*C;
x(:,[10 13]) = x(:,[10 13]) + offset(1);
x(:,[11 14]) = x(:,[11 14]) + offset(2);
x(:,[12 15]) = x(:,[12 15]) + offset(3);

pid = x(:,7); %particleid
tid = x(:,8); %trackid
ptid = x(:,9); %parent trackid
G1.ke1 = x(:,18); %begin ke
G1.ke2 = x(:,19); %end ke
G1.de = x(:,20);
G1.p1 = x(:,10:12);
G1.p2 = x(:,13:15);
G1.t1 = x(:,16);
G1.t2 = x(:,17);
G1.x = x;
clear x

a = fcnunique(tid(ptid==0)); %unique ancestors;
atid = pid*0; %ancestor trackid
for i=1:numel(pid)
    pt1=ptid(i);
    t1=tid(i);
    if t1==a(1) || pt1==a(1)
        atid(i)=a(1);
    %elseif t1==a(2) || pt1==a(2);
    %    atid(i)=a(2);
    else
        while pt1>2
            pt1 = ptid(find(pt1==tid,1));
        end
        atid(i) = pt1;
    end
end

G1.atid = atid;
G1.pid = pid;
G1.tid = tid;
G1.ptid = ptid;
G1.upid = fcnunique(pid);
G1.utid = fcnunique(tid);

v1=G1.atid==1;
cells1=fieldnames(G1);
for i = 1:numel(cells1)-2
    eval(sprintf('G1.prompt.%s=G1.%s(v1,:);',cells1{i},cells1{i}))
end
G1.prompt.upid=fcnunique(G1.prompt.pid);  G1.prompt.nupid=numel(G1.prompt.upid);  G1.prompt.upidflag=ones(size(G1.prompt.upid));
G1.prompt.utid=fcnunique(G1.prompt.tid);  G1.prompt.nutid=numel(G1.prompt.utid);

v1=G1.atid==2;
for i = 1:numel(cells1)-2
    eval(sprintf('G1.delayed.%s=G1.%s(v1,:);',cells1{i},cells1{i}))
end
G1.delayed.upid=fcnunique(G1.delayed.pid);  G1.delayed.nupid=numel(G1.delayed.upid);  G1.delayed.upidflag=ones(size(G1.delayed.upid));
G1.delayed.utid=fcnunique(G1.delayed.tid);  G1.delayed.nutid=numel(G1.delayed.utid);

for i = 1:G1.prompt.nupid
    G1.prompt.nupidv(i) = numel(fcnunique(G1.prompt.tid(G1.prompt.pid==G1.prompt.upid(i))));
end
for i = 1:G1.delayed.nupid
    G1.delayed.nupidv(i) = numel(fcnunique(G1.delayed.tid(G1.delayed.pid==G1.delayed.upid(i))));
end

G1.na = numel(a); %number of ancestors;
G1.uvec.tid0 = G1.x(1,3:5)*C;

for i=1:G1.na
    v1=find(tid==a(i));  [~,j]=min(G1.t1(v1));   eval(['G1.uvec.tid' num2str(i) '=[' num2str( fcnvec2uvec(G1.p2(v1(j),:)-G1.p1(v1(j),:)) ) '];']);
end

G1.nupid=numel(G1.upid);
G1.nutid=numel(G1.utid);
G1.upidflag = ones(size(G1.upid));


end

