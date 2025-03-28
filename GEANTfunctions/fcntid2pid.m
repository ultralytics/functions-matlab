% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function pid1 = fcntid2pid(tid1,tid,pid) %trackID to particleID
if isempty(tid1)
    pid1=[];
    return
end

A = nan(max(tid)+1,1);  A(tid+1)=pid;
pid1 = A(tid1+1);

% [~,b] = fcnunique(tid);
% if numel(b)>1 %>1 tids
%     P=[nan; pid(b)];
%     pid1=P(tid1+1);
% else
%     pid1=pid(1);
% end
% ''
