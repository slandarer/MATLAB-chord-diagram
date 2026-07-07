% chordDemo16

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

dataMat = rand([15, 15]);
dataMat(dataMat > .2) = 0;

CList = [ 67,115,181; 173,136, 76; 156, 66, 43;  25, 88,124; 136,142,151; 
          37, 63,100; 175,164,115;  32,121,169; 143, 92, 82;  22, 83,168; 
         167,154,118;  70, 87,114; 166,139,138; 156,106, 43;  94,116,151]./255;

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Arrow','on', 'CData',CList);
BCC = BCC.draw();

BCC.tickState('on')
BCC.setFont('FontName','Cambria', 'FontSize',17, 'Color',[0,0,0])

% 修改弦颜色 (Modify chord color)
BCC.setChord('FaceColor',[ 54, 69, 92]./255 ,'FaceAlpha',.07)
[~, N] = max(sum(dataMat > 0, 2));
BCC.setChord(N, [], 'FaceColor',CList(N,:), 'FaceAlpha',.6)