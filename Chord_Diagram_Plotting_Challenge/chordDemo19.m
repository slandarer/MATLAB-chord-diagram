% chordDemo19

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

rng(6)
% Made up some data casually (随便捏造了点数据)
X = randn(20,15) + [(linspace(-1,2.5,20)').*ones(1,6), (linspace(.5,-.7,20)').*ones(1,5), (linspace(.9,1.8,20)').*ones(1,4)];
% Get the correlation matrix (求相关系数矩阵)
dataMat = triu(corr(X), 1);

CList = hsv(16)./1.1;
CMap = [227,26,28; 255,255,255; 50,160,44]./255;
CMap = interp1([0,.5,1], CMap, linspace(0, 1, 15));

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'CData',CList, 'TickMode','linear');
BCC.LinearTickCompactDegree = 1.5;
BCC.LinearMinorTick = 'on';
BCC.SRadius = [1.03, 1.08];
BCC.TRadius = 1.08;
BCC.LRadius = 1.2;
BCC = BCC.draw();
BCC.tickState('on')
BCC.tickLabelState('on')

BCC.setFont('FontName','Cambria', 'FontSize',17)
BCC.setChordCData(dataMat)
BCC.setChord('FaceAlpha',.5)

clim([-.7, .7])
colormap(CMap)
cbHdl = colorbar();
cbHdl.Position = [.88, .3, .02, .4];
cbHdl.TickDirection = 'out';
cbHdl.FontName = 'Cambria';
cbHdl.LineWidth = 1;

