function [X,Y] = fcnrotatehist2(X,Y)
%this function detrends a histogram
%Z=zeros(size(X));

F = fit(X, Y, 'poly1');
Y=Y-F(X);


%rpy = fcnVEC2RPY(vec);
%XYZ = fcnrotateB2W(rpy(1),rpy(1),rpy(1),[X Y Z]);
%X=XYZ(:,1); Y=XYZ(:,2);

end