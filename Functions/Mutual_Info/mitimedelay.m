%Calculates MI with time delay t and k nearest neighbours
%****VECTORS MUST BE HORIZONTAL
function I = mitimedelay(x,y,t)
    [~,n] = size(x);
    %shifts x and y by t
    xprime = x(1,1:n-t);
    yprime = y(1,1+t:n);
    %calculates MI
    I = mihist(xprime,yprime);
end