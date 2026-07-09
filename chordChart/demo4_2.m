%% Colormap with negative value

dataMat = [ 2  0 -1  2 -5 1 -2;
           -3 -5  1 -4  2 0  1;
            4  0  5 -5 -2 4  3];
colName = {'G1','G2','G3','G4','G5','G6','G7'};
rowName = {'S1','S2','S3'};

CC = chordChart(dataMat, 'RowName',rowName, 'ColName',colName,  'LRadius',1.28);
CC = CC.draw();
CC.tickState('on')
CC.tickLabelState('on')

% Set chord color data to the matrix values (将弦颜色数据设为矩阵值)
CC.setChordCData(dataMat)
CC.setChord('FaceAlpha',.5)

clim([-5, 5])
cmp = [.23,.30,.75; 1.0,1.0,1.0; .71,.02,.15];
cmp = interp1([0,.5,1], cmp, linspace(0,1,25));
colormap(cmp)
colorbar()