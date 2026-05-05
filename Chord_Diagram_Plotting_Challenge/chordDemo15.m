% chordDemo15

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer


CList = [0.81,0.72,0.83
0.69,0.82,0.89
0.17,0.44,0.64
0.70,0.85,0.55
0.03,0.57,0.13
0.97,0.67,0.64
0.84,0.09,0.12
1.00,0.80,0.46
0.98,0.52,0.01
    ];

figure('Units','normalized', 'Position',[.02,.05,.53,.85], 'Color',[1,1,1])

% =========================================================================
ax1 = axes('Parent',gcf, 'Position',[0,1/2,1/2,1/2]);
dataMat = rand([9,9]);
dataMat(dataMat > .4) = 0;
BCC = biChordChart(dataMat, 'Arrow','on', 'CData',CList);
BCC = BCC.draw();
BCC.tickState('on')
BCC.setFont('Visible','off')
% 修改弦颜色(Modify chord color)
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        if dataMat(i,j) > 0
            BCC.setChordMN(i,j, 'FaceAlpha',.6)
        end
    end
end
text(-1.2,1.2, 'a', 'FontName','Times New Roman', 'FontSize',35)

% =========================================================================
ax2 = axes('Parent',gcf, 'Position',[1/2,1/2,1/2,1/2]);
dataMat = rand([9,9]);
dataMat(dataMat > .4) = 0;
dataMat = dataMat.*(1:9);
BCC = biChordChart(dataMat, 'Arrow','on', 'CData',CList);
BCC = BCC.draw();
BCC.tickState('on')
BCC.setFont('Visible','off')
% 修改弦颜色(Modify chord color)
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        if dataMat(i,j) > 0
            BCC.setChordMN(i,j, 'FaceAlpha',.6)
        end
    end
end
text(-1.2,1.2, 'b', 'FontName','Times New Roman', 'FontSize',35)

% =========================================================================
ax3 = axes('Parent',gcf, 'Position',[0,0,1/2,1/2]);
dataMat = rand([9,9]);
dataMat(dataMat > .4) = 0;
dataMat = dataMat.*(1:9).';
BCC = biChordChart(dataMat, 'Arrow','on', 'CData',CList);
BCC = BCC.draw();
BCC.tickState('on')
BCC.setFont('Visible','off')
% 修改弦颜色(Modify chord color)
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        if dataMat(i,j) > 0
            BCC.setChordMN(i,j, 'FaceAlpha',.6)
        end
    end
end
text(-1.2,1.2, 'c', 'FontName','Times New Roman', 'FontSize',35)

% =========================================================================
ax4 = axes('Parent',gcf, 'Position',[1/2,0,1/2,1/2]);
ax4.XColor = 'none'; ax4.YColor = 'none';
ax4.XLim = [-1,1]; ax4.YLim = [-1,1];
hold on

NameList = {'Food supply', 'Biodiversity', 'Water quality regulation', ...
            'Air quality regulation', 'Erosion control', 'Carbon storage', ...
            'Water retention', 'Recreation', 'Soil quality regulation'};
patchHdl = [];
for i = 1:size(dataMat, 2)
    patchHdl(i) = fill([10,11,12],[10,13,13], CList(i,:), 'EdgeColor',[0,0,0]);
end
lgdHdl = legend(patchHdl, NameList, 'Location','best', 'FontSize',14, 'FontName','Cambria', 'Box','off');
lgdHdl.Position = [.625,.11,.255,.27];
lgdHdl.ItemTokenSize = [18,8];
