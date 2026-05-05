% demo8
% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

% Linear ticks

rng(1)
dataMat=randi([0,5],[8,8]);

CList=[75,146,241;252,180,65;224,64,10;5,100,146;191,191,191;
    26,59,105;255,227,130;18,156,221;202,107,75;0,92,219;
    243,210,136;80,99,129;241,185,168;224,131,10;120,147,190]./255;

figure('Units','normalized','Position',[.02,.05,.6,.85])
% TickMode 'value'(default)/'linear'/auto
BCC=biChordChart(dataMat,'Arrow','on','CData',CList,'TickMode','Linear');

% % 刻度的设置要在draw()之前
% % the setting of tick should before draw()
% % 刻度的紧密程度，数值越高刻度线数量越多
% % The compact degree of ticks, The higher the value, the more scales there are
% BCC.linearTickCompactDegree = 2;
% % 是否开启次刻度线
% % Minor ticks 'on'/'off'
% BCC.linearMinorTick = 'on';


BCC=BCC.draw();

% 添加刻度
BCC.tickState('on')
BCC.tickLabelState('on')

