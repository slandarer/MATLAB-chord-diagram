%% Chord chart with label rotated

dataMat = randi([0, 8], [6, 6]);

% Add names for each node (添加标签名称)
nameList = {'CHORD','CHART','MADE','BY','SLANDARER','MATLAB'};

figure('Units','normalized','Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Label',nameList, 'Arrow','on');
BCC = BCC.draw(); 

% Show ticks (添加刻度)
BCC.tickState('on')

% Set font properties (修改字体，字号及颜色)
BCC.setFont('FontName','Cambria','FontSize',17,'Color',[.2,.2,.2])

% version 1.1.0更新
% 函数labelRotate用来旋转标签
% The function labelRatato is used to rotate the label
BCC.labelRotate('on')

% BCC.setLabelRadius(1.3);
% BCC.tickLabelState('on')

