% demo6
% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer
dataMat=[2 0 1 2 5 1 2;
         3 5 1 4 2 0 1;
         4 0 5 5 2 4 3];
dataMat=dataMat+rand(3,7);
dataMat(dataMat<1)=0;
dataMat=dataMat.*1000;

figure('Units','normalized','Position',[.02,.05,.6,.85])
CC=chordChart(dataMat);
CC=CC.draw();
CC.setFont('FontSize',17,'FontName','Cambria')

% 显示刻度和数值
% Displays scales and numeric values
CC.tickState('on')
CC.tickLabelState('on')

% 调节标签半径
% Adjustable Label radius
CC.setLabelRadius(1.4);

% 调整数值字符串格式
% Adjust numeric string format
CC.setTickLabelFormat(@(x)sprintf('%0.1e',x))
