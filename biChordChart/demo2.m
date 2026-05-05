% demo 2
% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

% Chord chart with label

dataMat=randi([0,8],[6,6]);

% 添加标签名称(Add names for each row/col)
NameList={'CHORD','CHART','MADE','BY','SLANDARER','MATLAB'};
BCC=biChordChart(dataMat,'Label',NameList,'Arrow','on','CData',bone(9));
BCC=BCC.draw();


% 添加刻度(Show ticks)
BCC.tickState('on')

% 修改字体，字号及颜色(Set font properties)
BCC.setFont('FontName','Cambria','FontSize',17,'Color',[0,0,.8])