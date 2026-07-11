% chordDemo30

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

rng(5)
dataMat = rand(7).*(rand(7) > .35);
CList = [217,92,98; 233,130,52; 226,191,90; 97,155,79; 129,189,182; 80,115,151; 163,115,151]./255;
label = {'Epithelial cell', 'Stromal cell', 'B cell', 'Plasma cell', 'T cell', 'Myeloid cell', 'Spermatic'};

BCC = biChordChart(dataMat, 'Sep',1/10, 'SRadius',[1.02,1.08]);
BCC.CData = CList;
BCC.draw()
BCC.setFont('Visible','off')
BCC.setChord('FaceAlpha',.5)
BCC.setSquare('LineWidth',3, 'EdgeColor','k')

% Draw highlight arrows
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        if dataMat(i, j) > 0
            tHdl = BCC.addHighlightArrow(i, j);
        end
    end
end

axis([-1.12, 1.12, -1.12, 1.12])
lgdHdl = legend(BCC.squareHdl, label, 'Location','northeastoutside', 'FontSize',17, 'Box','off');
lgdHdl.ItemTokenSize = [14, 16];