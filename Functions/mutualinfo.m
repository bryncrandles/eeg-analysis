%Mutual information of a data set given breakpoints, etc using the KSG
%method

%Also calculates MI of time lagged data shifted up to parameter t

%data: dataset of the certain condition we are interested in
%breakpoints: vector of all breakpoints to be considered within 'data'
%k: number of nearest neighbours for calculation (4 is generally good)

%Note: breakpoints vector should have 0 as the first element since that is
%the way the breakpoint vector was made for the coherence function


function MIarray = mutualinfo(data,breakpoints,k,maxdelay)
    [d,~] = size(data);
    [~,bp] = size(breakpoints);
    MIarray = zeros(d,d,maxdelay+1);
    
    for i = 1:d
        for j = 1:d
            %Temporary Matrix for storing MI of each block of data
            A = zeros(1,bp-1);
            %Temp matrix for storing MI of each block of time lagged data
            B = zeros(maxdelay,bp-1);
            
            %Calculates and stores each block of data
            for m = 1:(bp-1)
                %No time lag MI
                group = [data(i,breakpoints(m)+1:breakpoints(m+1)-1)',data(j,breakpoints(m)+1:breakpoints(m+1)-1)'];
                A(1,m) = mi(group,k);
                
                %time lag MI up to maxdelay input
                for t = 1:maxdelay                   
                    I = mitimedelay(group(:,1),group(:,2),t,k);
                    B(t,m) = I;
                end
            end
            
            %displays data in 3D matrix
            MIarray(i,j,1) = mean(A);
            for t = 1:maxdelay
                MIarray(i,j,t+1) = mean(B(t,:));
            end
        end
    end
end



%MI CALCULATION GIVEN "DATA"
%****DATA MUST BE VERTICAL (FACTORS HORIZONTAL,TRIALS VERTICAL)
function Ixy = mi(data,k)
    %retrieve n-obs and d-dim
    [n,~] = size(data);
    
    %array for helping with the sum in MI formula
    array1 = zeros(n,1);

    for j = 1:n
        %determines which points (vector p) are the closest
        dist = zeros(n,1);
        dist(:,1) = sqrt((data(:,1)-data(j,1)).^2 + (data(:,2)-data(j,2)).^2);
        dist(dist==0) = nan;
        [~,p] = mink(dist,k);

        %determines epsilon values of nearest neighbour
        ep = zeros(k,2);
        for i = 1:k
            ep(i,1) = abs(data(p(i),1) - data(j,1));
            ep(i,2) = abs(data(p(i),2) - data(j,2));
        end
        epx = max(ep(:,1));
        epy = max(ep(:,2));

        %count up nx
        nx = 0;
        ub = data(j,1) + epx;  %bounds
        lb = data(j,1) - epx;
        for i = 1:n
            if i ~= j
                if lb <= data(i,1) && data(i,1) <= ub
                    nx = nx + 1;
                end
            end
        end

        %count up ny
        ny = 0;
        ub = data(j,2) + epy; %changes bounds for ny
        lb = data(j,2) - epy;
        for i = 1:n
            if i ~= j
                if lb <= data(i,2) && data(i,2) <= ub
                    ny = ny + 1;
                end
            end
        end

        %Computes the part of the MSG eq involving nx and ny
        array1(j,1) = psi(nx) + psi(ny);
    end

    %KSG formula 2 for MI
    Ixy = psi(k) - 1/k - mean(array1) + psi(n);
end

%Calculates MI with time delay t and k nearest neighbours
%****DATA MUST BE VERTICAL (FACTORS HORIZONTAL,TRIALS VERTICAL)
function I = mitimedelay(x,y,t,k)
    [n,~] = size(x);
    %creates matrix of the two vectors shifted by t
    group = zeros(n-t,2);
    group(:,1) = x(1:n-t,1);
    group(:,2) = y(1+t:n,1);
    %calculates MI
    I = mi(group,k);
end