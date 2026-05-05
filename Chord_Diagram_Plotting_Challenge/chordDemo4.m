% chordDemo4

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

rng(5)
dataMat = randi([1,20], [5,5]);
dataMat(1,1) = 110;
dataMat(2,2) = 40;
dataMat(3,3) = 50;
dataMat(5,5) = 50;

CList1 = [164,190,158; 216,213,153; 177,192,208; 238,238,227; 249,217,153]./255;
CList2 = [247,204,138; 128,187,185; 245,135,124; 140,199,197; 252,223,164]./255;
CList = CList2;
NameList={'CHORD','CHART','MADE','BY','SLANDARER'};

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Arrow','on', 'CData',CList, 'Sep',1/30, 'Label',NameList, 'LRadius',1.33);
BCC = BCC.draw();

% 添加刻度
BCC.tickState('on')

% 修改弦颜色(Modify chord color)
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        if dataMat(i,j) > 0
            BCC.setChordMN(i,j, 'FaceAlpha',.7, 'EdgeColor',CList(i,:)./1.1)
        end
    end
end
% 修改方块颜色(Modify the color of the blocks)
for i = 1:size(dataMat, 1)
    BCC.setSquareN(i, 'EdgeColor',CList(i,:)./1.7)
end

% 修改字体，字号及颜色
BCC.setFont('FontName','Cambria', 'FontSize',17)
BCC.tickLabelState('on')
BCC.setTickFont('FontName','Cambria', 'FontSize',9)