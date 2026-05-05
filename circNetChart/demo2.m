Data = triu(randi([1, 20], [18, 18]));

%% Node-Size-Lim and Edge-Width-Lim
figure()
CN4 = circNetChart(Data);
% Node radius is mapped from diagonal values; 
% edge width is mapped from off‑diagonal values (separate mappings).
% The minimum non‑zero diagonal value maps to the first element of NodeSizeLim, 
% and the maximum maps to the second. (The same applies to EdgeWidthLim).
% If the two values of NodeSizeLim are equal, 
% all nodes will have the same size. (The same applies to EdgeWidthLim).
CN4.NodeSizeLim = [.05, .05];
CN4.EdgeWidthLim = [.01, .01];
CN4 = CN4.draw();


%% Label rotate and label porperties
figure()
CN5 = circNetChart(Data);
CN5.NodeSizeLim = [.05, .05];
CN5.EdgeWidthLim = [.01, .01];
CN5 = CN5.draw();

% Enable label rotation for better readability.
CN5.labelRotate('on')
% Set global label style: monospaced font, size 15.
CN5.setLabel('FontName', 'Monospaced', 'FontSize',15)
% Customize the 2nd label individually with blue color.
CN5.setLabelN(2, 'Color',[0,0,.8])


%% Curvature (Default : 0.5 | Straight line: 0 | Bezier curve: 1)
figure()
CN6 = circNetChart(Data);
CN6.NodeSizeLim = [.05, .05];
CN6.EdgeWidthLim = [.01, .01];
CN6.Curvature = 0;  % Straight line: 0
CN6 = CN6.draw();

figure()
CN7 = circNetChart(Data);
CN7.NodeSizeLim = [.05, .05];
CN7.EdgeWidthLim = [.01, .01];
CN7.Curvature = 1;  % Bezier curve: 1
CN7.NodeColor = turbo(18);
CN7 = CN7.draw();


%% Node name
Data = triu(randi([1, 20], [5, 5]));
figure()
CN8 = circNetChart(Data);
CN8.NodeName = {'AAA','BBB','CCC','DDD','EEE'}; % Change node name
CN8 = CN8.draw();
