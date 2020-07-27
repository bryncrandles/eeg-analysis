%%Calculates weighted clustering coefficient of a network
%Uses formula from Zhang and Horvath in their paper: "A General Framework
%for Weighted Gene Co-Expression Network Analysis" (page 24-25)

%%Input: 
%weightedgraph: should be a symmetrical (square obviously) array 
%containing weights of each connection between node i and j

%%Outputs value of weighted clustering coefficient (wCC)

function wCC = weighted_CC(weightgraph)
    %retrieve max weight
    maxw = max(max(weightgraph));  
    
    %Normalizes weights so they range from 0 to 1
    w = weightgraph/maxw;
    
    %retrieve number of nodes
    [~,n] = size(w);
    %Define vector for storing the local CC of each node
    localw = zeros(1,n);
    
    for i = 1:n
        %%Sum in the numerator of local clustering coefficient formula
        num = 0;
        for j = 1:n
            for k = 1:n
                if i ~= j && j ~= k && k ~= i
                    num = num + w(i,j)*w(j,k)*w(i,k);
                end
            end
        end
        %%Calculate denominator term
        %Temporary matrix to store normalized weight squared
        squarew = w(i,:).^2;
        den = (sum(w(i,:))-w(i,i))^2 - (sum(squarew)-squarew(i));
        
        %Final value for local CC of node i
        localw(1,i) = num/den;
    end
    
    %Global wCC calculated by averaging all local wCC's
    wCC = mean(localw);

end