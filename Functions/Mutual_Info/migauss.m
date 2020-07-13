%MI CALCULATION GIVEN "DATA"
%This function calculates MI of two variables when we can assume that they follow a
%Gaussian distribution

function Ixy = migauss(data)
    %retrieve n-obs and d-dim
    [n,d] = size(data);

    %Normalizes data
    ndata = zeros(n,d);
    for j = 1:d
        mn = mean(data(:,j));
        sd = std(data(:,j));
        for i = 1:n
            ndata(i,j) = (data(i,j)-mn)/sd;
        end
    end

    %calculates MI using normal Gaussian formula
    C = cov(ndata);
    Ixy = -0.5*log(det(C));
end