%% Corr demo : Colormap with negative value

rng(1)
% Made up some data casually (随便捏造了点数据)
X1 = randn(20,  8) + [(linspace(-1,2.5,20)').*ones(1,3), (linspace(.5,-.7,20)').*ones(1,5)];
X2 = randn(20, 12) + [(linspace(.5,-.7,20)').*ones(1,8), (linspace(.9,-.2,20)').*ones(1,4)];
% Get the correlation matrix (求相关系数矩阵)
dataMat = corr(X1,X2);
% rowName and colName
rowName={'FREM2','ALDH9A1','RBL1','AP2A2','HNRNPK','ATP1A1','ARPC3','SMG5'};
colName={'A1','A2','A3','A4','A5','A6','A7','A8','B1','B2','B3','B4'};

CMap = [.23,.30,.75; 1.0,1.0,1.0; .71,.02,.15];
CMap = interp1([0,.5,1], CMap, linspace(0,1,25));

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
CC = chordChart(dataMat, 'RowName',rowName, 'ColName',colName, 'TickMode','linear', ...
    'SRadius',[1.03, 1.08], 'TRadius',1.08, 'LRadius',1.2, 'Sep',1/120);
CC.LinearTickCompactDegree = 1.5;
CC.LinearMinorTick = 'on';
CC = CC.draw();
CC.tickState('on')
CC.tickLabelState('on')
% Modify label font and chords (修饰标签字体及弦)
CC.setFont('FontName','Cambria', 'FontSize',17)
CC.setChordCData(dataMat)
CC.setChord('FaceAlpha',.5)
% Colormap and colorbar
clim([-.8, .8]); colormap(CMap)
cbHdl = colorbar('Position',[.88, .3, .02, .4], 'LineWidth',1, ...
    'FontName','Cambria', 'TickDirection','out');