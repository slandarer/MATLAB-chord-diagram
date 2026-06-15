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
CC = chordChart(dataMat, 'ColName',colName, 'RowName',rowName, 'Sep',1/80, 'LRadius',1.2);
CC = CC.draw();


% 修改上方方块颜色(Modify the color of the blocks above)
CListT1 = [0.5686    0.1961    0.2275
    0.2275    0.2863    0.3765
    0.8431    0.7882    0.4118
    0.4275    0.4510    0.2706
    0.3333    0.2706    0.2510];
CListT2 = [0.4941    0.5490    0.4118
    0.9059    0.6510    0.3333
    0.8980    0.6157    0.4980
    0.8902    0.5137    0.4667
    0.4275    0.2824    0.2784];
CListT3 = [0.4745    0.5843    0.7569
    0.4824    0.5490    0.5843
    0.6549    0.7216    0.6510
    0.9412    0.9216    0.9059
    0.9804    0.7608    0.6863];
CListT = CListT3;
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
CMap = [     0         0    1.0000; 0.0645    0.0645    1.0000; 0.1290    0.1290    1.0000; 0.1935    0.1935    1.0000
        0.2581    0.2581    1.0000; 0.3226    0.3226    1.0000; 0.3871    0.3871    1.0000; 0.4516    0.4516    1.0000
        0.5161    0.5161    1.0000; 0.5806    0.5806    1.0000; 0.6452    0.6452    1.0000; 0.7097    0.7097    1.0000
        0.7742    0.7742    1.0000; 0.8387    0.8387    1.0000; 0.9032    0.9032    1.0000; 0.9677    0.9677    1.0000
        1.0000    0.9677    0.9677; 1.0000    0.9032    0.9032; 1.0000    0.8387    0.8387; 1.0000    0.7742    0.7742
        1.0000    0.7097    0.7097; 1.0000    0.6452    0.6452; 1.0000    0.5806    0.5806; 1.0000    0.5161    0.5161
        1.0000    0.4516    0.4516; 1.0000    0.3871    0.3871; 1.0000    0.3226    0.3226; 1.0000    0.2581    0.2581
        1.0000    0.1935    0.1935; 1.0000    0.1290    0.1290; 1.0000    0.0645    0.0645; 1.0000         0         0];
colormap(CMap);
try clim([-3,3]),catch,end
try caxis([-3,3]),catch,end

CBHdl = colorbar();
CBHdl.Position = [0.74,0.25,0.02,0.2];

% =========================================================================
% 交换XY轴(Swap XY axis)
patchHdl = findobj(gca, 'Type','patch');
for i = 1:length(patchHdl)
    tX = patchHdl(i).XData;
    tY = patchHdl(i).YData;
    patchHdl(i).XData = tY;
    patchHdl(i).YData = - tX;
end
txtHdl = findobj(gca, 'Type','text');
for i = 1:length(txtHdl)
    txtHdl(i).Position([1,2]) = [1,-1].*txtHdl(i).Position([2,1]);
    if txtHdl(i).Position(1) < 0
        txtHdl(i).HorizontalAlignment = 'right';
    else
        txtHdl(i).HorizontalAlignment = 'left';
    end
end
lineHdl = findobj(gca, 'Type','line');
for i = 1:length(lineHdl)
    tX = lineHdl(i).XData;
    tY = lineHdl(i).YData;
    lineHdl(i).XData = tY;
    lineHdl(i).YData = - tX;
end
% =========================================================================

txtHdl = findobj(gca, 'Type','text');
for i = 1:length(txtHdl)
    if txtHdl(i).Position(1) > 0
        txtHdl(i).Visible = 'off';
    end
end

text(1.25,-.15, 'LogFC', 'FontSize',16)
text(1.25,1, 'Terms', 'FontSize',16)

patchHdl = [];
for i = 1:size(dataMat, 2)
    patchHdl(i) = fill([10,11,12],[10,13,13], CListT(i,:), 'EdgeColor',[0,0,0]);
end
lgdHdl = legend(patchHdl, colName, 'Location','best', 'FontSize',14, 'FontName','Cambria', 'Box','off');
lgdHdl.Position = [.735,.53,.167,.27];
lgdHdl.ItemTokenSize = [18,8];
