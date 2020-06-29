%GENERATE DATA
n = 25;
data = zeros(n,2);

%Creates random independent data
for i = 1:n
    data(i,1) = normrnd(5,2);
    data(i,2) = normrnd(5,2);
end


%scatterplot of data
scatter(data(:,1),data(:,2));

%set number of nearest neighbours
k = 3;

%determines which point: p is the closest
dist = zeros(n,1);
dist(:,1) = sqrt((data(:,1)-data(1,1)).^2 + (data(:,2)-data(1,2)).^2);
dist(dist==0) = nan;
[mindist,p] = mink(dist,k);

%determines epsilon values of nearest neighbour
ep = zeros(k,2);
for i = 1:k
    ep(i,1) = abs(data(p(i),1) - data(1,1));
    ep(i,2) = abs(data(p(i),2) - data(1,2));
end
epx = max(ep(:,1));
epy = max(ep(:,2));

%count up nx
nx = 0;
ub = data(1,1) + epx;  %bounds
lb = data(1,1) - epx;
for i = 1:n
    if i ~= 1
        if lb < data(i,1) && data(i,1) < ub
            nx = nx + 1;
        end
    end
end
xline(ub);
xline(lb);

%count up ny
ny = 0;
ub = data(1,2) + epy; %changes bounds for y
lb = data(1,2) - epy;
for i = 1:n
    if i ~= 1
        if lb < data(i,2) && data(i,2) < ub
            ny = ny + 1;
        end
    end
end
yline(ub);
yline(lb);
axis equal;
