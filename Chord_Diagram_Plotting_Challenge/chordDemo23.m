% chordDemo23

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

rng(1)
dataMat = rand(10).*(rand(10) > .8);
dataMat(eye(10) == 1) = rand([1, 10]).*10;
CList = [133,104,  4; 151,127, 51; 166,152, 98; 185,176,142; 199,197,185;
         189,192,200; 145,156,173; 104,119,153;  59, 84,128;  17, 48,106]./255;
nameList = {'\alpha','\beta','\gamma','\delta','\epsilon','\zeta','\eta','\theta','\iota','\kappa'};

BCC = biChordChart(dataMat, 'Label',nameList, 'CData',CList, ...
    'SRadius',[1.02, 1.3], 'LRadius',1.15, 'TRadius',1.302, ...
    'TickMode','linear');
BCC.LinearMinorTick = 'on';
BCC.LinearTickCompactDegree = 2;
BCC.draw()
BCC.tickState('on')
BCC.tickLabelState('on')

BCC.setChord('FaceAlpha',.6, 'EdgeColor',[.3,.3,.3], 'LineWidth',1)
BCC.setFont('Color','w', 'FontSize',25, 'FontWeight','bold')
BCC.setTickFont('FontSize',12)
