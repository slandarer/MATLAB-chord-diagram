% chordDemo12

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

dataMat = rand([9,9]);
dataMat(dataMat > .7) = 0;
dataMat(eye(9) == 1) = (rand([1,9])+.2).*3;

CList = [0.85,0.23,0.24; 0.96,0.39,0.18; 0.98,0.63,0.22; 0.99,0.80,0.26;
0.70,0.76,0.21; 0.24,0.74,0.71; 0.27,0.65,0.84; 0.09,0.37,0.80; 0.64,0.40,0.84];

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Arrow','on', 'CData',CList,'TickMode','linear');
BCC.linearMinorTick = 'on';
BCC = BCC.draw();

% 添加刻度、刻度标签
BCC.tickState('on')
BCC.tickLabelState('on')

BCC.setFont('FontName','Cambria', 'FontSize',17)
BCC.setChord('FaceAlpha',.7)
BCC.labelRotate('on')