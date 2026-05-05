% demo10
% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

links = {'N','NE',252.4; 'NW','N',44.7; 'NW','W',11.4; 'NW','SW',7.9
'W','NW',43.1; 'SW','NW',35; 'SW','W',37.4; 'SW','S',10.6
'S','N',20.3; 'S','SW',88.5; 'SE','SW',89.7; 'SE','S',40.3
'E','SE',69.6; 'NE','N',27.4; 'NE','NW',6.9; 'NE','SE',14.1; 'NE','E',93.4};

% Change links into adjacency matrix and name list
[adjMat, nodeList]=links2AdjMat(links);

Theta=linspace(pi/2,2*pi+pi/2,9);

figure('Units','normalized','Position',[.02,.05,.6,.85])
BCC=biChordChart(adjMat,'Label',nodeList,'Arrow','on','TickMode','auto','Sep',1/2.2,'Rotation',Theta);
BCC=BCC.draw();

% 调节标签半径
% Adjustable Label radius
BCC.setLabelRadius(1.4);

% 显示刻度和数值
% Displays scales and numeric values
BCC.tickState('on')
BCC.tickLabelState('on')

BCC.labelRotate('on')
txtHdl=findobj(gca,'Tag','BiChordLabel');
for i=1:length(txtHdl)
    if abs(txtHdl(i).Position(2))>1
        set(txtHdl(i),'Rotation',0,'HorizontalAlignment','center');
    end
end


% 修改字体，字号及颜色
BCC.setFont('FontName','Cambria','FontSize',25,'Color',[0,0,.8])



% An assistant function to change links into adjacency matrix and name list
function [adjMat, nodeList] = links2AdjMat(links)
nodeList=unique([links(:,1), links(:,2)], 'stable');
BN = length(nodeList);
adjMat=zeros(BN, BN);
for i=1:size(links,1)
    sourceInd=strcmp(links{i,1},nodeList);
    targetInd=strcmp(links{i,2},nodeList);
    adjMat(sourceInd,targetInd)=links{i,3};
end
end