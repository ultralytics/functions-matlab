% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [] = fcnview(h,v)
if nargin==1
    v = h;
    h = gca;
end
if isfigure(h); h=getfigureaxes(h); end


if ischar(v)
    switch v
        case 'left'
            v = [180 0];
        case 'back'
            v = [-90 0];
        case 'top'
            v = [-90 90];
        case 'skew'
            v = [150 20];
        case 'right'
            v = [0 0];
        case 'best'
            v = pcaView(h);
        otherwise
            v = [0 0];
            fprintf('\nWarning, view request not understood in fcnview.m\n')
    end
end

for i=1:numel(h)
    view(h(i),v);
end

end



function v=pcaView(h)
%sets view along maximum eigenvalue eigenvector. Should be best view of 3D data
[~,~,~,~,x,y,z] = fcnaxesdatalims(h);  if numel(x)<3; v=[0 0]; fprintf('Warning: Not enough points to run pcaView()\n'); return; end

i = x>h.XLim(1) & x<h.XLim(2) & y>h.YLim(1) & y<h.YLim(2) &  z>h.ZLim(1) & z<h.ZLim(2);
x=x(i); y=y(i); z=z(i);

[V,D] = eig(cov([x y z]));  D=max(D,[],1);  [~,i]=max(D);

V = V(:,i);
ea=fcnelaz(-V')*r2d;
v = ea([2 1]);
end