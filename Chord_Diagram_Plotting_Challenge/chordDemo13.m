% chordDemo13

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer
clc;clear
rng(2)

dataMat = randi([1,40], [7,4]);
dataMat(rand([7,4]) < .1) = 0;

colName = compose('MATLAB%d', 1:4);
rowName = compose('SL%d', 1:7);

figure('Units','normalized', 'Position',[.02,.05,.7,.85])
CC = chordChart(dataMat, 'rowName',rowName, 'colName',colName, 'Sep',1/80, 'LRadius',1.32, 'TickMode','auto');
CC = CC.draw();
% 修改上方方块颜色(Modify the color of the blocks above)
CListT = [0.49,0.64,0.53
    0.75,0.39,0.35
    0.80,0.74,0.42
    0.40,0.55,0.66];
for i = 1:size(dataMat, 2)
    CC.setSquareT_N(i, 'FaceColor',CListT(i,:))
end
% 修改下方方块颜色(Modify the color of the blocks below)
CListF = [0.91,0.91,0.97
    0.62,0.95,0.66
    0.91,0.61,0.20
    0.54,0.45,0.82
    0.99,0.76,0.81
    0.91,0.85,0.83
    0.53,0.42,0.43];
for i = 1:size(dataMat, 1)
    CC.setSquareF_N(i, 'FaceColor',CListF(i,:))
end
% 修改弦颜色(Modify chord color)
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        CC.setChordMN(i,j, 'FaceColor',CListT(j,:), 'FaceAlpha',.46)
    end
end

CC.tickState('on')
CC.tickLabelState('on')
CC.setFont('FontSize',17, 'FontName','Cambria')
CC.setTickFont('FontSize',8, 'FontName','Cambria')


% 绘制图例(Draw legend)
for i = 1:size(dataMat,1)
    scatterHdl(i) = scatter(10.*ones(size(dataMat,1),1),10.*ones(size(dataMat,1),1),55, 'filled');
end
for i = 1:length(scatterHdl)
    scatterHdl(i).CData = CListF(i,:);
end
lgdHdl = legend(scatterHdl, rowName, 'Location','best', 'FontSize',16, 'FontName','Cambria', 'Box','off');
set(lgdHdl, 'Position',[.77,.38,.1658,.27])