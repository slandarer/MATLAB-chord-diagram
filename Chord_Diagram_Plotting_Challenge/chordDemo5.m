% chordDemo5

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

dataMat = randi([1, 20], [14, 3]);
dataMat(11:14, 1) = 0;
dataMat(6:10, 2) = 0;
dataMat(1:5, 3) = 0;

colName =  compose('C%d', 1:3);
rowName = [compose('A%d', 1:7), compose('B%d', 7:-1:1)];

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
CC = chordChart(dataMat, 'RowName',rowName, 'ColName',colName, 'Sep',1/80);
CC = CC.draw();
CC.tickState('on')
CC.tickLabelState('on')

% Modify the color of the blocks above (修改上方方块颜色)
CC.setSquareT('FaceColor',[190,190,190]./255)
% Modify the color of the blocks below (修改下方方块颜色)
CListS = [255,244,138; 253,220,117; 254,179, 78; 253,190, 61;
          252, 78, 41; 228, 26, 26; 178,  0, 36;   4, 84,119;
            1,113,137;  21,150,155;  67,176,173;  68,173,158;
          123,204,163; 184,229,162]./255;
CC.setSquareColorS(CListS)
% Modify chord color (修改弦颜色)
CC.setChordColorBySquareS()
CC.setChord('FaceAlpha',.5)


