%% Set properties for squares and chord ribbons using bool matrix : Use the setChord method to highlight specific chords

dataMat = [2 0 1 2 5 1 2;
           3 5 1 4 2 0 1;
           4 0 5 5 2 4 3];
colName = {'G1','G2','G3','G4','G5','G6','G7'};
rowName = {'S1','S2','S3'};

CC = chordChart(dataMat, 'RowName',rowName, 'ColName',colName, 'Arrow','on');
CC = CC.draw();

% Set edge properties for chords with flow >= 5 (为流量 >=5 的弦设置边缘属性)
CC.setChord(dataMat >= 5, 'EdgeColor','k', 'LineWidth',2)

CC.setSquareT(dataMat(1, :) == 0, 'EdgeColor','k', 'LineWidth',5)
CC.setSquareS(dataMat(:, 1)  > 2, 'EdgeColor','k', 'LineWidth',5)