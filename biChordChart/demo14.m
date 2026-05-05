% demo14 
% Group

rng(1)
dataMat=randi([0,8], [6,6]);

% 创建弦图对象(Create bichord diagram object)
BCC=biChordChart(dataMat,'Arrow','on','Sep',1/20);

% Grouping nodes by number
BCC.GroupSep = 1/10;
BCC.Group = [1,1,2,2,3,1];

% 开始绘图(Start drawing)
BCC=BCC.draw();

% % 调节标签半径(Adjustable Label radius)
% BCC.setLabelRadius(1.3);
% 
% % 添加刻度(Show ticks and tick labels)
% BCC.tickState('on')
% BCC.tickLabelState('on')
% 
% % 修改字体，字号及颜色(Set font properties)
% BCC.setFont('FontName','Cambria','FontSize',17)