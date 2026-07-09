% chordDemo28

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer


dataMat = randi([1, 20], [6, 3]);
rowName = compose('Row%d', 1:6);
colName = compose('Col%d', 1:3);
cmp = [.62,0.0,.26; .84,.24,.31; .96,.43,.26; .99,.68,.38; 1.0,.88,.55;
       1.0,1.0,.75; .90,.96,.60; .67,.87,.64; .40,.76,.65; .20,.53,.74; .37,.31,.64];
cmp = interp1(linspace(0, 1, size(cmp, 1)), cmp, linspace(0, 1, numel(dataMat)));

CC = chordChart(dataMat, 'RowName',rowName, 'ColName',colName, ...
    'TickMode','linear', 'TRadius',1.08, 'SRadius',[1.02,1.082], 'LRadius',1.2);
CC.LinearMinorTick = 'on';
CC.CData = [38,140,221; 0,64,115]./255;
CC.draw();
CC.tickState('on')
CC.tickLabelState('on')
% Set properties for labels, tick lines, squares, and chords
CC.setFont('FontSize',17)
CC.setTick('LineWidth',1)
CC.setSquareS('EdgeColor','k', 'LineWidth',1)
CC.setSquareT('EdgeColor','k', 'LineWidth',1)
CC.setChord('FaceAlpha',.7, 'EdgeColor','k', 'LineWidth',1)
CC.setChordCData(reshape(linspace(0, 1, numel(dataMat)), size(dataMat)))
clim([0, 1]); colormap(cmp)