% chordDemo17

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

% Data source : 
% Lake, B.B., Menon, R., Winfree, S. et al. 
% An atlas of healthy and injured cell states and niches in the human kidney. 
% Nature 619, 585–594 (2023). https://doi.org/10.1038/s41586-023-05769-3
% https://www.nature.com/articles/s41586-023-05769-3
% 41586_2023_5769_MOESM9_ESM.xlsx | sheet : panel_d_chordplot
dataMat = [0, 1.6e5, 6.2e5, 5.7e5, 5.9e6, 1.0e6, 2.0e6, 4.6e4, 3.9e5, 2.9e5, 1.2e7, 3.5e4, 1.9e6;
           0,     0,     0, 3.0e5,     0, 1.4e6,     0, 2.0e0, 5.7e3,     0, 3.5e4, 4.6e3, 5.0e4;
           0,     0,     0,     0, 1.5e6,     0, 5.4e5,     0, 5.4e4, 7.0e4, 9.2e4, 9.3e2, 5.5e4;
           0,     0,     0,     0, 4.4e3, 4.9e6, 1.5e3, 3.8e5, 1.1e5,     0, 6.6e4, 1.8e4, 1.1e5;
           0,     0,     0,     0,     0, 1.1e3, 4.8e6,     0, 4.5e5, 4.7e5, 7.1e5, 1.1e5, 4.3e5;
           0,     0,     0,     0,     0,     0, 1.0e3, 1.5e5, 1.7e5,     0, 1.5e5, 3.0e4, 2.2e5;
           0,     0,     0,     0,     0,     0,     0,     0, 8.2e4, 1.5e5, 3.2e5, 1.1e4, 1.3e5;
           0,     0,     0,     0,     0,     0,     0,     0, 1.3e2,     0, 3.3e4,     0, 3.0e4;
           0,     0,     0,     0,     0,     0,     0,     0,     0, 9.8e4, 1.0e5, 6.8e3, 5.5e4;
           0,     0,     0,     0,     0,     0,     0,     0,     0,     0, 2.5e5, 1.9e3, 3.3e5;
           0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0, 1.8e3, 6.5e5;
           0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0, 3.8e3;
           0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0];
nameList = {'Altered', 'CD', 'C-DN', 'DTL', 'PT', 'M-TAL', 'C-TAL', 'VB', 'Vessel', 'Glom', 'CD3', 'CD68', 'MPO'};
CList = [203,122,165; 208,112, 85; 214, 95,  1; 106,103, 90;   0,114,178; 121,171,123;
         240,228, 65; 123,199, 94;   0,160,117;  46,164,165;  85,182,231; 159,171,110; 230,157,  5]./255;

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Label',nameList, 'Rotation',pi/1.62,...
    'CData',CList, 'SSqRatio', -30/100, 'OSqRatio', 80/100, 'LRadius',1.21);
BCC = BCC.draw();
BCC.labelRotate('none')
BCC.setChord('FaceAlpha', .5)

ax=gca;
ax.XLabel.String = {'Pairwise connections in neighbourhoods'; '(1,240,569 neighbourhoods)'};
ax.XLabel.Color = 'k';
ax.XLabel.FontSize = 15;
