%% Use Sep to decrease sap between block/square nodes 

dataMat = randi([0, 1], [20, 10]); 

% Use Sep to decrease separation between block/square nodes (使用 Sep 减小空隙)
CC = chordChart(dataMat, 'Sep',1/120);
CC = CC.draw();

% version 1.7.0 update:
% The function labelRatato is used to rotate the label (函数 labelRatato 用来旋转标签)
CC.labelRotate('on')

CC.tickState('on')


