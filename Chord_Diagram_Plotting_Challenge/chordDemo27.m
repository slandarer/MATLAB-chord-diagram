% chordDemo27

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

rng(2)
dataMat = rand([8, 8]); dataMat(dataMat > .7) = 0;
dataMat(eye(8) == 1) = (rand([1,8]) + .2).*1.5;

CList = [.16,.21,.23; 0.0,.60,.46; .60,.72,.60; 1.0,.81,.66;
         1.0,.52,.49; .91,.29,.37; .75,.22,.17; .59,.16,.11];

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Arrow','on', 'CData',CList, 'TickMode','linear', ...
    'SRadius',[1.02, 1.18], 'TRadius',1.182 ,'LRadius',1.35 ,'SSqRatio',.25, 'OSqRatio',.6);
BCC.LinearMinorTick = 'on';
BCC = BCC.draw();
BCC.tickState('on')
BCC.tickLabelState('on')

BCC.setFont('FontName','Cambria', 'FontSize',17)
BCC.setChord('FaceAlpha',.7)
BCC.setSubSquareT('FaceColor','w')
% BCC.setSubSquareS('EdgeColor','k', 'LineWidth',1)
% BCC.setSquare('EdgeColor','k', 'LineWidth',1)