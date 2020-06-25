%GENERATE DATA
n = 15;
data = zeros(n,2);
mux = 5;
muy = 5;
sdx = 2;
sdy = 2;

%Creates random independent data
for i = 1:n
    data(i,1) = normrnd(mux,sdx);
    data(i,2) = normrnd(muy,sdy);
end



%scatterplot of data
scatter(data(:,1),data(:,2));

%determines which point: p is the closest
mindist = 1000000000;
for i = 1:n
    if i ~= 1
        dist = sqrt((data(i,1)-data(1,1))^2 + (data(i,2)-data(1,2))^2);
%         if mindist == 0   %sets first distance
%             mindist = dist;
%         end
        if dist < mindist
            mindist = dist;
            p = i;
        end
    end
end
%determines epsilon values of nearest neighbour
epx = abs(data(p,1) - data(1,1));
epy = abs(data(p,2) - data(1,2));
ep = max(epx,epy);
%count up nx
nx = 0;
ub = data(1,1) + ep;  %bounds
lb = data(1,1) - ep;
for k = 1:n
    if k ~= 1
        if lb < data(k,1) && data(k,1) < ub
            nx = nx + 1;
        end
    end
end
xline(ub);
xline(lb);

%count up ny
ny = 0;
ub = data(1,2) + ep; %changes bounds for y
lb = data(1,2) - ep;
for k = 1:n
    if k ~= 1
        if lb < data(k,2) && data(k,2) < ub
            ny = ny + 1;
        end
    end
end
yline(ub);
yline(lb);
axis equal;