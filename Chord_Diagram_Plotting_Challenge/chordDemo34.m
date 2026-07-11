% chordDemo34

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

rng(1)
dataMat = randi([0, 1], [6, 10]);
CList = [223,147,166; 250,231,232; 180,208,231; 134,157,199]./255;
CList = interp1([0,.33,.66,1], CList, linspace(0, 1, size(dataMat, 1)));
rowName = {'Row-chord diagram','Row-chordChart','Row-slandarer','Row-made by','Row-MATLAB','Row-function'};
colName = compose('Col-%d', sort(randi([10000, 99999], [1, 10])));

figure('Units','normalized', 'Position',[.02,.05,.5,.85])
CC = chordChart(dataMat, 'RowName',rowName, 'ColName',colName, 'Sep',1/120, ...
    'SRadius',[1, 1.1], 'LRadius',1.12, 'Rotation',pi/2, 'GroupSep',1/80);
CC.draw()

CC.labelRotate('on')
CC.setFont('FontSize',15)
CC.setSquareColorS(CList)
CC.setChordColorBySquareS()
CC.setSquareS('LineWidth',1, 'EdgeColor','k')
CC.setSquareT('LineWidth',1, 'EdgeColor','k', 'FaceColor',[180,180,180]./255)
CC.setChord('LineWidth',1, 'EdgeColor','k', 'FaceAlpha',1)
set(CC.labelSHdl, 'Visible','off')


set(gca, 'DataAspectRatio',[.9,1,1])
legend(CC.squareSHdl, rowName, 'FontSize',15, 'LineWidth',1, 'EdgeColor','k')