%% Square, tick, label radius | square ratio

rng(1)
dataMat=randi([1,5],[3,3]);

% 创建弦图对象(Create bichord diagram object)
BCC=biChordChart(dataMat,'Arrow','on', 'Sep',1/3.5);
BCC.CData = lines(3);

% See radius&ratio.png for details
BCC.OSqRatio = .4;        
BCC.SSqRatio = .4;
BCC.SRadius = [1.1, 1.4];
BCC.TRadius = 1.5;
BCC.LRadius = 1.7;


% BCC.OriSquareRatio = .4;        
% BCC.SubSquareRatio = .4;
% BCC.SquareRadius = [1.1, 1.4];
% BCC.TickRadius = 1.5;
% BCC.LabelRadius = 1.7;


% 开始绘图(Start drawing)
BCC=BCC.draw();

% 添加刻度(Show ticks and tick labels)
BCC.tickState('on')
BCC.tickLabelState('on')


set(gca,'XLim',[-1.8,1.8], 'YLim',[-1.8,1.8])










%{
t1 = pi*.85; t2 = [pi*.85, pi*.83]; t3 = pi*.83;
plot(cos(t1).*[1.1, 1.7], sin(t1).*[1.1, 1.7], 'Color','k', 'LineWidth',1)
plot(cos(t2).*1.1, sin(t2).*1.1, 'Color','k', 'LineWidth',1)
plot(cos(t2).*1.4, sin(t2).*1.4, 'Color','k', 'LineWidth',1)
plot(cos(t2).*1.5, sin(t2).*1.5, 'Color','k', 'LineWidth',1)
plot(cos(t2).*1.7, sin(t2).*1.7, 'Color','k', 'LineWidth',1)
text(cos(t3).*1.1, sin(t3).*1.1, 'SRadius(1)', 'FontSize',13, 'Rotation',t3/pi*180-90)
text(cos(t3).*1.4, sin(t3).*1.4, 'SRadius(2)', 'FontSize',13, 'Rotation',t3/pi*180-90)
text(cos(t3).*1.5, sin(t3).*1.5, 'TRadius', 'FontSize',13, 'Rotation',t3/pi*180-90)
text(cos(t3).*1.7, sin(t3).*1.7, 'LRadius', 'FontSize',13, 'Rotation',t3/pi*180-90)

t4 = pi*.08; t5 = [pi*.08, pi*.07]; t6 = pi*.07;
plot(cos(t4).*[1.1, 1.4], sin(t4).*[1.1, 1.4], 'Color','k', 'LineWidth',1)
plot(cos(t5).*1.1, sin(t5).*1.1, 'Color','k', 'LineWidth',1)
plot(cos(t5).*1.4, sin(t5).*1.4, 'Color','k', 'LineWidth',1)
plot(cos(t5).*(1.1 + .4*.3), sin(t5).*(1.1 + .4*.3), 'Color','k', 'LineWidth',1)
text(cos(t6).*1.1, sin(t6).*1.1, '0', 'FontSize',13, 'Rotation',t6/pi*180-90)
text(cos(t6).*1.4, sin(t6).*1.4, '1', 'FontSize',13, 'Rotation',t6/pi*180-90)
text(cos(t6).*(1.1 + .4*.3), sin(t6).*(1.1 + .4*.3), '0.4', 'FontSize',14, 'Rotation',t6/pi*180-90)

t7 = - pi*.08; t8 = - [pi*.08, pi*.07]; t9 = - pi*.07;
plot(cos(t7).*[1.1, 1.4], sin(t7).*[1.1, 1.4], 'Color','k', 'LineWidth',1)
plot(cos(t8).*1.1, sin(t8).*1.1, 'Color','k', 'LineWidth',1)
plot(cos(t8).*1.4, sin(t8).*1.4, 'Color','k', 'LineWidth',1)
plot(cos(t8).*(1.4 - .4*.3), sin(t8).*(1.4 - .4*.3), 'Color','k', 'LineWidth',1)
text(cos(t9).*1.1, sin(t9).*1.1, '1', 'FontSize',13, 'Rotation',t9/pi*180+90)
text(cos(t9).*1.4, sin(t9).*1.4, '0', 'FontSize',13, 'Rotation',t9/pi*180+90)
text(cos(t9).*(1.4 - .4*.3), sin(t9).*(1.4 - .4*.3), '0.4', 'FontSize',14, 'Rotation',t9/pi*180+90)

text(1.5,.2, 'SSqRatio=0.4', 'FontSize',13)
text(1.5,-.2, 'OSqRatio=0.4', 'FontSize',13)
%}