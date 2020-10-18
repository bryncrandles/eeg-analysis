%Calculate CC and PL for each of the 129 nodes and for controls and
%patients
%Column 1 is Resting, 2 is Music, 3 is Faces

addpath('SWP(1)')
load('MI_RES_300.mat')
load('MI_RES_400.mat')

%%%%Patients
%Matrices for final results
CC300Vals = zeros(129,3);
PL300Vals = zeros(129,3);
for j = 1:3
    %Reset temporary matrices for each condition
    CCtemp = zeros(129,1);
    PLtemp = zeros(129,1);
    for i = 1:42
        %%Retrieve data matrix
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
        
        %%Calculate CC
        CCtemp = [CCtemp clustering_coef_matrix(A,'Z')];
        
        %%Calculate PL
        A = sparse(A);
        D = graphallshortestpaths(A);
        for l = 1:129
            for k = 1:129
                if isinf(D(l,k)) == 1
                    D(l,k) = 0;
                end
            end
        end
        PLtemp = [PLtemp mean(D,2)];
    end
    %Remove first column of 0's and then take average
    CCtemp = CCtemp(:,2:43);
    CC300Vals(:,j) = mean(CCtemp,2);
    PLtemp = PLtemp(:,2:43);
    PL300Vals(:,j) = mean(PLtemp,2);
end



%%%%Controls
%Removes missing rows
MI_RES_400sub = MI_RES_400([1:5,7,9:28,30:34,36,38:53,55,57:73,75:78,80:81],:);

%Matrices for final results
CC400Vals = zeros(129,3);
PL400Vals = zeros(129,3);
for j = 1:3
    %Reset temporary matrices for each condition
    CCtemp = zeros(129,1);
    PLtemp = zeros(129,1);
    for i = 1:72
        %%Retrieve data matrix
        A = MI_RES_400sub{i,2}{j+1,2}(:,:,1);
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
        
        %%Calculate CC
        CCtemp = [CCtemp clustering_coef_matrix(A,'Z')];
        
        %%Calculate PL
        A = sparse(A);
        D = graphallshortestpaths(A);
        for l = 1:129
            for k = 1:129
                if isinf(D(l,k)) == 1
                    D(l,k) = 0;
                end
            end
        end
        PLtemp = [PLtemp mean(D,2)];
    end
    %Remove first column of 0's and then take average
    CCtemp = CCtemp(:,2:73);
    CC400Vals(:,j) = mean(CCtemp,2);
    PLtemp = PLtemp(:,2:73);
    PL400Vals(:,j) = mean(PLtemp,2);
end

%Save results
dlmwrite('CC300Vals.txt',CC300Vals)
dlmwrite('CC400Vals.txt',CC400Vals)
dlmwrite('PL300Vals.txt',PL300Vals)
dlmwrite('PL400Vals.txt',PL400Vals)