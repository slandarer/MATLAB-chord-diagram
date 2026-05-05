% demo9
% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

% The automatic adjustment of scale density

rng(1)
dataMat=randi([0,5],[8,8]);

CList=[75,146,241;252,180,65;224,64,10;5,100,146;191,191,191;
    26,59,105;255,227,130;18,156,221;202,107,75;0,92,219;
    243,210,136;80,99,129;241,185,168;224,131,10;120,147,190]./255;

figure('Units','normalized','Position',[.02,.05,.6,.85])
% TickMode 'value'(default)/'linear'/auto
BCC=biChordChart(dataMat,'Arrow','on','CData',CList,...
    'TickMode','auto','SSqRatio',-30/100, 'OSqRatio',80/100);

BCC=BCC.draw();

% 添加刻度
BCC.tickState('on')
BCC.tickLabelState('on')
