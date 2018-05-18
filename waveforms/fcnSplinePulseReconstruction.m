function y = fcnSplinePulseReconstruction(y,ceiling) %RECONSTRUCT PULSES
%y = [256 30], 256 samples x 30 channels

%INTERPOLATE
[nr, nc]=size(y);
if all([nr nc]==size(ceiling))
    ys = ceiling; %ceiling is logical matrix. Replace 1's
else
    ys = y>=ceiling | isnan(y); %ceiling is scalar threshold
end
ys([1 nr],:)=false; %don't use first or last values

if any(ys(:))
    y([1 nr],:)=0; %prevent window ends from influencing neighboring channels
    %np  = 2; %desired number of interpolation points to left and right
    
    yt=(circshift(ys,1) | circshift(ys,-1) | circshift(ys,2) | circshift(ys,-2)) & ~ys;     %yt=fcnsmooth(ys,np*2+1) & ~ys; %good points
    i=find(yt);  F=griddedInterpolant(i,y(i),'spline','none'); %DOUBLES NEEDED HERE!
    j=find(ys);  yj=F(j);  y(j)=yj;
    
%     [rs,cs]=fcnind2sub([nr nc],j); A=sparse(rs,cs,double(yj),nr,nc); k=sum(A)./sum(A~=0)<-100;
%     if any(k) %redo negative pulses
%         ys(:,~k)=0;
%         ys = ys | circshift(ys,-1,1) | circshift(ys,1,1); %dilate
%         yt=(circshift(ys,1) | circshift(ys,-1) | circshift(ys,2) | circshift(ys,-2)) & ~ys;     %yt=fcnsmooth(ys,np*2+1) & ~ys; %good points
%         
%         i=find(yt);  F=griddedInterpolant(i,y(i),'spline','none'); %DOUBLES NEEDED HERE!
%         j=find(ys);  y(j)=F(j);
%         
%         %fig(1,2,1.5); sca; plot(y0(:,k),'.-'); sca; plot(y(:,k),'.-');
%     end
end

%fig; plot(y(:,381),'.-'); plot(y0(:,381),'.-'); axis tight; fcnmarkersize(12)


%TEST
%fig; plot(y)
%i=find(min(y)<-2000); i=i(1);
%fig(2,1); sca; plot(y(:,i),'.-'); sca; plot(y0(:,i),'.-');
%x=1:256; plot(x(ys(:,i)),y0(ys(:,i),i),'ro')