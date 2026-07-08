%% A colorful demo 2

rng(2)
dataMat = rand([12, 12]);
dataMat(dataMat < .85) = 0;
dataMat(7,:) = 1.*(rand(1, 12) + .1);
dataMat(11,:) = .6.*(rand(1, 12) + .1);
dataMat(12,:) = [2.*(rand(1 ,10) + .1), 0, 0];

CList = [repmat([49,49,49],[10,1]); 235,28,34; 19,146,241]./255;

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Arrow','off', 'CData',CList);
BCC = BCC.draw();

BCC.tickState('on')
BCC.setFont('FontName','Cambria', 'FontSize',17)
BCC.setChord('FaceAlpha',.78, 'EdgeColor',[0,0,0])
BCC.setSquare('EdgeColor',[0,0,0], 'LineWidth',2)