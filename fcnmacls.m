% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function y=fcnmacls(x)
%transforms 1xnm size string into proper nxm size (default on PC)
%ON PC: str = ls(pathname);
%ON MAC: str = fcnmacls(ls(pathname));

if ismac
    j = find(x==char(10)); %char(10) is line return
    c = numel(j);
    r = [j(1) j(2:end)-j(1:end-1)]-1; %lengths
    
    y = char(zeros(c,max(r)));
    y(1,1:r(1)) = x(1:j(1)-1);
    for i=2:c
        y(i,1:r(i)) = x(j(i-1)+1:j(i)-1);
    end
else
    y=x;
end
