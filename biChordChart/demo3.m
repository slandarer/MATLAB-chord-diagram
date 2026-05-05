% demo 3
% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

% Chord chart with label rotated

dataMat=randi([0,8],[6,6]);

% 添加标签名称(Add names for each row/col)
nameList={'CHORD','CHART','MADE','BY','SLANDARER','MATLAB'};

figure('Units','normalized','Position',[.02,.05,.6,.85])
BCC=biChordChart(dataMat,'Label',nameList,'Arrow','on');
BCC=BCC.draw(); 

% 添加刻度(Show ticks)
BCC.tickState('on')

% 修改字体，字号及颜色(Set font properties)
BCC.setFont('FontName','Cambria','FontSize',17,'Color',[.2,.2,.2])

% version 1.1.0更新
% 函数labelRotate用来旋转标签
% The function labelRatato is used to rotate the label
BCC.labelRotate('on')

% BCC.setLabelRadius(1.3);
% BCC.tickLabelState('on')











% % 以下代码用来旋转标签
% % The following code is used to rotate the label
% textHdl=findobj(gca,'Type','Text');
% for i=1:length(textHdl)
%     if textHdl(i).Rotation<-90
%         textHdl(i).Rotation=textHdl(i).Rotation+180;
%     end
%     switch true
%         case textHdl(i).Rotation<0&&textHdl(i).Position(2)>0
%             textHdl(i).Rotation=textHdl(i).Rotation+90;
%             textHdl(i).HorizontalAlignment='left';
%         case textHdl(i).Rotation>0&&textHdl(i).Position(2)>0
%             textHdl(i).Rotation=textHdl(i).Rotation-90;
%             textHdl(i).HorizontalAlignment='right';
%         case textHdl(i).Rotation<0&&textHdl(i).Position(2)<0
%             textHdl(i).Rotation=textHdl(i).Rotation+90;
%             textHdl(i).HorizontalAlignment='right';
%         case textHdl(i).Rotation>0&&textHdl(i).Position(2)<0
%             textHdl(i).Rotation=textHdl(i).Rotation-90;
%             textHdl(i).HorizontalAlignment='left';
%     end
% end