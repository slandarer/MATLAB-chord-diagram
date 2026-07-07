%% Properties setting

rng(2)
dataMat = randi([0, 3], [6, 6]);

NameList = {'CHORD','CHART','MADE','BY','SLANDARER','MATLAB'};
BCC = biChordChart(dataMat, 'Label',NameList, 'Arrow','on', 'CData',bone(9));
BCC = BCC.draw();

% Show ticks (添加刻度)
BCC.tickState('on')

% Set font properties (修改字体，字号及颜色)
BCC.setFont('FontName','Cambria','FontSize',17,'Color',[0,0,.8])

% Set chord properties (设置弦属性)
% obj.BCC.setChord(___)        | Set properties for all chords
% obj.BCC.setChord(m, [], ___) | Set properties for all chords
%                                from the m-th source to every target.
% obj.BCC.setChord(m, n, ___)  | Set properties for all chord connect
%                                m-th node with n-th node
BCC.setChord(1, [], 'EdgeColor','k', 'LineWidth',1) 
BCC.setChord(2, 3, 'EdgeColor',[.8,0,0], 'LineWidth',1) 

% Set square properties (设置弧形块属性)
% obj.setSquare(___)           | Set properties for all squares.
% obj.setSquare(n, ___)        | Set properties for n-th square.
BCC.setSquare('EdgeColor',[0,0,.8], 'LineWidth',3)
BCC.setSquare(1, 'EdgeColor',[.8,0,0])