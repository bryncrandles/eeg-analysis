
%function takes in MI array and a critical value and returns an array
%displaying all mi's that exceed the critical value
function sig = misignif(MI,critv)
    [~,d,t] = size(MI);
    %first line of the array
    sig = ["ind" "dep" "t" "MI"];
    %checks if each value is greater than critv
    for i = 1:d
        for j = 1:d
            for k = 1:t
                if MI(i,j,k) > critv
                    newrow = [i j k MI(i,j,k)];
                    sig = [sig;newrow];
                end
            end
        end
    end
end