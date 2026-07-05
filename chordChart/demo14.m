%% Square, tick, label radius | square ratio

dataMat = [2 0 1 2 5 1 2;
           3 5 1 4 2 0 1;
           4 0 5 5 2 4 3];

CC = chordChart(dataMat, 'GroupSep', 1/5);

% See radius&ratio.png for details
CC.OSqRatio = .4;        
CC.SSqRatio = .4;
CC.SRadius = [1.1, 1.4];
CC.TRadius = 1.5;
CC.LRadius = 1.7;

% CC.OriSquareRatio = .4;        
% CC.SubSquareRatio = .4;
% CC.SquareRadius = [1.1, 1.4];
% CC.TickRadius = 1.5;
% CC.LabelRadius = 1.7;
CC = CC.draw();

% Modify the color of the blocks above (修改上方方块颜色)
CListT = [0.75,0.73,0.86; 0.56,0.83,0.78; 0.00,0.60,0.20; 1.00,0.49,0.02
          0.78,0.77,0.95; 0.59,0.24,0.36; 0.98,0.51,0.45];
CC.setSquareColorT(CListT)
% Modify the color of the blocks below (修改下方方块颜色)
CListS = [0.93,0.60,0.62; 0.55,0.80,0.99; 0.95,0.82,0.18; 1.00,0.81,0.91];
CC.setSquareColorS(CListS)

% Modify chord color (修改弦颜色)
CC.setChordColorBySquareT()

% Displays scales and numeric values (显示刻度和数值)
CC.tickState('on')
CC.tickLabelState('on')

set(gca,'XLim',[-1.8,1.8], 'YLim',[-1.8,1.8])

%{
t1 = pi*.92; t2 = [pi*.92, pi*.94]; t3 = pi*.94;
plot(cos(t1).*[1.1, 1.7], sin(t1).*[1.1, 1.7], 'Color','k', 'LineWidth',1)
plot(cos(t2).*1.1, sin(t2).*1.1, 'Color','k', 'LineWidth',1)
plot(cos(t2).*1.4, sin(t2).*1.4, 'Color','k', 'LineWidth',1)
plot(cos(t2).*1.5, sin(t2).*1.5, 'Color','k', 'LineWidth',1)
plot(cos(t2).*1.7, sin(t2).*1.7, 'Color','k', 'LineWidth',1)
text(cos(t3).*1.1, sin(t3).*1.1, 'SRadius(1)', 'FontSize',13, 'Rotation',t3/pi*180-90, 'HorizontalAlignment','right')
text(cos(t3).*1.4, sin(t3).*1.4, 'SRadius(2)', 'FontSize',13, 'Rotation',t3/pi*180-90, 'HorizontalAlignment','right')
text(cos(t3).*1.5, sin(t3).*1.5, 'TRadius', 'FontSize',13, 'Rotation',t3/pi*180-90, 'HorizontalAlignment','right')
text(cos(t3).*1.7, sin(t3).*1.7, 'LRadius', 'FontSize',13, 'Rotation',t3/pi*180-90, 'HorizontalAlignment','right')


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