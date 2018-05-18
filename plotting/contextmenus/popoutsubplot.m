function popoutsubplot(hin, hout)
%copies axes hin to axes hout
%fcncontextmenuexpand(gca)

switch nargin
    case 0
        for i=1:100
            fprintf('click origin axes... ')
            keydown = waitforbuttonpress;  if keydown~=0; break; end; %if not mouse click, exit
            hin = gca;
            
            fprintf('click destination axes...\n')
            keydown = waitforbuttonpress;  if keydown~=0; break; end
            hout = gca;
            
            fcncopyaxes(hin,hout)
        end
        fprintf('Finished\n')
        
    case 1
        hout = fig(1,1,2);
        fcncopyaxes(hin,hout)
    case 2
        if isempty(hin) %only destination axes defined, user needs to click origin axes
            fprintf('click origin axes... ')
            keydown = waitforbuttonpress;  %if keydown~=0; return; end; %if not mouse click, exit
            if keydown==0
                hin = gca;
            end
        end
        fcncopyaxes(hin,hout);
end



