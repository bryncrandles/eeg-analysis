%Finds all MI's above a certain value and returns an array that lists all
%values that exceeded the critical value

%INPUTS******
%MI: the 3D array of MI between many variables and MI between variables
%with time-delay

%critv: critical value where if MI is above this value, then that relation
%is listed in the output

%sr: Sampling rate (how many data points per millisecond) Ex. for 1 data point
%every two milliseconds you would input sr = 0.5


function sig = misignif(MI,critv,sr)
    [~,d,t] = size(MI);
    %first line of the array
    sig = ["ind" "dep" "t (time delay) in ms" "MI"];
    %checks if each value is greater than critv
    for i = 1:d
        for j = 1:d
            for k = 1:t
                if MI(i,j,k) > critv
                    newrow = [i j (k-1)/sr MI(i,j,k)];
                    sig = [sig;newrow];
                end
            end
        end
    end
end