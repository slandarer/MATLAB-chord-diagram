%% Efficiently configure the FaceColor and EdgeColor of chords.
dataMat = randi([10,10000], [10,10]);
dataMat(6:10,:) = 0;
dataMat(:,1:5) = 0;

NameList = {'BOC', 'ICBC', 'ABC', 'BOCM', 'CCB', ...
    'yama', 'nikoto', 'saki', 'koto', 'kawa'};
CList = [.63,.75,.88; .67,.84,.75; .85,.78,.88; 1.0,.92,.93; .92,.63,.64; 
    .57,.67,.75; 1.0,.65,.44; .72,.73,.40; .65,.57,.58; .92,.94,.96];

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Arrow','on', 'CData',CList, 'Label',NameList);
BCC = BCC.draw();

% Modify squares and chords color (修改方块颜色及弦颜色)
BCC.setSquare('LineWidth',1)
BCC.setSquareColor(CList, CList./1.5)
BCC.setChord('FaceAlpha',.85, 'LineWidth',.8)
BCC.setChordColorBySquareS()

BCC.tickState('on')
BCC.setFont('FontName','Cambria', 'FontSize',17)
