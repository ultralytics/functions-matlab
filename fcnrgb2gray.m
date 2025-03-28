% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function J = fcnrgb2gray(I)
if isinteger(I)
    %coef = [0.298936021293776         0.587043074451121         0.114020904255103];
    %J = imapplymatrix(coef, I, class(X));
    J = rgb2graymex(I); %only works with uint8
else % uint8 or uint16    
    coef = [0.298936021293776         0.587043074451121         0.114020904255103];
    s = size(I);
    rgbv = reshape(I(:),s(1)*s(2),3);
    J = rgbv * coef';
    J = reshape(J,s(1:2));
end
