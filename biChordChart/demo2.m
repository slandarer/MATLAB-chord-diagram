%% Chord chart with label

dataMat = randi([0, 8], [6, 6]);

% Add names for each node (添加标签名称)
NameList = {'CHORD','CHART','MADE','BY','SLANDARER','MATLAB'};
BCC = biChordChart(dataMat, 'Label',NameList, 'Arrow','on', 'CData',bone(9));
BCC = BCC.draw();

% Show ticks (添加刻度)
BCC.tickState('on')

% Set font properties (修改字体，字号及颜色)
BCC.setFont('FontName','Cambria','FontSize',17,'Color',[0,0,.8])