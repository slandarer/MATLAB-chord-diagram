%% Basic usage

dataMat = [2 0 1 2 5 1 2;
           3 5 1 4 2 0 1;
           4 0 5 5 2 4 3];
colName = {'B1','G2','G3','G4','G5','G6','G7'};
rowName = {'S1','S2','S3'};

% Create and render chord diagram object (创建弦图对象并渲染)
CC = chordChart(dataMat, 'RowName',rowName, 'ColName',colName, 'Arrow','on');
CC.LinearMinorTick = 'on';
CC.draw();

% Set Font for labels and show ticks (调整字体并显示刻度)
CC.setFont('FontSize',17, 'FontName','Cambria')
CC.tickState('on')
CC.tickLabelState('on')

% CC.dataTipFormat = {'r', 'Source:', 'Target:', 'Value:', '%.2f'};
% CC.dataTipFormat = {'r', '来源:', '目标:', '数值:', '%.2f'};
