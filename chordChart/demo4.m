%% Colormap

dataMat=[2 0 1 2 5 1 2;
         3 5 1 4 2 0 1;
         4 0 5 5 2 4 3];
colName={'G1','G2','G3','G4','G5','G6','G7'};
rowName={'S1','S2','S3'};

CC=chordChart(dataMat,'RowName',rowName,'ColName',colName, 'LRadius',1.28);
CC=CC.draw();

% version 1.7.0更新
% 可使用colormap函数直接修改颜色
% Colors can be adjusted directly using the function colormap(demo4)

colormap(flipud(pink))


