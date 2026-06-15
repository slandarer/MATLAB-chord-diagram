%% Set SSqRatio and OSqRatio


dataMat = round(10.*rand([11,4]).*((11:-1:1).'+1))./10;
colName = {'A','B','C','D'};
rowName = {'Acidobacteriota', 'Actinobacteriota', 'Proteobacteria', ...
           'Chloroflexi', 'Bacteroidota', 'Firmicutes', 'Gemmatimonadota', ...
           'Verrucomicrobiota', 'Patescibacteria', 'Planctomyetota', 'Others'};

figure('Units','normalized', 'Position',[.02,.05,.8,.85])
CC = chordChart(dataMat, 'ColName',colName, 'Sep',1/80, 'SSqRatio',-30/100, 'OSqRatio',80/100);
CC.RowName = repmat({' '}, [1, length(rowName)]);
CC = CC.draw();

% 修改上方方块颜色(Modify the color of the blocks above)
CListT = [.93,.60,.62; .55,.80,.99; .95,.82,.18; 1.0,.81,.91];
CC.setSquareColorT(CListT)
% 修改下方方块颜色(Modify the color of the blocks below)
CListF = [.75,.73,.86; .56,.83,.78; .00,.60,.20; 1.0,.49,.02; .78,.77,.95; .59,.24,.36; 
          .98,.51,.45; .96,.55,.75; .47,.71,.84; .65,.35,.16; .40,.00,.64];
CC.setSquareColorF(CListF)
% 修改弦颜色(Modify chord color)
CC.setChordColorBySquareF()
% CC.setChordColorBySquareT()

% 添加刻度
CC.tickState('on')
% 修改字体，字号及颜色
CC.setFont('FontName','Cambria', 'FontSize',17)


% 绘制图例(Draw legend)
lgdHdl = legend(CC.squareFHdl, rowName, 'Location','eastoutside', ...
    'FontSize',16, 'FontName','Cambria', 'Box','off');
lgdHdl.ItemTokenSize = [18,8];














%{


% 修改上方方块颜色(Modify the color of the blocks above)
CListT = [0.93,0.60,0.62; 0.55,0.80,0.99; 0.95,0.82,0.18; 1.00,0.81,0.91];
for i = 1:size(dataMat, 2)
    CC.setSquareT_N(i, 'FaceColor',CListT(i,:))
end

% 修改下方方块颜色(Modify the color of the blocks below)
CListF = [0.75,0.73,0.86; 0.56,0.83,0.78; 0.00,0.60,0.20; 1.00,0.49,0.02
    0.78,0.77,0.95; 0.59,0.24,0.36; 0.98,0.51,0.45; 0.96,0.55,0.75
    0.47,0.71,0.84; 0.65,0.35,0.16; 0.40,0.00,0.64];
for i = 1:size(dataMat, 1)
    CC.setSquareF_N(i, 'FaceColor',CListF(i,:))
end


% 修改弦颜色(Modify chord color)
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        % CC.setChordMN(i,j, 'FaceColor',CListF(i,:), 'FaceAlpha',.4)
        CC.setChordMN(i,j, 'FaceColor',CListT(j,:), 'FaceAlpha',.4)
    end
end

% 单独设置每一个弦末端方块(Set individual end blocks for each chord)
% Use obj.setEachSquareF_Prop 
% or  obj.setEachSquareT_Prop
% F means from (blocks below)
% T means to   (blocks above)
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        CC.setEachSquareT_Prop(i,j, 'FaceColor', CListF(i,:))
        CC.setEachSquareF_Prop(i,j, 'FaceColor', CListT(j,:))
    end
end

% 添加刻度
CC.tickState('on')
% 修改字体，字号及颜色
CC.setFont('FontName','Cambria', 'FontSize',17)

% 绘制图例(Draw legend)
lgdHdl = legend(CC.squareFHdl, rowName, 'Location','eastoutside', 'FontSize',16, 'FontName','Cambria', 'Box','off');
lgdHdl.ItemTokenSize = [18,8];


%}