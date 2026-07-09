% chordDemo22

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer


dataMat = randi([0, 10], [4, 20]);
colName = compose('SLAN-%d', 1:20);
rowName = compose('UTAR-CoNS%d', 1:4);

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
CC = chordChart(dataMat, 'RowName',rowName, 'ColName',colName, 'Sep',1/100, ...
    'TickMode','linear', 'TRadius',1.12, 'SRadius',[1.02,1.1], 'LRadius',1.24);
CC.LinearMinorTick = 'on';
CC = CC.draw();
CC.labelRotate('on')
CC.tickState('on')
CC.tickLabelState('on')
% Modify the color of the blocks below (修改下方方块颜色)
CListS = [255,141,6; 128,253,213; 17,253,255; 100,149,237]./255;
CC.setSquareColorS(CListS)
% Modify the color of the blocks above (修改上方方块颜色)
CListT = repmat(linspace(.7, .3, 20).', [1, 3]);
CC.setSquareColorT(CListT)
% Modify chord color (修改弦颜色)
CC.setChordColorBySquareS()