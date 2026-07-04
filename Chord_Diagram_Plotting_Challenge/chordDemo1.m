% chordDemo1

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer
rng(2)

dataMat = randi([0,5], [11,5]);
dataMat(1:6,1) = 0;
dataMat([11,7],1) = [45,25];
dataMat([1,4,5,7],2) = [20,20,30,30];
dataMat(:,3) = 0;
dataMat(6,3) = 45;
dataMat(1:5,4) = 0;
dataMat([6,7],4) = [25,25];
dataMat([5,6,9],5) = [25,25,25];

colName = {'Fly', 'Beetle', 'Leaf', 'Soil', 'Waxberry'};
rowName = {'Bartomella', 'Bradyrhizobium', 'Dysgomonas', 'Enterococcus',...
           'Lactococcus', 'norank', 'others', 'Pseudomonas', 'uncultured',...
           'Vibrionimonas', 'Wolbachia'};

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
CC = chordChart(dataMat, 'RowName',rowName, 'ColName',colName, 'Sep',1/80, 'TickMode','auto');
CC = CC.draw();
% 修改上方方块颜色(Modify the color of the blocks above)
CListT = [0.7765 0.8118 0.5216; 0.4431 0.4706 0.3843; 0.5804 0.2275 0.4549;
          0.4471 0.4039 0.6745; 0.0157 0      0     ];
CC.setSquareColorT(CListT)

% 修改下方方块颜色(Modify the color of the blocks below)
CListS = [0.5843 0.6863 0.7843; 0.1098 0.1647 0.3255; 0.0902 0.1608 0.5373;
          0.6314 0.7961 0.2118; 0.0392 0.2078 0.1059; 0.0157 0      0     ;
          0.8549 0.9294 0.8745; 0.3882 0.3255 0.4078; 0.5020 0.7216 0.3843;
          0.0902 0.1843 0.1804; 0.8196 0.2314 0.0706];
CC.setSquareColorS(CListS)

% 修改弦颜色(Modify chord color)
CC.setChordColorBySquareT()
CC.setChord('FaceAlpha',.5)

CC.tickState('on')
CC.labelRotate('on')
CC.setFont('FontSize',17, 'FontName','Cambria')
CC.tickLabelState('on');


CC.labelRotate('off')
textHdl = findobj(gca,'Tag','ChordLabel');
for i = 1:length(textHdl)
    if textHdl(i).Position(2) < 0
        if abs(textHdl(i).Position(1)) > .7
            textHdl(i).Rotation = textHdl(i).Rotation + 45;
            textHdl(i).HorizontalAlignment = 'right';
            if textHdl(i).Rotation > 90
                textHdl(i).Rotation = textHdl(i).Rotation + 180;
                textHdl(i).HorizontalAlignment = 'left';
            end
        else
            textHdl(i).Rotation = textHdl(i).Rotation + 10;
            textHdl(i).HorizontalAlignment = 'right';
        end
    end
end