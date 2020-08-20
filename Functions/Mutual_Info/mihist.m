%Estimate Mutual Information by histogram binning method

%Inputs: x,y are the vectors of data to find the MI of
%Output: Ixy: the estimated MI of the two variables

function Ixy = mihist(x,y)

n = length(x);

%Separates data into histogram bins (default 8)
nbins = 8;
[binx,edgesx] = histcounts(x,nbins);
[biny,edgesy] = histcounts(y,nbins);

%Marginal Distributions
px = binx/n;
py = biny/n;

%joint probability dist
pxy = zeros(8,8);
for k = 1:n
    for i = 1:nbins
        for j = 1:nbins
            if edgesx(i)<x(1,k)&&x(1,k)<edgesx(i+1) && edgesy(j)<y(1,k)&&y(1,k)<edgesy(j+1)
                pxy(i,j) = pxy(i,j) + 1;
            end
        end
    end
end
pxy = pxy/n;

%Estimation of MI
Ixy = 0;
for i = 1:nbins
    for j = 1:nbins
        if pxy(i,j) ~= 0
            Ixy = Ixy + pxy(i,j)*log2(pxy(i,j)/(px(i)*py(j)));
        end
    end
end

end
