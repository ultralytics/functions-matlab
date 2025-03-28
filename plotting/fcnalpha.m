% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function fcnalpha(a)
if nargin==0;  a = .5;  end

h1 = findobj(gcf,'type','patch');
h2 = findobj(gcf,'type','surface');

set([h1(:); h2(:)],'FaceAlpha',a);

h = findobj(gcf,'type','image');
set(h,'AlphaData',a);
