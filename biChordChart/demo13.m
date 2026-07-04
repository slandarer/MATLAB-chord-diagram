%% Add highlight arrow

rng(1)
dataMat = randi([1, 8], [4, 4]);

% Create and draw bichord diagram object (创建双向弦图对象并渲染)
BCC = biChordChart(dataMat, 'Arrow','on', 'Sep',1/12, 'TickMode','linear');
BCC = BCC.draw();
BCC.tickState('on')
BCC.tickLabelState('on')

BCC.addHighlightArrow(2, 3)
BCC.addHighlightArrow(2, 1)
BCC.addHighlightArrow(4, 4)



