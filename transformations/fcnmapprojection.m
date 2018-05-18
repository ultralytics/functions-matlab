function [rm,cm] = fcnmapprojection(rm,cm,projection)
lambda  = cm*d2r;   %x longitudes (deg) i.e. size 360x180
phi     = rm*d2r;   %y latitudes (deg) i.e. size 360x180
    

switch projection
    case 'mollweid'
        %[rm, cm] = projfwd('mollweid', phi, lambda); NOT WORKING
    case 'cylindrical'
        cm = lambda;
        rm = phi;
    case 'sinusoidal'
        cm = lambda.*cos(phi);
        rm = phi;
    case 'winkeltripel' %national geographic style
        a = acos(cos(phi).*cos(lambda/2));
        cm = .5*(lambda.*2/pi + ((2*cos(phi).*sin(lambda/2))./(sin(a)./a)));
        rm = .5*(phi + sin(phi)./(sin(a)./a));
    case 'northpole' %orthographic http://en.wikipedia.org/wiki/Orthographic_projection_in_cartography
        lambda0=0;  phi0=pi/2;  R = 1;
        cm = R*cos(phi).*sin(lambda-lambda0);
        rm = R*( cos(phi0)*sin(phi) - sin(phi0)*cos(phi).*cos(lambda - lambda0) );
        i=phi<0;  cm(i)=nan; rm(i)=nan;
    case 'southpole' %orthographic http://en.wikipedia.org/wiki/Orthographic_projection_in_cartography
        lambda0=0;  phi0=-pi/2;  R = 1;
        cm = R*cos(phi).*sin(lambda-lambda0);
        rm = R*( cos(phi0)*sin(phi) - sin(phi0)*cos(phi).*cos(lambda - lambda0) );
        i=phi>0;  cm(i)=nan; rm(i)=nan;
    otherwise
        sprintf('WARNING: Unrecognized map projection in ''fcnmapprojection.m''\n')
        cm = lambda;
        rm = phi;
end
rm = rm*r2d;
cm = cm*r2d;
