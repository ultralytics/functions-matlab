function h=plotBoundingBox(x,varargin)
%Plots bounding box on current axis
%Bounding Box defined by: [x y width height]

h=plot(x(1)+x(3)*[0 1 1 0 0],x(2)+x(4)*[0 0 1 1 0],'y-','LineWidth',2,varargin{:});

