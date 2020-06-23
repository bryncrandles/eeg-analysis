%Number of pairs of data (X,Y)
n = 10000;
%Max integer for X and Y
maxx = 2;
maxy = 2;

%Generates X
x = randi(maxx,n,1);

%generates Y
y = zeros(n,1);
for i = 1:n
    y(i,1) = f(x(i,1),maxy);
end

%marginal p(x)
p = zeros(maxx,1);
for i = 1:maxx
    p(i,1) = sum(x(:)== i)/n;
end

%marginal q(y)
q = zeros(maxy,1);
for j = 1:maxy
    q(j,1) = sum(y(:)== j)/n;
end

%entropy of X and Y
Hx = 0;
for i = 1:maxx
    if p(i,1) ~= 0
        Hx = Hx - p(i,1)*log2(p(i,1));
    end
end
Hy = 0;
for j = 1:maxy
    if q(j,1) ~= 0
        Hy = Hy - q(j,1)*log2(p(j,1));
    end
end

%joint dist: p(x,y)
pxy = zeros(maxx,maxy);
for k = 1:n
    for i = 1:maxx
        for j = 1:maxy
            if x(k,1)== i && y(k,1)== j
                pxy(i,j) = pxy(i,j) + 1;
            end
        end
    end
end
pxy = pxy/n;

%mutual information of (X,Y)
Ixy = 0;
for i = 1:maxx
    for j = 1:maxy
        Ixy = Ixy + pxy(i,j)*log2(pxy(i,j)/(p(i,1)*q(j,1)));
    end
end

%Expected value of Ixy
EIxy = 2*0.375*log2(0.375/0.25) + 2*0.125*log2(0.125/0.25);

%distribution of y
%0.5 that Y=X, 0.5 that Y=1,2
function y = f(x, maxy)
    random = rand;
    if random > 0.5
        y = x;
    else
        y = randi(maxy);
    end
end


%The program calculates MI (Ixy) correctly
%E(Ixy) was calculated by hand on paper and computed in this code
%As n>>> Ixy estimate converges to E(Ixy)
