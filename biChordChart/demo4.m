%% Displays scales and numeric values

dataMat = [5, 1, 0, 2;
           0, 7, 6, 3;
           1, 3, 4, 1;
           7, 6, 8, 8];

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Arrow','on');
BCC = BCC.draw();

% Set font properties (修改字体，字号及颜色)
BCC.setFont('FontName','Cambria', 'FontSize',17)

% 调节标签半径
% Adjustable Label radius
BCC.setLabelRadius(1.3);

% 显示刻度和数值
% Displays scales and numeric values
BCC.tickState('on')
BCC.tickLabelState('on')

BCC.setTickFont('FontName','Cambria','Color',[0,0,.6])

%% 
figure('Units','normalized', 'Position',[.02,.05,.6,.85])
dataMat = [5.213 1.231 0.000 2.835;
           0.000 7.674 6.565 3.085;
           1.534 3.676 4.467 1.654;
           7.647 6.111 8.772 8.561];
BCC = biChordChart(dataMat, 'Arrow','on');
BCC = BCC.draw();

% Set font properties (修改字体，字号及颜色)
BCC.setFont('FontName','Cambria', 'FontSize',17)

% 调节标签半径
% Adjustable Label radius
BCC.setLabelRadius(1.4);

% 显示刻度和数值
% Displays scales and numeric values
BCC.tickState('on')
BCC.tickLabelState('on')


