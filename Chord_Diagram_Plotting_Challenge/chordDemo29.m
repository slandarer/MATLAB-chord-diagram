% chordDemo29

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

rng(6)
dataMat = randi([0, 6], [6, 8]).*[1; 1; 10; 10; 6; 2];


CList = [233,142, 45; 225,127,176;  51, 59,121; 
          53,147,117; 164,213,146; 243,146,149]./255;

CC = chordChart(dataMat, 'Sep',1/120, 'SRadius',[1.02, 1.15], ...
    'LRadius',1.18, 'SSqRatio',.1, 'OSqRatio',.6, 'Arrow','on');
CC.RowName = compose('row-id-%d', randi([100,999], [1,6]));
CC.ColName = compose('col-id-%d', randi([100,999], [1,8]));
CC.draw()

CC.labelRotate('on')
CC.setSquareColorS(CList)
[~, tind] = max(dataMat, [], 1);
CC.setSquareColorT(CList(tind, :))
CC.setChordColorBySquareS()
CC.setSubSquareT('FaceColor','w')
CC.setFont('FontSize',17)

plot([-1.3, 1.3], [0, 0], 'LineWidth',2, 'LineStyle','--', 'Color','k')