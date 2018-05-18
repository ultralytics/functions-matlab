function h = fhistogram(varargin)
x=varargin{1};

x=fcnsigmarejection(x,5,3);

varargin{1}=x;
h=histogram(varargin{1:nargin});
h.DisplayName = sprintf(' %.3g\\pm%.3g',nanmean(x),nanstd(x)); %legend show
%h.EdgeColor='none';


histNfit(h.BinEdges(1:end-1)/2+h.BinEdges(2:end)/2,h.Values,'b'); %COMMENT THIS OUT



