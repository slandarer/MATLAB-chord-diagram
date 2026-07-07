 %% Colormap

dataMat = randi([0, 5], [8, 8]);

BCC = biChordChart(dataMat);
BCC.draw()

BCC.setChord('FaceAlpha',.5)
BCC.setChordCData(dataMat)

colormap(flipud(summer))
colorbar