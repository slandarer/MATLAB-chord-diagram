%% Add highlight arrow

dataMat = [2 0 1 2 5 1 2;
           3 5 1 4 2 0 1;
           4 0 5 5 2 4 3];

CC = chordChart(dataMat);
CC = CC.draw();

CC.addHighlightArrow(3, 4)
CC.addHighlightArrow(2, 2)