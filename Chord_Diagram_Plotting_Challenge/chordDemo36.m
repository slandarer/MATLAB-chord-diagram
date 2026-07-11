% chordDemo36

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

rng(6)
dataA = randi([1, 30], [10, 10]).*(rand([10, 10]) > .8);
dataB = randi([1, 30], [10, 7]).*(rand([10, 7]) > .8);
dataC = randi([1, 30], [10, 6]).*(rand([10, 6]) > .8);


CListS = [0.47,0.67,0.85; 0.61,0.87,1.00; 0.27,0.73,0.62; 0.73,0.81,0.21; 0.67,0.66,0.01;
          0.53,0.26,0.52; 0.93,0.88,0.53; 0.93,0.54,0.40; 1.00,0.67,0.73; 0.87,0.87,0.87];
CListA = [1.00,0.51,0.29; 0.00,1.00,0.99; 0.00,0.00,0.98; 0.98,0.00,0.99; 0.00,0.01,0.48;
          0.11,0.56,0.99; 0.33,0.13,0.00; 1.00,0.85,0.00; 0.71,0.85,0.89; 0.20,0.20,0.20];
CListB = [0.20,0.41,1.00; 0.40,0.80,0.67; 0.30,0.00,0.51; 0.55,0.27,0.04
          0.98,0.64,0.00; 0.00,0.82,0.86; 1.00,0.00,1.00];
CListC = [0.13,0.55,0.13; 1.00,0.80,0.01; 0.55,0.27,0.07;
          1.00,0.27,0.00; 0.20,0.78,0.22; 0.58,0.29,0.00];

titleStr = {'Marine', 'Land water', 'Soil', 'Taxonomy'};
labelS = {'NAG01', 'Perkinsea cluster 01', 'Perkinsea cluster 02', ...
    'Perkinsea cluster 03', 'Perkinsea cluster 04', 'Pararosarium dinoexitiosum', ...
    'Parviluciferaceae', 'Perkinsidae', 'Xcellidae', 'unclassifiedPerkinsea'};
labelA = {'Coastalzone', 'Epipelagic zone (0-200 m)', 'Mesopelagic zone (200-1,000 m)', ...
    'Bathypelagic zone (1,000-4,000 m)', 'Abyssal zone (>4,0000 m)', 'Pelagic zone', ...
    'Marine sediment', 'Estuarine', 'Arcticmixed water', 'Marineothers'};
labelB = {'Lake', 'River', 'Freshwatersediment', 'Brackish', ...
    'Saline spring sediment', 'High Arctic water', 'Bromeliads tank water'};
labelC = {'Forest soil (Temperate)', 'Forest soil (Tropical)', 'Cropland soil (Temperate)', ...
    'Cropland soil (Tropical)', 'Grassland soil', 'Land soil'};

