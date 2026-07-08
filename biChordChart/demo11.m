%% Reproduction of a Nature figure example

% Data source : 
% Lake, B.B., Menon, R., Winfree, S. et al. 
% An atlas of healthy and injured cell states and niches in the human kidney. 
% Nature 619, 585–594 (2023). https://doi.org/10.1038/s41586-023-05769-3
% https://www.nature.com/articles/s41586-023-05769-3
% 41586_2023_5769_MOESM9_ESM.xlsx | sheet : panel_d_chordplot
Data = readtable("41586_2023_5769_MOESM9_ESM.xlsx");
dataMat = rot90(Data.Variables, 2);
dataMat = triu(dataMat, 1);
nameList = fliplr(Data.Properties.VariableNames);
nameList = cellfun(@(s)strrep(s, '_', '-'), nameList, 'UniformOutput',false);
CList = [203,122,165; 208,112, 85; 214, 95,  1; 106,103, 90;   0,114,178; 121,171,123;
         240,228, 65; 123,199, 94;   0,160,117;  46,164,165;  85,182,231; 159,171,110; 230,157,  5]./255;

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Label',nameList, 'Rotation',pi/1.62,...
    'CData',CList, 'SSqRatio', -30/100, 'OSqRatio', 80/100, 'LRadius',1.21);
BCC = BCC.draw();

% 旋转标签 (Rotate labels)
BCC.labelRotate('none')

% 调整弦透明度 (Adjust the chords opacity)
BCC.setChord('FaceAlpha', .5)

ax=gca;
ax.XLabel.String = {'Pairwise connections in neighbourhoods'; '(1,240,569 neighbourhoods)'};
ax.XLabel.Color = 'k';
ax.XLabel.FontSize = 15;

