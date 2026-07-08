%% A colorful demo

dataMat = rand([9, 9]); dataMat(dataMat > .7) = 0;
dataMat(eye(9) == 1) = (rand([1,9]) + .2).*3;

CList = [.85,.23,.24; .96,.39,.18; .98,.63,.22; .99,.80,.26; .70,.76,.21; 
    .24,.74,.71; .27,.65,.84; .09,.37,.80; .64,.40,.84];

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Arrow','on', 'CData',CList, 'TickMode','linear');
BCC.LinearMinorTick = 'on';
BCC = BCC.draw();

BCC.tickState('on')
BCC.tickLabelState('on')
BCC.setFont('FontName','Cambria', 'FontSize',17)
BCC.setChord('FaceAlpha',.7)