fig = figure('Units','normalized', 'Position',[.02,.05,.85,.75], 'Color',[1,1,1]);
sfunc = @(S,V) cellfun(@(s, v) sprintf('%s [%d]', s, v), S, num2cell(V), 'UniformOutput', false);
% =========================================================================
ax1 = axes('Parent',fig, 'Position',[.02,.5,.3,.5], 'NextPlot','add');
CC1 = chordChart(ax1, dataA, 'Sep',1/120, 'SRadius',[1.02, 1.1], 'LRadius',1.18);
CC1.ColName = repmat({''}, [1,10]);
rCount = sum(dataA, 2);
rowName = compose('%d ASVs', rCount);
rowName(rCount == 0) = {''};
CC1.RowName = rowName;
CC1.draw();
CC1.setSquareColorS(CListS)
CC1.setSquareColorT(CListA)
CC1.setChordColorBySquareT()
CC1.labelRotate('none')
CC1.setSquareT('LineWidth',1, 'EdgeColor','k', 'LineJoin','chamfer')
CC1.setSquareS('LineWidth',1, 'EdgeColor','k', 'LineJoin','chamfer')
CC1.setFont('FontName','Cambria')
plot(ax1, [-1.3, 1.3], [0, 0], 'LineWidth',1.5, 'LineStyle','--', 'Color','k')
lgdHdl = legend(ax1, CC1.squareTHdl, sfunc(labelA, sum(dataA, 1)), 'FontName','Cambria', 'FontSize',14, 'Box','off');
lgdHdl.Location = 'eastoutside';
lgdHdl.ItemTokenSize = [14, 16];
text(-1.4, 1.2, 'A.', 'FontName','Cambria', 'FontSize',30)
set(ax1, 'Position',[.02,.5,.3,.5], 'XLim',[-1.55, 1.55], 'DataAspectRatio',[1,1,1]);
set(lgdHdl.Title, 'String', titleStr{1}, 'FontWeight','bold', 'FontSize',16)
% =========================================================================
ax2 = axes('Parent',fig, 'Position',[.02,0,.3,.5], 'NextPlot','add');
CC2 = chordChart(ax2, dataB, 'Sep',1/120, 'SRadius',[1.02, 1.1], 'LRadius',1.18);
CC2.ColName = repmat({''}, [1,10]);
rCount = sum(dataB, 2);
rowName = compose('%d ASVs', rCount);
rowName(rCount == 0) = {''};
CC2.RowName = rowName;
CC2.draw();
CC2.setSquareColorS(CListS)
CC2.setSquareColorT(CListB)
CC2.setChordColorBySquareT()
CC2.labelRotate('none')
CC2.setSquareT('LineWidth',1, 'EdgeColor','k', 'LineJoin','chamfer')
CC2.setSquareS('LineWidth',1, 'EdgeColor','k', 'LineJoin','chamfer')
CC2.setFont('FontName','Cambria')
plot(ax2, [-1.3, 1.3], [0, 0], 'LineWidth',1.5, 'LineStyle','--', 'Color','k')
lgdHdl = legend(ax2, CC2.squareTHdl, sfunc(labelB, sum(dataB, 1)), 'FontName','Cambria', 'FontSize',14, 'Box','off');
lgdHdl.Location = 'eastoutside';
lgdHdl.ItemTokenSize = [14, 16];
text(-1.4, 1.2, 'B.', 'FontName','Cambria', 'FontSize',30)
set(ax2, 'Position',[.02,0,.3,.5], 'XLim',[-1.55, 1.55], 'DataAspectRatio',[1,1,1]);
set(lgdHdl.Title, 'String', titleStr{2}, 'FontWeight','bold', 'FontSize',16)
% =========================================================================
ax3 = axes('Parent',fig, 'Position',[.5,0,.3,.5], 'NextPlot','add');
CC3 = chordChart(ax3, dataC, 'Sep',1/120, 'SRadius',[1.02, 1.1], 'LRadius',1.18);
CC3.ColName = repmat({''}, [1,10]);
rCount = sum(dataC, 2);
rowName = compose('%d ASVs', rCount);
rowName(rCount == 0) = {''};
CC3.RowName = rowName;
CC3.draw();
CC3.setSquareColorS(CListS)
CC3.setSquareColorT(CListC)
CC3.setChordColorBySquareT()
CC3.labelRotate('none')
CC3.setSquareT('LineWidth',1, 'EdgeColor','k', 'LineJoin','chamfer')
CC3.setSquareS('LineWidth',1, 'EdgeColor','k', 'LineJoin','chamfer')
CC3.setFont('FontName','Cambria')
plot(ax3, [-1.3, 1.3], [0, 0], 'LineWidth',1.5, 'LineStyle','--', 'Color','k')
lgdHdl = legend(ax3, CC3.squareTHdl, sfunc(labelC, sum(dataC, 1)), 'FontName','Cambria', 'FontSize',14, 'Box','off');
lgdHdl.Location = 'eastoutside';
lgdHdl.ItemTokenSize = [14, 16];
text(-1.4, 1.2, 'C.', 'FontName','Cambria', 'FontSize',30)
set(ax3, 'Position',[.5,0,.3,.5], 'XLim',[-1.55, 1.55], 'DataAspectRatio',[1,1,1]);
set(lgdHdl.Title, 'String', titleStr{3}, 'FontWeight','bold', 'FontSize',16)
% =========================================================================
ax4 = axes('Parent',fig, 'Position',[.6,.58,.2,.5], 'Color','none');
ax4.XColor = 'none'; ax4.YColor = 'none';
ax4.XLim = [-1,1]; ax4.YLim = [-1,1];
ax4.NextPlot = 'add';
patchHdl = gobjects(1, length(labelS));
for i = 1:length(labelS)
    patchHdl(i) = fill([10,11,12], [10,13,13], CListS(i,:), 'EdgeColor',[0,0,0], 'LineWidth',1);
end
lgdHdl = legend(patchHdl, labelS, 'Location','southwest', 'FontSize',15, ...
    'FontName','Cambria', 'Box','on', 'LineWidth',1.5, 'NumColumns',2);
lgdHdl.ItemTokenSize = [14, 16];