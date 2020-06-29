%GENERATE DATA
m = 1000;
data = zeros(m,2);
mux = 30;
sdx = 5;
muy = 5;
sdy = 2;

%Creates random independent data
% for i = 1:m
%     data(i,1) = normrnd(mux,sdx);
%     data(i,2) = normrnd(muy,sdy);
% end

%Creates time-delayed data (Y depends on X at -5 seconds
for i = 1:5
    data(i,1) = normrnd(mux,sdx);
    data(i,2) = 0;
end
for i = 6:m
    data(i,1) = normrnd(mux,sdx);
    data(i,2) = data(i-5,1) + normrnd(muy,sdy);
end


%MI CALCULATION GIVEN "DATA"
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
I = -0.5*log(det(C));


%TIME DELAYED MI
%set amount of time to be delayed (y is delayed)
t = 5;
nmt = n-t;
%staggers data by t
tdata = zeros(nmt,2);
for i = 1:nmt
    tdata(i,1) = data(i,1);
    tdata(i,2) = data(i + t,2);
end

%Normalizes data
ntdata = zeros(nmt,2);
for j = 1:2
    mn = mean(tdata(:,j));
    sd = std(tdata(:,j));
    for i = 1:nmt
        ntdata(i,j) = (tdata(i,j)-mn)/sd;
    end
end

%calculates MI using Normal Gaussian formula
Ct = cov(ntdata);
It = -0.5*log(det(Ct));






