%% Create chord chart from source-target-value cell array

links = {'A','A',1;'A','B',1.2;'A','C',2.5;
         'B','A',.5;'B','B',0;'B','C',1.5;
         'C','A',1.5;'C','B',2;'C','C',1.1};

nameList = {'A','B','C'};
% NameList = unique([links(:,1);links(:,2)],'rows','stable');

% 创建邻接矩阵(Create adjacency matrix)
dataMat = zeros(length(nameList));
for i = 1:size(links,1)
    idRow = find(strcmp(links{i,1},nameList));
    idCol = find(strcmp(links{i,2},nameList));
    dataMat(idRow,idCol) = links{i,3};
end

% 添加标签名称
BCC = biChordChart(dataMat,'Label',nameList,'Arrow','on', 'Rotation',pi/3);
BCC = BCC.draw();

% 添加刻度
BCC.tickState('on')

% 调节标签半径
% Adjustable Label radius
BCC.setLabelRadius(1.4);

% 显示刻度和数值
% Displays scales and numeric values
BCC.tickState('on')
BCC.tickLabelState('on')

% 修改字体，字号及颜色
BCC.setFont('FontName','Cambria','FontSize',17,'Color',[0,0,0])


