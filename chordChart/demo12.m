% demo12
% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

% Overall image rotation

clc;clear
rng(2)
dataMat = rand([14,5]) > .3;

colName = {'phosphorylation', 'vasculature development', 'blood vessel development', ...
           'cell adhesion', 'plasma membrane'};         
       
rowName = {'THY1', 'FGF2', 'MAP2K1', 'CDH2', 'HBEGF', 'CXCR4', 'ECSCR',...
           'ACVRL1', 'RECK', 'PNPLA6', 'CDH5', 'AMOT', 'EFNB2', 'CAV1'};
figure('Units','normalized', 'Position',[.02,.05,.9,.85])
CC = chordChart(dataMat, 'colName',colName, 'rowName',rowName, 'Sep',1/80, 'LRadius',1.2, 'Rotation',3*pi/2);
CC = CC.draw();


% 修改上方方块颜色(Modify the color of the blocks above)
CListT = [0.47 0.58 0.75; 0.48 0.54 0.58; 0.65 0.72 0.65; 0.94 0.92 0.90; 0.98 0.76 0.68];
for i = 1:size(dataMat, 2)
    CC.setSquareT_N(i, 'FaceColor',CListT(i,:), 'EdgeColor',[0,0,0])
end
% 修改弦颜色(Modify chord color)
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        CC.setChordMN(i,j, 'FaceColor',CListT(j,:), 'FaceAlpha',.9, 'EdgeColor',[0,0,0])
    end
end
% 修改下方方块颜色(Modify the color of the blocks below)
logFC = sort(rand(1,14))*6 - 3;
for i = 1:size(dataMat, 1)
    CC.setSquareF_N(i, 'CData',logFC(i), 'FaceColor','flat', 'EdgeColor',[0,0,0])
end
% 一个红白蓝配色 colorbar
CMap = interp1([0,.5,1].', [0,0,1;1,1,1;1,0,0], linspace(0,1,50).');
colormap(CMap);
try clim([-3,3]),catch,end
try caxis([-3,3]),catch,end
CBHdl = colorbar();
CBHdl.Position = [0.74,0.25,0.02,0.2];


% Draw legend
text(1.25,-.15, 'LogFC', 'FontSize',16)
text(1.25,1, 'Terms', 'FontSize',16)

patchHdl = [];
for i = 1:size(dataMat, 2)
    patchHdl(i) = fill([10,11,12],[10,13,13], CListT(i,:), 'EdgeColor',[0,0,0]);
end
lgdHdl = legend(patchHdl, colName, 'Location','best', 'FontSize',14, 'Box','off');
lgdHdl.Position = [.735,.53,.167,.27];
lgdHdl.ItemTokenSize = [18,8];



























