% chordDemo8

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer
clc;clear
dataMat = rand([11,4]);
dataMat = round(10.*dataMat.*((11:-1:1).'+1))./10;

colName = {'A','B','C','D'};
rowName = {'Acidobacteriota', 'Actinobacteriota', 'Proteobacteria', ...
           'Chloroflexi', 'Bacteroidota', 'Firmicutes', 'Gemmatimonadota', ...
           'Verrucomicrobiota', 'Patescibacteria', 'Planctomyetota', 'Others'};

figure('Units','normalized', 'Position',[.02,.05,.8,.85])
CC = chordChart(dataMat, 'colName',colName, 'Sep',1/80, 'SSqRatio',30/100);% -30/100
CC = CC.draw();

% 修改上方方块颜色(Modify the color of the blocks above)
CListT = [0.93,0.60,0.62
    0.55,0.80,0.99
    0.95,0.82,0.18
    1.00,0.81,0.91];
for i = 1:size(dataMat, 2)
    CC.setSquareT_N(i, 'FaceColor',CListT(i,:))
end

% 修改下方方块颜色(Modify the color of the blocks below)
CListF = [0.75,0.73,0.86
    0.56,0.83,0.78
    0.00,0.60,0.20
    1.00,0.49,0.02
    0.78,0.77,0.95
    0.59,0.24,0.36
    0.98,0.51,0.45
    0.96,0.55,0.75
    0.47,0.71,0.84
    0.65,0.35,0.16
    0.40,0.00,0.64];
for i = 1:size(dataMat, 1)
    CC.setSquareF_N(i, 'FaceColor',CListF(i,:))
end

% 修改弦颜色(Modify chord color)
CListC = [0.55,0.83,0.76
    0.75,0.73,0.86
    0.00,0.60,0.19
    1.00,0.51,0.04];
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        CC.setChordMN(i,j, 'FaceColor',CListC(j,:), 'FaceAlpha',.4)
    end
end

% 单独设置每一个弦末端方块(Set individual end blocks for each chord)
% Use obj.setEachSquareF_Prop 
% or  obj.setEachSquareT_Prop
% F means from (blocks below)
% T means to   (blocks above)
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        CC.setEachSquareT_Prop(i,j, 'FaceColor', CListF(i,:))
    end
end

% 添加刻度
CC.tickState('on')

% 修改字体，字号及颜色
CC.setFont('FontName','Cambria', 'FontSize',17)

% 隐藏下方标签
textHdl = findobj(gca, 'Tag','ChordLabel');
for i = 1:length(textHdl)
    if textHdl(i).Position(2) < 0
        set(textHdl(i), 'Visible','off')
    end
end

% 绘制图例(Draw legend)
for i = 1:size(dataMat,1)
    scatterHdl(i) = scatter(10.*ones(size(dataMat,1),1),10.*ones(size(dataMat,1),1),55, 'filled');
end
for i = 1:length(scatterHdl)
    scatterHdl(i).CData = CListF(i,:);
end
lgdHdl = legend(scatterHdl, rowName, 'Location','best', 'FontSize',16, 'FontName','Cambria', 'Box','off');
set(lgdHdl, 'Position',[.7482,.3577,.1658,.3254])
