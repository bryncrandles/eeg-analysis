%Load MI Results for Patients
load('MI_RES_300.mat')
load('MI_RES_400.mat')
addpath(genpath('ept_TFCE-matlab-master'))
%Add paths for TFCE functions and EEG lab
% addpath('/scratch/burmd','Mutual_Info',genpath('ept_TFCE-matlab-master'),'eeglab2019_1')

%re-mex files
mex -setup
mex ept_TFCE-matlab-master/TFCE/Dependencies/ept_mex_TFCE2D.c -compatibleArrayDims
mex ept_TFCE-matlab-master/TFCE/Dependencies/ept_mex_TFCE3D.c -compatibleArrayDims
mex ept_TFCE-matlab-master/TFCE/Dependencies/ept_mex_TFCE.c -compatibleArrayDims

%load file to get channel locations
eeglab
EEG = pop_loadset('sub-301_sz_eeg_clean.set');

%Group differences
%Resting
RestSchiz = zeros(42,129);
for i = 1:42
    RestSchiz(i,:) = MI_RES_300{i,2}{2,3};
end
RestSchiz(:,:,2) = RestSchiz(:,:,1);

RestContr = zeros(81,129);
for i = 1:81
    if i==6||i==8||i==29||i==35||i==37||i==54||i==56||i==74||i==79 
        disp('missing datafile')
    else
        RestContr(i,:) = MI_RES_400{i,2}{2,3};
    end
end
RestContr([6,8,29,35,37,54,56,74,79],:) = [];
RestContr(:,:,2) = RestContr(:,:,1);

%Music
MusicSchiz = zeros(42,129);
for i = 1:42
    MusicSchiz(i,:) = MI_RES_300{i,2}{3,3};
end
MusicSchiz(:,:,2) = MusicSchiz(:,:,1);

MusicContr = zeros(81,129);
for i = 1:81
    if i==6||i==8||i==29||i==35||i==37||i==54||i==56||i==74||i==79 
        disp('missing datafile')
    else
        MusicContr(i,:) = MI_RES_400{i,2}{3,3};
    end
end
MusicContr([6,8,29,35,37,54,56,74,79],:) = [];
MusicContr(:,:,2) = MusicContr(:,:,1);
%Faces
FacesSchiz = zeros(42,129);
for i = 1:42
    FacesSchiz(i,:) = MI_RES_300{i,2}{4,3};
end
FacesSchiz(:,:,2) = FacesSchiz(:,:,1);

FacesContr = zeros(81,129);
for i = 1:81
    if i==6||i==8||i==29||i==35||i==37||i==54||i==56||i==74||i==79 
        disp('missing datafile')
    else
        FacesContr(i,:) = MI_RES_400{i,2}{4,3};
    end
end
FacesContr([6,8,29,35,37,54,56,74,79],:) = [];
FacesContr(:,:,2) = FacesContr(:,:,1);


%Use TFCE code on group differences data and save results
%Resting
restingtfce = ept_TFCE(RestContr,RestSchiz,EEG.chanlocs)
save('tfceResting.mat','restingtfce')
%Music
musictfce = ept_TFCE(MusicContr,MusicSchiz,EEG.chanlocs)
save('tfceMusic.mat','musictfce')
%Faces
facestfce = ept_TFCE(FacesContr,FacesSchiz,EEG.chanlocs)
save('tfceFaces.mat','facestfce')

