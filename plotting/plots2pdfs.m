function plots2pdfs()

for i=1:100
    if isgraphics(i)
        figure(i);
        fprintf('Processing Figure %g...',i); tic
        
        
        %         %orient landscape ;
        %         orient portrait
        %         set(gcf, 'PaperPositionMode', 'manual');
        %         set(gcf, 'PaperUnits', 'inches');
        %         set(gcf, 'PaperPosition', [0 0 11 8.5]);
        %         set(gcf, 'PaperPosition', [0 0 8.5 11]);
        %         print -dpdf -painters
        
        %export_fig(gcf,'-nocrop',sprintf('figure%g.pdf',i))
        export_fig(gcf,'-q95','-r200','-a1',sprintf('figure%g.pdf',i))
        %fprintf(' Done (%.1fs)\n',toc)
    end
end
end