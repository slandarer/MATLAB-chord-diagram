%% Basic use of bichord chart

dataMat = randi([0,8], [5,5]);

% Create bichord chart object and draw (创建并绘制双向弦图对象)
BCC = biChordChart(dataMat, 'Arrow','on');
BCC = BCC.draw();

% Show ticks and tick labels (添加刻度)
BCC.tickState('on')
BCC.tickLabelState('on')

% Set font properties (修改字体，字号及颜色)
BCC.setFont('FontName','Cambria','FontSize',17)

BCC.dataTipFormat = {'r', 'Source:', 'Target:', 'Value:', '%.2f'};
% BCC.dataTipFormat = {'r', '来源:', '目标:', '数值:', '%.2f'};
