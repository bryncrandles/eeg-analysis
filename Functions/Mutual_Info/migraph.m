%input time delay matrix of MI and independant and dependant variable
%This function returns a graph of the dependance of one variable to the
%other over time

function migraph(MIarray,ind,dep)
    %retrieves total amount of time-delays
    [~,~,t] = size(MIarray);
    %creates two vectors to be plotted
    x = 0:t-1;
    y = MIarray(ind,dep,:);
    %plots MI over time
    scatter(x,y,'filled');
    ylabel('Mutual Information');
    xlabel(['Dependence of var ' num2str(dep) ' on var ' num2str(ind) ' over time']);
end