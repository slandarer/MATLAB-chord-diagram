%% Set properties for squares and chord ribbons

dataMat=[2 0 1 2 5 1 2;
         3 5 1 4 2 0 1;
         4 0 5 5 2 4 3];
colName={'G1','G2','G3','G4','G5','G6','G7'};
rowName={'S1','S2','S3'};

CC=chordChart(dataMat,'RowName',rowName,'ColName',colName);
CC=CC.draw();

% 弦属性设置 ===============================================================
% Set the properties for all chords
CC.setChordProp('EdgeColor',[.3,.3,.3],'LineStyle',':','LineWidth',.1)

% Change colormap for old vision:
% CC.setChordColorByMap(flipud(gray(100)))

% Change colormap for new vision
colormap(flipud(gray(100)))


% 设置连接下方第二个节点和上方第四个节点的弦
% Set the properties for the chord which
% connect 2nd block bellow 
% and 4th block above
CC.setChordMN(2,4,'FaceColor',[1,0,0])




% 方块属性设置 =============================================================
% setSquareT_Prop  | Set properties for all blocks above
% setSquareT_N     | Set properties for N-th block above
% setSquareF_Prop  | Set properties for all blocks bellow
% setSquareF_N     | Set properties for N-th block bellow
CC.setSquareT_Prop('FaceColor',[0,0,0])
CC.setSquareT_N(2,'FaceColor',[.8,0,0])
% CC.setSquareF_Prop('FaceColor',[0,0,0])
% CC.setSquareF_N(2,'FaceColor',[.8,0,0])

% 字体设置 =================================================================
% Set font for labels
CC.setFont('FontSize',17,'FontName','Cambria','Color',[0,0,.8])


% 刻度开关设置 =============================================================
CC.tickState('on')