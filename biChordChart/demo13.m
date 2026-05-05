% demo13 
% Add highlight arrow

rng(1)
dataMat=randi([1,8], [4,4]);

% 创建弦图对象(Create bichord diagram object)
BCC=biChordChart(dataMat,'Arrow','on','Sep',1/12);

% 开始绘图(Start drawing)
BCC=BCC.draw();

% 添加刻度(Show ticks and tick labels)
BCC.tickState('on')
BCC.tickLabelState('on')

% % 修改字体，字号及颜色(Set font properties)
% % BCC.setFont('FontName','Cambria','FontSize',17)
BCC.addHighlightArrow(2, 3)
BCC.addHighlightArrow(2, 1)
BCC.addHighlightArrow(4, 4)



