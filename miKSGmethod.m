%GENERATE DATA
m = 5000;
data = zeros(m,2);

%Creates random independent data
for i = 1:m
    data(i,1) = normrnd(0,4);
    %data(i,2) = normrnd(1,1);
    %data(i,2) = f(data(i,1),muy,sdy);
    %data(i,2) = data(i,1);
end

%MI CALCULATION GIVEN "DATA"
%retrieve n-obs and d-dim
[n,d] = size(data);

k = 3;
array1 = zeros(n,1);

for j = 1:n
    %determines which point: p is the closest
    dist = zeros(n,1);
    dist(:,1) = sqrt((data(:,1)-data(j,1)).^2 + (data(:,2)-data(j,2)).^2);
    dist(dist==0) = nan;
    [mindist,p] = mink(dist,k);

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
    ub = data(j,2) + epy; %changes bounds for y
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

%0.5 prob that Y=X, 0.5 prob that Y~N(muy,sdy)
function y = f(x, muy, sdy)
    random = rand;
    if random > 0.5
        y = x;
    else
        y = normrnd(muy,sdy);
    end
end

