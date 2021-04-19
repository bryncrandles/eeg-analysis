%%%%Creates topoplots of CC,PL for controls, patients and controls-patients
%**Color ranges for plots ay need to be adjusted depending on if its CC or PL
%being graphed

%Load EEG
eeglab
EEG = pop_loadset('sub-301_sz_eeg_clean.set');

%Average global CC, PL across tasks
CC300 = mean(CC300Vals,2);
CC400 = mean(CC400Vals,2);
PL300 = mean(PL300Vals,2);
PL400 = mean(PL400Vals,2);

%Set up vectors so that a loop can be used
vectors = [CC300,CC400,PL300,PL400];
titles = ["Patient Avg CC (Avg across tasks) TD4","Control Avg CC (Avg across tasks) TD4","Patient Avg PL (Avg across tasks) TD4","Control Avg PL (Avg across tasks) TD4"];
savenames = ["4CC300avgcond","4CC400avgcond","4PL300avgcond","4PL400avgcond"];
ranges = cell(1,4);
ranges{1,1} = [0.34,0.37];
ranges{1,2} = [0.34,0.37];
ranges{1,3} = [6.75,9.1];
ranges{1,4} = [6.75,9.1];

%Draw topoplots
for i = 1:4
    figure;
    plot = topoplot(vectors(:,i), EEG.chanlocs, 'maplimits', ranges{1,i}); 
    hold on                                                         
    cbar('horiz', 0, ranges{1,i})
    title(titles(i))
    saveas(plot, savenames(i), 'png')
end

%Control-Patient CC
CCx00 = CC400 - CC300;
figure;
plot = topoplot(CCx00, EEG.chanlocs, 'maplimits', [-0.017 0.017]); 
hold on                                                         
cbar('horiz', 0, [-0.016, 0.016])
title('(C - P) Avg CC (Avg across tasks) TD4')
saveas(plot, '4C_PCCavgcond', 'png')

%Control-Patient PL
PLx00 = PL400 - PL300;
figure;
plot = topoplot(PLx00, EEG.chanlocs, 'maplimits', [-0.25 0.25]); 
hold on                                                         
cbar('horiz', 0, [-0.6, 0.6])
title('(C - P) Avg PL (Avg across tasks) TD4')
saveas(plot, '4C_PPLavgcond', 'png')








%%%%%%This section is used for creating topoplots of the same thing as above
%except specific to task

% %Vectors can be adjusted based on which graphs you want (Control CC
% %Resting, etc...)
% titles = ["Patient CC levels: Resting","Patient CC levels: Music","Patient CC levels: Faces"];
% savenames = ["TopoplotCC300Rest","TopoplotCC300Music","TopoplotCC300Faces"];
% 
% for i = 1:3
%     figure;
%     plot = topoplot(PL300Vals(:,i), EEG.chanlocs, 'maplimits', [2.6 3.8]); 
%     hold on                                                                   
%     cbar('horiz', 0, [2.6, 3.8])
%     title(titles(i))
%     %saveas(plot, savenames(i), 'png')
% end

% %Differences between groups for CC and PL (Task-specific)
% titles = ["(C - P) PL levels: Resting","(C - P) PL levels: Music","(C - P) PL levels: Faces"];
% savenames = ["0PLC_PResting","0PLC_PMusic","0PLC_PFaces"];
% 
% PLx00Vals = PL400Vals - PL300Vals;
% %CCx00Vals = CC400Vals - CC300Vals;
% 
% for i = 1:3
%     figure;
%     plot = topoplot(PLx00Vals(:,i), EEG.chanlocs, 'maplimits', [-0.03 0.03]); 
%     hold on                                                                   
%     cbar('horiz', 0, [-0.03 0.03])
%     title(titles(i))
%     saveas(plot, savenames(i), 'png')
% end