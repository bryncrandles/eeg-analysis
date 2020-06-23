%Number of pairs of data (X,Y)
n = 1000;
%VARIABLE X
x = zeros(n,1);
mux = 0;
sdx = 1;
countx = 50; %# of bins in histogram

%generates n random N(Mu,SD) numbers
for i = 1:n
  x(i,1) = normrnd(mux,sdx);
end

%graphs X
histogram(x,countx);
[binx,edgesx] = histcounts(x,countx);
difx = diff(edgesx);

%marginal prob x
px = zeros(1,countx);
for i = 1:countx
    px(1,i) = binx(1,i)/n;
end

%calculates entropy
Hx = 0;
for i = 1:countx
    if px(1,i) ~= 0
        Hx = Hx - px(1,i)*log2(px(1,i)/difx(1));
    end
end

%estimate mean and var
smeanx = sum(x)/n;
svarx = 0;
for i = 1:n
    svarx = svarx + (x(i,1) - smeanx)^2;
end
svarx = svarx/(n-1);



%VARIABLE Y
y = zeros(n,1);
muy = 4;
sdy = 1;
county = 50; %# of bins for y histogram

%generates data for Y
for i = 1:n
    %y(i,1) = normrnd(muy,sdy); %Random N(mu,sd)
    y(i,1) = f(x(i,1),muy,sdy);  %custom dist
end

%graphs Y
histogram(y,county);
[biny,edgesy] = histcounts(y, county);
dify = diff(edgesy);


%marginal prob y
py = zeros(1,county);
for j = 1:county
    py(1,j) = biny(1,j)/n;
end

%entropy of y
Hy = 0;
for i = 1:county
    if py(1,i) ~= 0
        Hy = Hy - py(1,i)*log(py(1,i)/dify(1));
    end
end

%estimate mean and var of Y
smeany = sum(y)/n;
svary = 0;
for i = 1:n
    svary = svary + (y(i,1) - smeany)^2;
end
svary = svary/(n-1);



%BIVARIATE (X,Y)
%joint pdf p(x,y)
pxy = zeros(countx,county);
for k = 1:n
    for i = 1:countx
        for j = 1:county
            if edgesx(i)<x(k,1) && x(k,1)<edgesx(i+1) && edgesy(j)<y(k,1) && y(k,1)<edgesy(j+1)
                pxy(i,j) = pxy(i,j) + 1;
            end
        end
    end
end
pxy = pxy/n;

%mutual information of X,Y
Ixy = 0;
for i = 1:countx
    for j = 1:county
        if pxy(i,j) ~= 0
            Ixy = Ixy + pxy(i,j)*log2(pxy(i,j)/(px(1,i)*py(1,j)));
        end
    end
end



%Expected entropy of a N(0,1) variable
EH = log(sqrt(2*pi*exp(1)));

%distribution of y
%0.5 prob that Y=X, 0.5 prob that Y~N(muy,sdy)
function y = f(x, muy, sdy)
    random = rand;
    if random > 0.5
        y = x;
    else
        y = normrnd(muy,sdy);
    end
end

%Code succesfully calculates MI of two N~dist rv's
%Y depends on X
%Uses binning on a histogram method with equal bins
%Counts number of data points in each bin to calculate entropy, MI...
%**Not the most efficient or accurate way


