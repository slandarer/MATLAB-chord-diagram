% chordDemo4

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

dataMat = [110, 13,  2,  6, 12
            18, 40, 15,  9,  6
             5, 11, 50,  6,  6
            19,  6,  4, 13,  6
            10,  4, 18, 12, 50];
CList = [247,204,138; 128,187,185; 245,135,124; 140,199,197; 252,223,164]./255;
% CList = [164,190,158; 216,213,153; 177,192,208; 238,238,227; 249,217,153]./255;

NameList={'CHORD','CHART','MADE','BY','SLANDARER'};

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Arrow','on', 'CData',CList, 'Sep',1/30, 'Label',NameList, 'LRadius',1.33);
BCC = BCC.draw();
BCC.tickState('on')
% Modify squares and chords color (修改方块颜色及弦颜色)
BCC.setSquareColor(CList, CList./1.2)
BCC.setChord('FaceAlpha',.7)
BCC.setChordColorBySquareS()
% Modify the font, font size, and color (修改字体，字号及颜色)
BCC.setFont('FontName','Cambria', 'FontSize',17)
BCC.tickLabelState('on')
BCC.setTickFont('FontName','Cambria', 'FontSize',9)