%Function used for transferring data from the results files from Compute
%Canada, into one cell variable.

%output retreives outputted data from compute canada
%x - the test subject number (subject 301 you type 1)
output = output464;
x = 64;
MI_RES_400{x,1} = "464";

%Shifts rows down and adds row of titles
output(2:4,:) = output(1:3,:);
output{1,1} = "CONDITION";
output{1,2} = "MI";
output{1,3} = "ENTROPY";

%Retrieves entropy vector from diagonal of MI array at time delay 0
%Adds entropy vector to third column
for i = 1:3
    A = output{i+1,2};
    n = length(A);
    entropy = zeros(1,n);
    for j = 1:n
        entropy(1,j) = A(j,j,1);
    end
    output{i+1,3} = entropy;
end

%Places the entire output in the overall results cell
MI_RES_400{x,2} = output(1:4,:);
