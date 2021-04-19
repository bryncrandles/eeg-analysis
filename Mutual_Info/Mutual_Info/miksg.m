%ESTIMATION OF MI BETWEEN X AND Y

%VECTORS X,Y MUST BE HORIZONTAL AND EQUAL LENGTH
%k: number of nearest neighbours to use (4 is usually a good # to use)


function Ixy = miksg(x,y,k)
    %retrieve n from one of the vectors
    [~,n] = size(x);
    
    %array for helping with the sum in MI formula
    array1 = zeros(1,n);

    %creates array of distances between all points
    dist = zeros(n,n);
    for j = 1:n
        for i = j:n
            dist(i,j) = sqrt((x(i)-x(j))^2 + (y(i)-y(j))^2);
            dist(j,i) = dist(i,j);
        end
        %sets dist between a point and itself to nan since we don't
        %consider it for nearest neighbour
        dist(j,j) = nan;
    end

    for j = 1:n
        %determines which points (vector p) are the closest
        %p is a vector containing locations of k nearest neighbours
        [~,p] = mink(dist(j,:),k);

        %determines epsilon values of nearest neighbour (biggest difference
        %in x and biggest difference among the y's)
%         disp(k)
        ep = zeros(2,k);
        for i = 1:k
            ep(1,i) = abs(x(p(i)) - x(j));
            ep(2,i) = abs(y(p(i)) - y(j));
        end
        epx = max(ep(1,:));
        epy = max(ep(2,:));

        %count up nx
        ub = x(j) + epx;  %bounds
        lb = x(j) - epx;
        nx = sum(x <= ub & x >= lb) - 1;
        %(Subtract 1 so that we exclude the point itself)

        %count up ny
        ub = y(j) + epy; %changes bounds for y
        lb = y(j) - epy;
        ny = sum(y <= ub & y >= lb) - 1;

        %Computes the part of the MSG eq involving nx and ny
        array1(1,j) = psi(nx) + psi(ny);
    end

    %KSG formula 2 for MI
    Ixy = psi(k) - 1/k - mean(array1) + psi(n);
end