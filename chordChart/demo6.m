%% Adjust numeric string format for tick label
dataMat = [2 0 1 2 5 1 2;
           3 5 1 4 2 0 1;
           4 0 5 5 2 4 3];
dataMat = dataMat + rand(3, 7);
dataMat(dataMat < 1) = 0;
dataMat = dataMat.*1000;

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
CC = chordChart(dataMat);
CC = CC.draw();
CC.setFont('FontSize',17,'FontName','Cambria')

% Displays scales and numeric values (显示刻度和数值)
CC.tickState('on')
CC.tickLabelState('on')

% Adjust Label radius (调节标签半径)
CC.setLabelRadius(1.4);

% Adjust numeric string format (调整数值字符串格式)
CC.setTickLabelFormat(@(x)sprintf('%0.1e',x))
