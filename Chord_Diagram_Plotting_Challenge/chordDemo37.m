% chordDemo37

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

rng(3)
dataMat = rand(100).*(rand(100) > .997);
label = compose('id-%d', 10001:10100);

N = size(dataMat, 1);
figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Label',label, 'Sep',1/2, 'SRadius',[1.01,1.05], 'LRadius',1.07);
BCC.CData = hsv(N + 1)./1.2;
BCC.draw()

BCC.labelRotate('on')
BCC.setFont('FontSize',11)
BCC.setSquare('LineWidth',1, 'EdgeColor','k', 'LineJoin','chamfer')
% To improve the efficiency of property assignment, a logical matrix is utilized.
BCC.setChord(dataMat > 0, 'FaceColor',[165,165,165]./255, 'EdgeColor',[165,165,165]./255)
axis([-1.25,1.25,-1.25,1.25])