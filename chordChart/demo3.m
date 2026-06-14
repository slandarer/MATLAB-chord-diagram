%% Use Sep to decrease sap between block/square nodes 

dataMat=randi([0,1],[20,10]); 

% 使用 sep 减小空隙
% Use Sep to decrease sap between block/square nodes (separation)
CC=chordChart(dataMat,'Sep',1/120);
CC=CC.draw();



CC.tickState('on')

% version 1.7.0更新
% 函数labelRatato用来旋转标签
% The function labelRatato is used to rotate the label
CC.labelRotate('on')


