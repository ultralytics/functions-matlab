% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function plots2jpgs()

for i=1:100
    if isgraphics(i)
        figure(i);
        fprintf('Processing Figure %g...',i); tic

        %export_fig(gcf,'-nocrop',sprintf('figure%g.pdf',i))
        export_fig(gcf,'-q90','-r150','-a1',sprintf('f%g.jpg',i))
    end
end
end