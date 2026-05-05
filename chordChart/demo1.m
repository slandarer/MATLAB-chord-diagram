% demo 1
% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

dataMat=[2 0 1 2 5 1 2;
         3 5 1 4 2 0 1;
         4 0 5 5 2 4 3];
colName={'B1','G2','G3','G4','G5','G6','G7'};
rowName={'S1','S2','S3'};

% 创建弦图对象(Create chord diagram object)
CC=chordChart(dataMat,'rowName',rowName,'colName',colName);
% CC=chordChart(dataMat,'rowName',rowName,'colName',colName,'Rotation',pi/3,'Sep',1/200);

% 开始绘图(Start drawing)
CC=CC.draw();

% 调整字体并显示刻度
% Set Font for labels and show ticks
CC.setFont('FontSize',17,'FontName','Cambria')
CC.tickState('on')

% CC.dataTipFormat = {'r', 'Source:', 'Target:', 'Value:', '%.2f'};
% CC.dataTipFormat = {'r', '来源:', '目标:', '数值:', '%.2f'};