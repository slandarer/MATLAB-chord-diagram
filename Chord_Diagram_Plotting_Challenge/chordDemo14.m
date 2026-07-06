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
NameList={'CHORD', 'CHART', 'AND', 'BICHORD',...
    'CHART', 'MADE', 'BY', 'SLANDARER'};

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Arrow','on', 'CData',CList, 'Sep',1/12, 'Label',NameList, 'LRadius',1.33,'TickMode','auto');
BCC = BCC.draw();

% 添加刻度
BCC.tickState('on')

% 修改弦颜色(Modify chord color)
for i = 1:size(dataMat, 1)
    BCC.setChordN(i, 'FaceAlpha',.7, 'EdgeColor',CList(i,:)./1.1)
end
% 修改方块颜色(Modify the color of the blocks)
for i = 1:size(dataMat, 1)
    BCC.setSquare(i, 'EdgeColor',CList(i,:)./1.7)
end

% 修改字体，字号及颜色
BCC.setFont('FontName','Cambria', 'FontSize',17)
BCC.tickLabelState('on')
BCC.setTickFont('FontName','Cambria', 'FontSize',9)

% 调整数值字符串格式
% Adjust numeric string format
BCC.setTickLabelFormat(@(x)[num2str(round(x*100)),'%'])