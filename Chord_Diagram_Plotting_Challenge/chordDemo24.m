% chordDemo24

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

rng(1234)
dataMat = rand(11).*(rand(11) > .5);
dataMat(eye(11) == 1) = rand([1, 11]).*10;

CList = [ 48, 69, 99;   0, 30, 80; 202,183,106; 123,122,119; 100,103,108;  78, 86,107; 
         169,163,118; 225,205, 87; 146,141,119;   0, 49,111; 255,229, 72]./255;
nameList = compose('chordChart%d', 1:11);

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Arrow','on', 'CData',CList, 'TickMode','linear', ...
    'SRadius',[1.001, 1.08], 'TRadius',1.08, 'LRadius',1.2, 'Label',nameList);
BCC.LinearMinorTick = 'on';
BCC = BCC.draw();
BCC.tickState('on')
BCC.tickLabelState('on')
% Set properties for labels, tick labels, squares, and chords
BCC.setFont('FontName','Cambria', 'FontSize',17)
BCC.setChord('FaceAlpha',.6)
BCC.setSquare('EdgeColor','k', 'LineWidth',1.5)
BCC.setTick('LineWidth',1)
BCC.setTickFont('FontName','Cambria', 'FontSize',12)

axis([-1.2, 1.2, -1.2, 1.2])