% chordDemo25

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

dataMat = randi([1, 20], [10, 3]);
groupS = [1,1,1,2,2,2,3,3,3,3];
CListS = [ 70,155, 81; 222, 77, 83; 114,171,168]./255;
CListT = [232,139,138; 165,113,149; 235,200, 93]./255;

fig = figure('Units','normalized', 'Position',[.02,.05,.53,.7], 'Color',[1,1,1]);
% =========================================================================
ax1 = axes('Parent',fig, 'Position',[0,.5,.4,.5]);
text(-1.2,1.2, 'a', 'FontName','Times New Roman', 'FontSize',35)
CC1 = chordChart(ax1, dataMat, 'Arrow','on', 'Sep',1/120, 'SRadius',[1.02, 1.15], 'SSqRatio',.2, 'OSqRatio',.5).draw();
CC1.setFont('Visible','off'); 
CC1.setSquareColorS(CListS(groupS, :));
CC1.setSquareColorT(CListT);
CC1.setChordColorBySquareS();
CC1.setChord('FaceAlpha',.4)
% =========================================================================
ax2 = axes('Parent',fig, 'Position',[.4,.5,.4,.5]);
text(-1.2,1.2, 'b', 'FontName','Times New Roman', 'FontSize',35)
CC2 = chordChart(ax2, dataMat, 'Arrow','on', 'Sep',1/120, 'SRadius',[1.02, 1.15], 'SSqRatio',.2, 'OSqRatio',.5).draw();
CC2.setFont('Visible','off'); 
CC2.setSquareColorS(CListS(groupS, :));
CC2.setSquareColorT(CListT);
CC2.setChordColorBySquareS();
CC2.setChord('FaceAlpha',.4)
CC2.setChord(find(groupS ~= 1), [], 'Visible','off')
% =========================================================================
ax3 = axes('Parent',fig, 'Position',[0,0,.4,.5]);
text(-1.2,1.2, 'c', 'FontName','Times New Roman', 'FontSize',35)
CC3 = chordChart(ax3, dataMat, 'Arrow','on', 'Sep',1/120, 'SRadius',[1.02, 1.15], 'SSqRatio',.2, 'OSqRatio',.5).draw();
CC3.setFont('Visible','off'); 
CC3.setSquareColorS(CListS(groupS, :));
CC3.setSquareColorT(CListT);
CC3.setChordColorBySquareS();
CC3.setChord('FaceAlpha',.4)
CC3.setChord(find(groupS ~= 2), [], 'Visible','off')
% =========================================================================
ax4 = axes('Parent',fig, 'Position',[.4,0,.4,.5]);
text(-1.2,1.2, 'c', 'FontName','Times New Roman', 'FontSize',35)
CC4 = chordChart(ax4, dataMat, 'Arrow','on', 'Sep',1/120, 'SRadius',[1.02, 1.15], 'SSqRatio',.2, 'OSqRatio',.5).draw();
CC4.setFont('Visible','off'); 
CC4.setSquareColorS(CListS(groupS, :));
CC4.setSquareColorT(CListT);
CC4.setChordColorBySquareS();
CC4.setChord('FaceAlpha',.4)
CC4.setChord(find(groupS ~= 3), [], 'Visible','off')

lgdLabel = {'CD4^+','CD8\alpha\alpha^+','CD8\alpha\beta^+','Luminal-like','Basal-like','HER2-enriched'};
[~, sind] = unique(groupS);
lgdHdl = legend(ax4, [CC4.squareSHdl(sind), CC4.squareTHdl], lgdLabel, ...
    'Box','off', 'FontSize',17, 'FontName','Times New Roman');
lgdHdl.Position = [.8,.5-.15,.2,.3];
lgdHdl.ItemTokenSize = [18, 16];
