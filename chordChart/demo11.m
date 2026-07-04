%% The automatic adjustment of scale density

rng(1)
dataMat = randi([0,5], [14,3]);
colName = compose('T%d', 1:3);
rowName = compose('F%d', 1:14);

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
% TickMode 'value'(default)/'linear'/auto
CC = chordChart(dataMat, 'RowName',rowName, 'ColName',colName, 'TickMode','auto');

CC = CC.draw();
CC.setFont('FontSize',17, 'FontName','Cambria')

% Displays scales and numeric values (显示刻度和数值)
CC.tickState('on')
CC.tickLabelState('on')
CC.setTickFont('FontName','Cambria')

% Adjust Label radius (调节标签半径)
CC.setLabelRadius(1.3);
