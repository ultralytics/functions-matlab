function y = NNwaveformStats(x,dim)
if nargin==1; dim=1; end
xmin=min(x,[],dim);
xmax=max(x,[],dim);
range = xmax-xmin;

y=[xmin xmax range var(x,[],dim,'omitnan') mean(abs(x),dim,'omitnan') mean(x,dim,'omitnan')];

