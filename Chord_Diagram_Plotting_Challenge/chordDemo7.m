% chordDemo7

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

dataMat = randi([10,10000], [10,10]);
dataMat(6:10,:) = 0;
dataMat(:,1:5) = 0;

NameList = {'BOC', 'ICBC', 'ABC', 'BOCM', 'CCB', ...
            'yama', 'nikoto', 'saki', 'koto', 'kawa'};
CList = [0.63,0.75,0.88
    0.67,0.84,0.75
    0.85,0.78,0.88
    1.00,0.92,0.93
    0.92,0.63,0.64
    0.57,0.67,0.75
    1.00,0.65,0.44
    0.72,0.73,0.40
    0.65,0.57,0.58
    0.92,0.94,0.96];

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Arrow','on', 'CData',CList, 'Label',NameList);
BCC = BCC.draw();

% 修改弦颜色(Modify chord color)
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        if dataMat(i,j) > 0
            BCC.setChordMN(i,j, 'FaceAlpha',.85, 'EdgeColor',CList(i,:)./1.5, 'LineWidth',.8)
        end
    end
end
for i = 1:size(dataMat, 1)
    BCC.setSquareN(i, 'EdgeColor',CList(i,:)./1.5, 'LineWidth',1)
end


% 添加刻度、修改字体
BCC.tickState('on')
BCC.setFont('FontName','Cambria', 'FontSize',17)
