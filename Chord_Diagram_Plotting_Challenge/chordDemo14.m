% chordDemo14

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

rng(6)
dataMat = randi([1,20], [8,8]);
dataMat(dataMat > 5) = 0;
dataMat(1,:) = randi([1,15], [1,8]);
dataMat(1,8) = 40;
dataMat(8,8) = 60;
dataMat = dataMat./sum(sum(dataMat));

CList = [.33,.53,.86; .94,.50,.42; .92,.58,.30; .59,.47,.45;
         .37,.76,.82; .82,.68,.29; .75,.62,.87; .43,.69,.57];
nameList = {'CHORD', 'CHART', 'AND', 'BICHORD',...
    'CHART', 'MADE', 'BY', 'SLANDARER'};

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Arrow','on', 'CData',CList, 'Sep',1/12, 'Label',nameList, 'LRadius',1.33,'TickMode','auto');
BCC = BCC.draw();
BCC.tickState('on')
% Modify squares and chords color (修改方块颜色及弦颜色)
BCC.setSquareColor(CList, CList./1.5)
BCC.setChord('FaceAlpha',.7)
BCC.setChordColorBySquareS()
% Modify the font, font size, and color (修改字体，字号及颜色)
BCC.setFont('FontName','Cambria', 'FontSize',17)
BCC.tickLabelState('on')
BCC.setTickFont('FontName','Cambria', 'FontSize',9)
% Adjust numeric string format (调整数值字符串格式)
BCC.setTickLabelFormat(@(x)[num2str(round(x*100)),'%'])