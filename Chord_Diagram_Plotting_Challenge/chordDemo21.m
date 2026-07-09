% chordDemo21

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer 


dataMat = rand(25).*(rand(25) > .9);
nameList = [compose('Group-A-%d',1:6), compose('Group-B-%d',1:10), compose('Group-C-%d',1:9)];
group = [ones(1,6), ones(1,10).*2, ones(1,9).*3];
groupC = [125,97,72; 53,127,190; 239,161,55]./255;

figure('Units','normalized', 'Position',[.02,.05,.9,.85])
BCC = biChordChart(dataMat, 'Label', nameList, 'GroupSep',1/60, 'LRadius',1.2);
BCC.Group = group;
BCC.CData = groupC(group, :);
BCC.draw()
% Property settings
BCC.labelRotate('on')
BCC.setChord('FaceAlpha',.5)
BCC.setFontColor(groupC(group, :))
BCC.setFont('FontWeight','bold')
BCC.setChordCData(dataMat)
% Draw colorbar
colormap(flipud(summer(25)))
axis([-1.6, 1.6, -1.6, 1.6])
colorbar('Position', [.76,.32,.02,.18], 'FontSize',14, 'LineWidth',2, 'TickDirection','out');
% Draw legend
[~, tind] = unique(group);
text([1.6, 1.6], [0.05, .8], {'Value', 'Group'}, 'FontSize',18, 'FontWeight','bold')
lgdHdl = legend(BCC.squareHdl(tind), {'Group-A','Group-B','Group-C'}, ...
    'Position',[.71,.6,.167,.1], 'FontSize',14, 'Box','off', 'FontWeight','bold');
lgdHdl.ItemTokenSize = [18,8];
