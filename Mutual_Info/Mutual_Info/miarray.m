%Mutual information of a data set given breakpoints, etc using histogram
%binning method
%Also estimates MI of time-lagged data shifted up to parameter t (maxdelay)
%Function was created for estimating MI of EEG data

%INPUTS******
%data: dataset of the certain condition we are interested in (Data should 
%have factors sorted vertically and the observations for each factor
%running horizontally)

%breakpoints: vector of all breakpoints to be considered within 'data'
%Note* breakpoints vector should have 0 as the first element since that is
%the way the breakpoint vector was made for the coherence function
%Ex. [0, 200, 789, 4800]

%tms: max time delay to analyze in milliseconds
%sr: Sampling rate (how many data points per second)

%avgrate: rate to take MI estimate of and then average over all estimates
%in milliseconds.  ex.  use 4000 to take average MI of each 4 second chunk.
%4000 recommended for histogram binning method to get accurate results

%OUTPUT******
%3D Matrix is outputted showing MI of each variable with all the others and
%then extending into the third dimension to show time-delayed MI
%(,,1) is the MI array with no time delay and then (,,2) onwards shows time
%delayed MI, where the index of the matrix is one integer ahead of the time
%delay.  Ex. (,,4) shows MI with a time difference of 3

%The interpretation for time delay is that the number in the array shows
%the MI of the x-var(horizontal) between the y-var(vertical) say 20ms ago


function MIarray = miarray(data,breakpoints,tms,sr,avgrate)
    %Initializes some variables
    sr = sr/1000;
    maxdelay = floor(tms*sr);
    avgrate = avgrate*sr;
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
            %Loop for between breakpoints%
            for m = 1:bp
                %Retrieves data from between breakpoints
                x = data(i,breakpoints(m)+1:breakpoints(m+1)-1);
                y = data(j,breakpoints(m)+1:breakpoints(m+1)-1);
                [~,n] = size(x);
                
                if n > 2*maxdelay
                    %g is number of chunks of data to be averaged over
                    g = floor(n/avgrate);
                    if g > 0
                        for q = 1:g
                            %isolates the chunk of data to have MI estimated
                            %and then estimates it and adds it to overall sum
                            xsub = x(1,1+avgrate*(q-1):avgrate*q);
                            ysub = y(1,1+avgrate*(q-1):avgrate*q);
                            A(m,1) = A(m,1) + mihist(xsub,ysub);
                            %estimates MI time-delayed for each chunk as well
                            for t = 1:maxdelay
                                A(m,t+1) = A(m,t+1) + mitimedelay(xsub,ysub,t);
                            end
                        end
                        %Takes average by dividing by g
                        A(m,:) = A(m,:)/g;
                    elseif g == 0
                        %This section runs if the size of a chunk is less than
                        %"avgrate".  Since we are using binning method we
                        %ignore chunks that are too small since the binning
                        %method may not be accurate for them

%This section can be uncommented if you wish to not set to 0 by default
%                         A(m,1) = mihist(x,y);
%                         for t = 1:maxdelay
%                             A(m,t+1) = mitimedelay(x,y,t);
%                         end
                        A(m,1) = 0;
                        for t = 1:maxdelay
                            A(m,t+1) = 0;
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