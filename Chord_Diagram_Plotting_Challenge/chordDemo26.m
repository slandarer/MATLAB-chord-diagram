% chordDemo26

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

dataMat = randi([0, 20], [12, 12]).*(rand(12) > .6);
label   = {'BULB','STR','HC','CX'};
group   = [1,1,1,1,2,2,2,2,3,3,3,3];
node    = [1,2,3,4,1,2,3,4,1,2,3,4];
colors  = [239,82,127; 250,164,45; 187,190,51]./255;

BCC = biChordChart(dataMat, 'Label',label(node), 'Group',group, 'GroupSep',1/10, ...
    'TickMode','linear', 'SRadius', [1.03, 1.13], 'TRadius',1.135, 'LRadius',1.3);
BCC.CData = colors(group, :);
BCC.LinearMinorTick = 'on';
BCC.LinearTickCompactDegree = 1;
BCC.draw()

BCC.setChord('FaceAlpha',.5)
BCC.setTick('LineWidth',1)
BCC.setTickFont('FontSize',13)
BCC.tickState('on')
BCC.tickLabelState('on')