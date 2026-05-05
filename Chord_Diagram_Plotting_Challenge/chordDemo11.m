% chordDemo11

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

rng(2)
dataMat = rand([12,12]);
dataMat(dataMat < .85) = 0;
dataMat(7,:) = 1.*(rand(1,12)+.1);
dataMat(11,:) = .6.*(rand(1,12)+.1);
dataMat(12,:) = [2.*(rand(1,10)+.1), 0, 0];

CList = [repmat([49,49,49],[10,1]); 235,28,34; 19,146,241]./255;

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Arrow','off', 'CData',CList);
BCC = BCC.draw();

% 添加刻度
BCC.tickState('on')

% 修改字体，字号及颜色
BCC.setFont('FontName','Cambria', 'FontSize',17)

% 修改弦颜色(Modify chord color)
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        if dataMat(i,j) > 0
            BCC.setChordMN(i,j, 'FaceAlpha',.78, 'EdgeColor',[0,0,0])
        end
    end
end

% 修改方块颜色(Modify the color of the blocks)
for i = 1:size(dataMat, 1)
    BCC.setSquareN(i, 'EdgeColor',[0,0,0], 'LineWidth',2)
end