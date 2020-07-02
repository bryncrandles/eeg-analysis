%MI CALCULATION GIVEN "DATA"
function Ixy = mi(data)
    %retrieve n-obs and d-dim
    [n,~] = size(data);

    %k-number of nearest neighbours
    k = 4;
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