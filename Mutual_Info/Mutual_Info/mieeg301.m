%set paths
addpath('/home/burmd','/scratch/burmd','/scratch/burmd/Mutual_Info','/scratch/burmd/eeglab2019_1','/scratch/burmd/EEGData')

eeglab

%import data
EEG = pop_loadset('sub-301_sz_eeg_clean.set')

cond = ext_all_cond(EEG)
%Retrieve number of different conditions
[n,~] = size(cond);
%Create output cell
output301 = cell(n,2);

%Computes MI matrices for each condition mentioned
%Here I am only computing the first three conditions
%Outputs condition name and MI array next to it
for i = 1:3
    output301{i,1} = cond{i,1};
end
parfor i = 1:3
    bpoints = unique(cond{i,3});
    output301{i,2} = miarray(cond{i,2},bpoints,50,EEG.srate,4000);
end

save('mieeg301.mat','output301')

exit
