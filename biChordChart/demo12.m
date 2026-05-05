% demo12 
% Features under testing

dataMat=randi([0,8],[5,5]);

BCC=biChordChart(dataMat,'Arrow','on');
BCC=BCC.draw();

% 添加刻度
BCC.tickState('on')

% 添加数值标签
for i=1:size(BCC.dataMat,1)
    thetaSet=[BCC.dataMat(i,:),BCC.dataMat(:,i).'];
    thetaSet(thetaSet==0)=[];
    for j=1:length(BCC.thetaFullSet{i})-1
        tTheta=(BCC.thetaFullSet{i}(j)+BCC.thetaFullSet{i}(j+1))/2;
        rotation=mod(tTheta/pi*180,360);
        if ~isnan(BCC.thetaFullSet{i}(j+1))
            if rotation>90&&rotation<270
                rotation=rotation+180;
                text(cos(tTheta).*1.2,sin(tTheta).*1.2,num2str(thetaSet(j)),...
                    'Rotation',rotation,'HorizontalAlignment','right','FontSize',9,'FontName','Arial');
            else
                text(cos(tTheta).*1.2,sin(tTheta).*1.2,num2str(thetaSet(j)),...
                    'Rotation',rotation,'FontSize',9,'FontName','Arial');
            end
        end
    end
end