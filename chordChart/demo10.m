%% Linear ticks

rng(1)
dataMat = randi([0,5], [14,3]);
colName = compose('T%d', 1:3);
rowName = compose('F%d', 1:14);

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
% TickMode 'value'(default)/'linear'/auto
CC = chordChart(dataMat, 'RowName',rowName, 'ColName',colName, 'TickMode','linear');

% 刻度的设置要在draw()之前
% the setting of tick should before draw()
% 刻度的紧密程度，数值越高刻度线数量越多
% The compact degree of ticks, The higher the value, the more scales there are
CC.linearTickCompactDegree = 2.5;
% 是否开启次刻度线
% Minor ticks 'on'/'off'
CC.linearMinorTick = 'on';

CC = CC.draw();
CC.setFont('FontSize',17, 'FontName','Cambria')

% 显示刻度和数值
% Displays scales and numeric values
CC.tickState('on')
CC.tickLabelState('on')
CC.setTickFont('FontName','Cambria')

% 调节标签半径
% Adjustable Label radius
CC.setLabelRadius(1.3);

