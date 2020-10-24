
% eeglab
% EEG = pop_loadset('sub-301_sz_eeg_clean.set');

CC300 = mean(CC300Vals,2);
CC400 = mean(CC400Vals,2);
PL300 = mean(PL300Vals,2);
PL400 = mean(PL400Vals,2);

vectors = [CC300,CC400,PL300,PL400];
titles = ["Patient Avg CC (Avg across tasks) TD4","Control Avg CC (Avg across tasks) TD4","Patient Avg PL (Avg across tasks) TD4","Control Avg PL (Avg across tasks) TD4"];
savenames = ["4CC300avgcond","4CC400avgcond","4PL300avgcond","4PL400avgcond"];
ranges = cell(1,4);
ranges{1,1} = [0.34,0.37];
ranges{1,2} = [0.34,0.37];
ranges{1,3} = [6.75,9.1];
ranges{1,4} = [6.75,9.1];

for i = 1:4
    figure;
    plot = topoplot(vectors(:,i), EEG.chanlocs, 'maplimits', ranges{1,i}); %PL Range:2.6 3.8
    hold on                                                         %CC Range:0.19 0.24
    cbar('horiz', 0, ranges{1,i})
    title(titles(i))
    saveas(plot, savenames(i), 'png')
end

%C-P CC
CCx00 = CC400 - CC300;
figure;
plot = topoplot(CCx00, EEG.chanlocs, 'maplimits', [-0.017 0.017]); %PL Range:+-0.25
hold on                                                         %CC Range:+-0.015
cbar('horiz', 0, [-0.016, 0.016])
title('(C - P) Avg CC (Avg across tasks) TD4')
saveas(plot, '4C_PCCavgcond', 'png')

%C-P PL
PLx00 = PL400 - PL300;
figure;
plot = topoplot(PLx00, EEG.chanlocs, 'maplimits', [-0.25 0.25]); %PL Range:+-0.25
hold on                                                         %CC Range:+-0.015
cbar('horiz', 0, [-0.6, 0.6])
title('(C - P) Avg PL (Avg across tasks) TD4')
saveas(plot, '4C_PPLavgcond', 'png')









% 
% titles = ["Patient PL levels: Resting","Patient PL levels: Music","Patient PL levels: Faces"];
% %titles = ["Patient CC levels: Resting","Patient CC levels: Music","Patient CC levels: Faces"];
% %savenames = ["TopoplotCC300Rest","TopoplotCC300Music","TopoplotCC300Faces"];
% 
% for i = 1:3
%     figure;
%     plot = topoplot(PL300Vals(:,i), EEG.chanlocs, 'maplimits', [2.6 3.8]); %PL Range:0.14 0.19
%     hold on                                                                   %CC Range:0.18 0.27
%     cbar('horiz', 0, [2.6, 3.8])
%     title(titles(i))
%     %saveas(plot, savenames(i), 'png')
% end

% %Differences between groups for CC and PL
% titles = ["(C - P) PL levels: Resting","(C - P) PL levels: Music","(C - P) PL levels: Faces"];
% savenames = ["TopoplotPLRest","TopoplotPLMusic","TopoplotPLFaces"];
% 
% PLx00Vals = PL400Vals - PL300Vals;
% %CCx00Vals = CC400Vals - CC300Vals;
% 
% for i = 1:3
%     figure;
%     plot = topoplot(PLx00Vals(:,i), EEG.chanlocs, 'maplimits', [-0.013 0.013]); %PL Range:-0.013 0.013
%     hold on                                                                   %CC Range:-0.025 0.025
%     cbar('horiz', 0, [-0.013 0.013])
%     title(titles(i))
%     saveas(plot, savenames(i), 'png')
% end