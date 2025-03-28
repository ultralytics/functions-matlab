% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [ctid1, lv1] = fcntid2ctid(tid1,tid,ptid) %trackID to children's trackID
%ctid1 = vector of unique children (and grandchildren etc.) track IDs
%lv1 = logical indicating presence of offspring in tid vector
ctid1=[];
if numel(tid1)==0
    lv1=[];
    return
end

lv1 = ptid==tid1;
if any(lv1)
    ctid1u = fcnunique(tid(lv1));  %trackIDs with tid1 direct parent
    a=ctid1u;
    
    for gen=2:10
        ctid2u = [];
        for i=1:numel(ctid1u)
            lv = ptid==ctid1u(i);
            if any(lv)
                ctid2u = [ctid2u; fcnunique(tid(lv))];  %#ok<AGROW> %trackIDs with tid1 direct parent
                lv1 = lv1 | lv;
            end
        end
        if numel(ctid2u)==0
            break
        end
        a = [a; ctid2u]; %#ok<AGROW>
        ctid1u = ctid2u;
    end
    
    ctid1 = a;
end






