%% Overall chord chart rotation

clc;clear
rng(2)
dataMat = rand([14,5]) > .3;
colName = {'phosphorylation', 'vasculature development', 'blood vessel development', ...
           'cell adhesion', 'plasma membrane'};         
rowName = {'THY1', 'FGF2', 'MAP2K1', 'CDH2', 'HBEGF', 'CXCR4', 'ECSCR',...
           'ACVRL1', 'RECK', 'PNPLA6', 'CDH5', 'AMOT', 'EFNB2', 'CAV1'};

figure('Units','normalized', 'Position',[.02,.05,.9,.85])
CC = chordChart(dataMat, 'ColName',colName, 'RowName',rowName, 'Sep',1/80, 'LRadius',1.2, 'Rotation',3*pi/2).draw();

% Modify the color of the blocks above (修改上方方块颜色)
CListT = [0.47 0.58 0.75; 0.48 0.54 0.58; 0.65 0.72 0.65; 0.94 0.92 0.90; 0.98 0.76 0.68];
CC.setSquareColorT(CListT);
CC.setSquareT('EdgeColor',[0,0,0])

% Modify chord color (修改弦颜色)
CC.setChordColorBySquareT()
CC.setChord('FaceAlpha',.9, 'EdgeColor',[0,0,0])

% Modify the color of the blocks below (修改下方方块颜色)
logFC = sort(rand(1, 14))*6 - 3;
CC.setSquareCDataS(logFC)
CC.setSquareS('EdgeColor',[0,0,0])
set(CC.nameTHdl, 'Visible','off')

% A diverging red-white-blue colormap (一个红白蓝配色 colormap)
CMap = interp1([0,.5,1].', [0,0,1;1,1,1;1,0,0], linspace(0,1,50).');
colormap(CMap); clim([-3,3]); colorbar('Position', [.74,.25,.02,.2]);

% Draw legend
text([1.25, 1.25], [-.15, 1], {'LogFC', 'Terms'}, 'FontSize',16)
lgdHdl = legend(CC.squareTHdl, colName, 'Position',[.735,.53,.167,.27], 'FontSize',14, 'Box','off');
lgdHdl.ItemTokenSize = [18,8];
























