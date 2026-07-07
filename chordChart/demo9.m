%% Set SSqRatio and OSqRatio


dataMat = round(10.*rand([11,4]).*((11:-1:1).'+1))./10;
colName = {'A','B','C','D'};
rowName = {'Acidobacteriota', 'Actinobacteriota', 'Proteobacteria', ...
           'Chloroflexi', 'Bacteroidota', 'Firmicutes', 'Gemmatimonadota', ...
           'Verrucomicrobiota', 'Patescibacteria', 'Planctomyetota', 'Others'};

figure('Units','normalized', 'Position',[.02,.05,.8,.85])
CC = chordChart(dataMat, 'ColName',colName, 'Sep',1/80, 'SSqRatio',-30/100, 'OSqRatio',80/100);
CC.RowName = repmat({' '}, [1, length(rowName)]);
CC = CC.draw();

% Modify the color of the blocks above (修改上方方块颜色)
CListT = [.93,.60,.62; .55,.80,.99; .95,.82,.18; 1.0,.81,.91];
CC.setSquareColorT(CListT)
% Modify the color of the blocks below (修改下方方块颜色)
CListS = [.75,.73,.86; .56,.83,.78; .00,.60,.20; 1.0,.49,.02; .78,.77,.95; .59,.24,.36; 
          .98,.51,.45; .96,.55,.75; .47,.71,.84; .65,.35,.16; .40,.00,.64];
CC.setSquareColorS(CListS)
% Modify chord color (修改弦颜色)
% CC.setChordColorBySquareS()
CC.setChordColorBySquareT()

CC.tickState('on')
CC.setFont('FontName','Cambria', 'FontSize',17)

% Draw legend (绘制图例)
lgdHdl = legend(CC.squareFHdl, rowName, 'Location','eastoutside', ...
    'FontSize',16, 'FontName','Cambria', 'Box','off');
lgdHdl.ItemTokenSize = [18,8];




