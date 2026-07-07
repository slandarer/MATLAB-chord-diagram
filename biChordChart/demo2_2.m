 %% Set properties for squares and chord ribbons using bool matrix : Use the setChord method to highlight specific chords

rng(8)
dataMat = randi([0,8], [5,5]);
nameList = {'AAA','BBB','CCC','DDD','EEE'};

% Create bichord chart object and draw (创建并绘制双向弦图对象)
BCC = biChordChart(dataMat, 'Arrow','on', 'Label',nameList);
BCC = BCC.draw();

BCC.setChord(dataMat >= 8, 'EdgeColor','k', 'LineWidth',2)
BCC.setSquare(dataMat(:, 1) >= 8, 'EdgeColor','k', 'LineWidth',5)