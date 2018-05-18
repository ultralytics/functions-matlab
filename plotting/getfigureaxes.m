function ha = getfigureaxes(hf)
ha = findobj(hf,'type','axes','-not','tag','legend');
