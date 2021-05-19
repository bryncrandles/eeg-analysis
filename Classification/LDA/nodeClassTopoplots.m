% addpath('eeglab2019_1')
% eeglab
% EEG = pop_loadset('sub-301_sz_eeg_clean.set');

range = [0.55 0.60];
%CC
acc = dlmread('CCnodeacc.txt');

figure;
plot = topoplot(acc(:,1), EEG.chanlocs, 'maplimits', [0.25 0.75]);
hold on
cbar('horiz', 0, range)
title('Node Classification for CC')
saveas(plot, 'ClassificationCC', 'png')

% PL
acc = dlmread('PLnodeacc.txt');

figure;
plot = topoplot(acc(:,1), EEG.chanlocs, 'maplimits', [0.25 0.75]);
hold on
cbar('horiz', 0, range)
title('Node Classification for PL')
saveas(plot, 'ClassificationPL', 'png')

%CC PL
acc = dlmread('CCPLnodeacc.txt');

figure;
plot = topoplot(acc(:,1), EEG.chanlocs, 'maplimits', [0.25 0.75]);
hold on
cbar('horiz', 0, range)
title('Node Classification for CC & PL')
saveas(plot, 'ClassificationCCPL', 'png')