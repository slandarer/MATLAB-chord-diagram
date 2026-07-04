%% Change color

dataMat = rand([15, 15]);
dataMat(dataMat > .15) = 0;

% Change color
CList=[ 75,146,241; 252,180, 65; 224, 64, 10;   5,100,146; 191,191,191;
        26, 59,105; 255,227,130;  18,156,221; 202,107, 75;   0, 92,219;
       243,210,136;  80, 99,129; 241,185,168; 224,131, 10; 120,147,190]./255;

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat,'Arrow','on', 'CData',CList);
BCC = BCC.draw();

% Show ticks (添加刻度)
BCC.tickState('on')

% Set font properties (修改字体，字号及颜色)
BCC.setFont('FontName','Cambria', 'FontSize',17, 'Color',[0,0,.8])