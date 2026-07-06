%% Set properties for squares and chord ribbons

dataMat = [2 0 1 2 5 1 2;
          3 5 1 4 2 0 1;
          4 0 5 5 2 4 3];
colName = {'G1','G2','G3','G4','G5','G6','G7'};
rowName = {'S1','S2','S3'};

CC = chordChart(dataMat, 'RowName',rowName, 'ColName',colName);
CC = CC.draw();

% Change colormap
colormap(flipud(gray(100)))

% Set chord properties (设置弦属性)
% setChord(___)          | Set properties for all chord
% setChord(m, n, ___)    | Set the properties for the chord which
%                              connect m-th square bellow and n-th square above
CC.setChord('EdgeColor',[.3,.3,.3], 'LineStyle',':', 'LineWidth',.1)
CC.setChord(2,4, 'FaceColor',[1,0,0])

% Set square properties (设置方块属性)
% setSquareT(___)       | Set properties for all blocks above (target)
% setSquareT(n, ___)    | Set properties for n-th block above (target)
% setSquareS(___)       | Set properties for all blocks bellow (source)
% setSquareS(n, ___)    | Set properties for n-th block bellow (source)
CC.setSquareT('FaceColor',[0,0,0])
CC.setSquareT(2, 'FaceColor',[.8,0,0])

% Set font for labels (字体设置)
CC.setFont('FontSize',17, 'FontName','Cambria', 'Color',[0,0,.8])
