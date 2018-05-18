function [y, i] = min3(x)

if nargout==1
    y=min(x(:));
else
    sx = size(x);
    n = numel(sx);
    switch n
        case 2
            if any(sx==1)
                [y,        i]         = min( x );
            else
                [y,      col]         = min(min(      x         ));
                [~,      row]         = min(          x(:,col)  );
                i = [row col];
            end
        case 3            
            [y,    layer]         = min(min(min(  x               )));
            [~,      col]         = min(min(      x(:,:,layer)    ));
            [~,      row]         = min(          x(:,col,layer)  );
            i = [row col layer];
        case 4           
            [y,    block]         = min(min(min(min(  x                     ))));
            [~,    layer]         = min(min(min(      x(:,:,:,block)        )));
            [~,      col]         = min(min(          x(:,:,layer,block)    ));
            [~,      row]         = min(              x(:,col,layer,block)  );
            i = [row col layer block];
        case 5
            [y, j] = min(x(:));
            [a,b,c,d,e] = ind2sub(sx,j);
            i = [a b c d e];
    end
end
end