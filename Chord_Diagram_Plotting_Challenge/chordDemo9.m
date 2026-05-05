% chordDemo9

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

dataMat = randi([0,10], [5,5]);

CList1 = [0.70,0.59,0.67
    0.62,0.70,0.62
    0.81,0.75,0.62
    0.80,0.62,0.56
    0.62,0.65,0.65];
CList2 = [0.02,0.02,0.02
    0.59,0.26,0.33
    0.38,0.49,0.38
    0.03,0.05,0.03
    0.29,0.28,0.32];
CList = CList1;

NameList={'CHORD','CHART','MADE','BY','SLANDARER'};

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Arrow','on', 'CData',CList, 'Sep',1/30, 'Label',NameList, 'LRadius',1.33, 'TickMode','auto');
BCC = BCC.draw();

% 修改弦颜色(Modify chord color)
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        BCC.setChordMN(i,j, 'FaceAlpha',.5)
    end
end
% 修改方块颜色(Modify the color of the blocks)
for i = 1:size(dataMat, 1)
    BCC.setSquareN(i, 'EdgeColor',[0,0,0], 'LineWidth',5)
end

% 添加刻度
BCC.tickState('on')
% 修改字体，字号及颜色
BCC.setFont('FontSize',17, 'FontWeight','bold')
BCC.tickLabelState('on')
BCC.setTickFont('FontSize',9)