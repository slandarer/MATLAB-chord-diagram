% demo5

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

dataMat=[2 0 1 2 5 1 2;
         3 5 1 4 2 0 1;
         4 0 5 5 2 4 3];
colName={'G1','G2','G3','G4','G5','G6','G7'};
rowName={'S1','S2','S3'};

figure('Units','normalized','Position',[.02,.05,.6,.85])
CC=chordChart(dataMat,'rowName',rowName,'colName',colName);
CC=CC.draw();
CC.setFont('FontSize',17,'FontName','Cambria')

% 显示刻度和数值
% Displays scales and numeric values
CC.tickState('on')
CC.tickLabelState('on')

CC.setTickFont('Color',[0,0,.8],'FontName','Cambria')

% 调节标签半径
% Adjustable Label radius
CC.setLabelRadius(1.3);


% figure()
% dataMat=[2 0 1 2 5 1 2;
%          3 5 1 4 2 0 1;
%          4 0 5 5 2 4 3];
% dataMat=dataMat+rand(3,7);
% dataMat(dataMat<1)=0;
% 
% CC=chordChart(dataMat,'rowName',rowName,'colName',colName);
% CC=CC.draw();
% CC.setFont('FontSize',17,'FontName','Cambria')
% 
% % 显示刻度和数值
% % Displays scales and numeric values
% CC.tickState('on')
% CC.tickLabelState('on')
% 
% % 调节标签半径
% % Adjustable Label radius
% CC.setLabelRadius(1.4);