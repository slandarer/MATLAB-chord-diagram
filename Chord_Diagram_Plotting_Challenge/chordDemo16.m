% chordDemo16

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

dataMat = rand([15,15]);
dataMat(dataMat > .2) = 0;

CList = [ 75,146,241; 252,180, 65; 224, 64, 10;   5,100,146; 191,191,191;
          26, 59,105; 255,227,130;  18,156,221; 202,107, 75;   0, 92,219;
         243,210,136;  80, 99,129; 241,185,168; 224,131, 10; 120,147,190]./255;
CListC = [54,69,92]./255;
CList = CList.*.6 + CListC.*.4;

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Arrow','on', 'CData',CList);
BCC = BCC.draw();

% 添加刻度
BCC.tickState('on')

% 修改字体，字号及颜色
BCC.setFont('FontName','Cambria', 'FontSize',17, 'Color',[0,0,0])

% 修改弦颜色(Modify chord color)
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        if dataMat(i,j) > 0
            BCC.setChordMN(i,j, 'FaceColor',CListC ,'FaceAlpha',.07)
        end
    end
end
[~, N] = max(sum(dataMat > 0, 2));
for j = 1:size(dataMat, 2)
    BCC.setChordMN(N,j, 'FaceColor',CList(N,:) ,'FaceAlpha',.6)
end
