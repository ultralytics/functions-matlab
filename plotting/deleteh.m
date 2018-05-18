function [] = deleteh(h)
%deletes object handles, checking to make sure the handle is valid first
delete(h(isgraphics(h)))

    
