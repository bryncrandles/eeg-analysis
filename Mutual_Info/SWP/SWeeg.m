%Calculates SWP value of 3 conditions for all 42 patients and saves results
%in a text file.
%Requires the Small World Propensity package
addpath('SWP(1)')
load('MI_RES_300.mat') %*Results files from calculating MI arrays
load('MI_RES_400.mat')

%%%%300
SWPvals = zeros(42,3);
for i = 1:42
    for j = 1:3
        A = MI_RES_300{i,2}{j+1,2}(:,:,1);
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
        [SWPvals(i,j),~,~] = small_world_propensity(A,'Z');
    end
end
dlmwrite('SWP300vals.txt',SWPvals)


%%%%400
SWPvals = zeros(81,3);
for i = 1:81
    if i==6||i==8||i==29||i==35||i==37||i==54||i==56||i==74||i==79 
        disp('missing dataset')
    else
        for j = 1:3
            A = MI_RES_400{i,2}{j+1,2}(:,:,5);
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
            [SWPvals(i,j),~,~] = small_world_propensity(A,'Z');
        end
    end
end 
dlmwrite('SWP400vals4.txt',SWPvals)


