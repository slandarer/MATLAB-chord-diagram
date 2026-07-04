%% Group

rng(1)
dataMat = randi([0, 8], [6, 6]);

% Create bichord diagram object (创建双向弦图对象)
BCC = biChordChart(dataMat, 'Arrow','on', 'Sep',1/20);

% Grouping nodes by number
BCC.GroupSep = 1/10;
BCC.Group = [1,1,2,2,3,1];

% Start drawing (开始绘图)
BCC=BCC.draw();
