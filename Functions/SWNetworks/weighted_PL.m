%%Calculates weighted characteristic path length (wPL) of a network
%Uses dijkstra's algorithm to compute all shortest path lengths, then uses
%the formula for wPL from Muldoon, Bridgeford and Bassett's paper: "Small-
%World Propensity and Weighted Brain Networks

%%Input: 
%weightedgraph: should be a symmetrical (square obviously) array 
%containing weights of each connection between node i and j

%%Outputs value of weighted characteristic path length (wPL)

function wPL = weighted_PL(weightgraph)

% maxw = max(max(weightgraph))
A = weightgraph;
[~,n] = size(A);

%Creats matrix to contain the shortest distances between all points
sh_paths = zeros(n,n);

for i = 1:n
    %Visited matrix for keeping track of visited nodes
    %Visited -> 1, Unvisited -> 0
    %Starts with all points unvisited except point i which is the starting
    %point
    visit = zeros(1,n);
    visit(i) = 1;
    
    %takes direct route to each point to be shortest distance to start and
    %sets distance to itself to 0
    sh_paths(i,:) = A(i,:);
    sh_paths(i,i) = 0;
    
    %checks each iteration that there are still unvisited nodes
    while ismember(0,visit) == 1
        %determines next-closest node to visit
        temp = sh_paths(i,:);
        temp(visit == 1) = nan;
        [~,currentp] = min(temp);
        
        %indexes current node as visited
        visit(currentp) = 1;
        
        %calculates distances from starting point to each unvisited node
        dist = A(currentp,:);
        dist(visit==1) = nan;
        dist = dist + sh_paths(i,currentp);
        %if a new path is shorter, replaces the old dist with the shorter one
        for j = 1:n
            if dist(j) < sh_paths(i,j)
                sh_paths(i,j)=dist(j);
            end
        end
    end
end

%Having calculated all shortest path lengths we can use the formula for
%average weighted path length
% wPL = sh_paths;
wPL = sum(sum(sh_paths))/(n*(n-1));
end