function migraph(mi,ind,dep)
    [~,~,t] = size(mi);
    x = 0:t-1;
    y = mi(ind,dep,:);

    scatter(x,y,'filled');
    ylabel('Mutual Information');
    xlabel(['Dependence of var ' num2str(dep) ' on var ' num2str(ind) ' over time']);
end