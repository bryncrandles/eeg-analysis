%Calculates SWP value of 3 conditions for all 42 patients and saves results
%in a text file.
%Requires the Small World Propensity package

SWPvals = zeros(42,3);
dc = zeros(42,3);
dl = zeros(42,3);

for i = 1:42
    for j = 1:3
        A = MI_RES_300{i,2}{j+1,2}(:,:,6);
        %Symmetrizes by averaging points ij and ji
        for k = 1:129
            for l = k:129
                A(k,l) = (A(k,l) + A(l,k))/2;
                A(l,k) = A(k,l);
            end
        end

        %Set diagonal values to 0
        for k = 1:129
            A(k,k) = 0;
        end
        
        %Input value into swpvals and into MI Results
        [SWPvals(i,j),dc(i,j),dl(i,j)] = small_world_propensity(A,'Z');
    end
end 

dlmwrite('SWPvals.txt',SWPvals)