% chordDemo6

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer
rng(2)

dataMat = randi([0,40], [20,4]);
dataMat(rand([20,4]) < .2) = 0;
dataMat(1,3) = 500;
dataMat(20,1:4) = [140; 150; 80; 90];

colName = compose('T%d', 1:4);
rowName = compose('SL%d', 1:20);

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
CC = chordChart(dataMat, 'rowName',rowName, 'colName',colName, 'Sep',1/80, 'LRadius',1.23);
CC = CC.draw();
% 修改上方方块颜色(Modify the color of the blocks above)
CListT = [0.62,0.49,0.27; 0.28,0.57,0.76
          0.25,0.53,0.30; 0.86,0.48,0.34];
for i = 1:size(dataMat, 2)
    CC.setSquareT_N(i, 'FaceColor',CListT(i,:))
end
% 修改下方方块颜色(Modify the color of the blocks below)
CListF = [0.94,0.84,0.60; 0.16,0.50,0.67; 0.92,0.62,0.49;
    0.48,0.44,0.60; 0.48,0.44,0.60; 0.71,0.79,0.73;
    0.96,0.98,0.98; 0.51,0.82,0.95; 0.98,0.70,0.82;
    0.97,0.85,0.84; 0.55,0.64,0.62; 0.94,0.93,0.60;
    0.98,0.90,0.85; 0.72,0.84,0.81; 0.85,0.45,0.49;
    0.76,0.76,0.84; 0.59,0.64,0.62; 0.62,0.14,0.15;
    0.75,0.75,0.75; 1.00,1.00,1.00];
for i = 1:size(dataMat, 1)
    CC.setSquareF_N(i, 'FaceColor',CListF(i,:))
end
CC.setSquareF_N(size(dataMat, 1), 'EdgeColor','k', 'LineWidth',1)
% 修改弦颜色(Modify chord color)
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        CC.setChordMN(i,j, 'FaceColor',CListT(j,:), 'FaceAlpha',.46)
    end
end

CC.tickState('on')
CC.labelRotate('on')
CC.setFont('FontSize',17, 'FontName','Cambria')