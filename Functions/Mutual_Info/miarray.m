%Mutual information of a data set given breakpoints, etc using the KSG
%method
%Also estimates MI of time-lagged data shifted up to parameter t (maxdelay)

%INPUTS******
%data: dataset of the certain condition we are interested in (Data should 
%have factors sorted vertically and the observations for each factor
%running horizontally)

%breakpoints: vector of all breakpoints to be considered within 'data'
%Note* breakpoints vector should have 0 as the first element since that is
%the way the breakpoint vector was made for the coherence function
%Ex. [0, 200, 789, 4800]

%k: number of nearest neighbours for calculation (4 is generally good)
%tms: max time delay to analyze in milliseconds
%sr: Sampling rate (how many data points per second)

%avgrate: to save time, each block of data is divided into chunks of a
%certain length and then an average of those estimates is taken for the
%final estimate. avgrate is the size of data you would like to partition
%the data into in milliseconds. Ex. Input 1000 as avgrate to just calculate
%MI for each second of data and then average all the seconds' MIs together

%OUTPUT******
%3D Matrix is outputted showing MI of each variable with all the others and
%then extending into the third dimension to show time-delayed MI
%(,,1) is the MI array with no time delay and then (,,2) onwards shows time
%delayed MI, where the index of the matrix is one integer ahead of the time
%delay.  Ex. (,,4) shows MI with a time difference of 3

%The interpretation for time delay is that the number in the array shows
%the MI of the x-var(horizontal) between the y-var(vertical) say 20ms ago


function MIarray = miarray(data,breakpoints,k,tms,sr,avgrate)
    %Initializes some variables
    sr = sr/1000;
    maxdelay = floor(tms*sr);
    chunk = avgrate*sr;
    [d,~] = size(data);
    [~,bp] = size(breakpoints);
    bp = bp - 1;
    MIarray = zeros(d,d,maxdelay+1);
    
    for i = 1:d
        for j = 1:d
            %Temporary Matrix for storing MI of each block of data in between
            %breakpoints
            A = zeros(bp,maxdelay+1);

            %Calculates and stores each block of data in A
            for m = 1:bp
                %Retrieves data from between breakpoints
                x = data(i,breakpoints(m)+1:breakpoints(m+1)-1);
                y = data(j,breakpoints(m)+1:breakpoints(m+1)-1);
                [~,n] = size(x);
                
                if n > 2*maxdelay
                    %g is number of chunks of data to be averaged over
                    g = floor(n/chunk);
                    if g > 0
                        for q = 1:g
                            %isolates the chunk of data to have MI estimated
                            %and then estimates it and adds it to overall sum
                            xsub = x(1,1+chunk*(q-1):chunk*q);
                            ysub = y(1,1+chunk*(q-1):chunk*q);
                            A(m,1) = A(m,1) + mi(xsub,ysub,k);
                            %estimates MI time-delayed for each chunk as well
                            for t = 1:maxdelay
                                A(m,t+1) = A(m,t+1) + mitimedelay(xsub,ysub,t,k);
                            end
                        end
                        %Takes average by dividing by g
                        A(m,:) = A(m,:)/g;
                    elseif g == 0
                        %This section runs if the size of a chunk is less than
                        %"chunk".  Then it just takes regular MI of that
                        %section as well as time-delayed MI
                        A(m,1) = mi(x,y,k);
                        for t = 1:maxdelay
                            A(m,t+1) = mitimedelay(x,y,t,k);
                        end
                    end
                else
                    A(m,1) = 0;
                    for t = 1:maxdelay
                        A(m,t+1) = 0;
                    end
                end
            end
            
            %displays data in 3D matrix by averaging columns of A
            MIarray(i,j,1) = sum(A(:,1))/sum(A(:,1)~=0);
            for t = 1:maxdelay
                MIarray(i,j,t+1) = sum(A(:,t+1))/sum(A(:,t+1)~=0);
            end
        end
    end
end