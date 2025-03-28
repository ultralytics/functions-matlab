% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function closeallexcept(hf)
%closes all open figures except hf
hc = get(0,'children');  

n = numel(hf);
if n==1
    delete(hc(hc~=hf));
else    
    for i=1:numel(hc)
        if ~any(hc(i)==hf)
            delete(hc(i));
        end
    end
end

