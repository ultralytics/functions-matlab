% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [y, i] = max3(x)

if nargout==1
    y=max(x(:));
else
    sx = size(x);
    n = numel(sx);
    switch n
        case 2
            if any(sx==1)
                [y,        i]         = max( x );
            else
                [y,      col]         = max(max(      x         ));
                [~,      row]         = max(          x(:,col)  );
                i = [row col];
            end
        case 3
            [y,    layer]         = max(max(max(  x               )));
            [~,      col]         = max(max(      x(:,:,layer)    ));
            [~,      row]         = max(          x(:,col,layer)  );
            i = [row col layer];
        case 4
            [y,    block]         = max(max(max(max(  x                     ))));
            [~,    layer]         = max(max(max(      x(:,:,:,block)        )));
            [~,      col]         = max(max(          x(:,:,layer,block)    ));
            [~,      row]         = max(              x(:,col,layer,block)  );
            i = [row col layer block];
        case 5
            [y, j] = max(x(:));
            [a,b,c,d,e] = ind2sub(sx,j);
            i = [a b c d e];
    end
end
end

