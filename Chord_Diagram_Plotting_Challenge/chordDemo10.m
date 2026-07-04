% chordDemo10

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

clc;clear
rng(2)
dataMat = rand([14,5]) > .3;

colName = {'phosphorylation', 'vasculature development', 'blood vessel development', ...
           'cell adhesion', 'plasma membrane'};         
       
rowName = {'THY1', 'FGF2', 'MAP2K1', 'CDH2', 'HBEGF', 'CXCR4', 'ECSCR',...
           'ACVRL1', 'RECK', 'PNPLA6', 'CDH5', 'AMOT', 'EFNB2', 'CAV1'};
figure('Units','normalized', 'Position',[.02,.05,.9,.85])
CC = chordChart(dataMat, 'ColName',colName, 'RowName',rowName, 'Sep',1/80, 'LRadius',1.2, 'Rotation',3*pi/2);
CC = CC.draw();


% Modify the color of the blocks above (修改上方方块颜色)
CListT = [0.47 0.58 0.75; 0.48 0.54 0.58; 0.65 0.72 0.65; 0.94 0.92 0.90; 0.98 0.76 0.68];
for i = 1:size(dataMat, 2)
    CC.setSquareT(i, 'FaceColor',CListT(i,:), 'EdgeColor',[0,0,0])
end
% Modify chord color (修改弦颜色)
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        CC.setChord(i,j, 'FaceColor',CListT(j,:), 'FaceAlpha',.9, 'EdgeColor',[0,0,0])
    end
end
% Modify the color of the blocks below (修改下方方块颜色)
logFC = sort(rand(1,14))*6 - 3;
for i = 1:size(dataMat, 1)
    CC.setSquareS(i, 'CData',logFC(i), 'FaceColor','flat', 'EdgeColor',[0,0,0])
end
set(CC.nameTHdl, 'Visible','off')

% A diverging red-white-blue colormap (一个红白蓝配色 colormap)
CMap = interp1([0,.5,1].', [0,0,1;1,1,1;1,0,0], linspace(0,1,50).');
colormap(CMap);

clim([-3,3])
CBHdl = colorbar();
CBHdl.Position = [0.74,0.25,0.02,0.2];

% Draw legend
text(1.25,-.15, 'LogFC', 'FontSize',16)
text(1.25,1, 'Terms', 'FontSize',16)

lgdHdl = legend(CC.squareTHdl, colName, 'Location','best', 'FontSize',14, 'Box','off');
lgdHdl.Position = [.735,.53,.167,.27];
lgdHdl.ItemTokenSize = [18,8];