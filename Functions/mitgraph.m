%calculates and plots MI(t) for two given vectors x,y
%VECTORS MUST BE OF EQUAL SIZE
%k:number of nearest neighbours

function v = mitgraph(x,y,k)
    [~,n] = size(x);
    %sets max time delay to half of the observations to keep sample size of
    %time delayed vectors still large
    maxdelay = n/2;
    %v is a set of points (t,MI)
    v = zeros(maxdelay,2);
    for t = 1:maxdelay
        I = mitimedelay(x,y,t,k);
        v(t,1) = t;
        v(t,2) = I;
    end
    %plots (t,MI)
    scatter(v(:,1),v(:,2));
%     data = [x',y'];
%     Ixy = mi(data,k);
%     plot(0,Ixy);
end

%Calculates MI with time delay t and k nearest neighbours
function I = mitimedelay(x,y,t,k)
    [~,n] = size(x);
    %creates matrix of the two vectors shifted by t
    group = zeros(n-t,2);
    group(:,1) = x(1,1:n-t)';
    group(:,2) = y(1,1+t:n)';
    %calculates MI
    I = mi(group,k);
end
