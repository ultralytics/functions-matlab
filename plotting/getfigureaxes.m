% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function ha = getfigureaxes(hf)
ha = findobj(hf,'type','axes','-not','tag','legend');
