Data = triu(randi([1, 20], [40, 40]));
Data((rand(40) + eye(40)) < .9) = 0;

% Define node groups
Group = [ones(1,5), ones(1,5).*2, ones(1,8).*3, ones(1,12).*4, ones(1,8).*5, 1, 1];
groupName = {'Set-AAA','Set-BBB','Set-CCC','Set-DDD','Set-EEE'};

CList = [127, 91,  93; 187, 128, 110; 197, 173, 143;  59,  71, 111; 104,  95, 126]./255;
% CList = [78, 101, 155; 138, 140, 191; 184, 168, 207; 231, 188, 198; 253, 207, 158]./255;

%% Group
figure()
CN9 = circNetChart(Data);
CN9.NodeSizeLim = [.03, .03];
CN9.EdgeWidthLim = [.01, .01];
CN9.Curvature = .8;

CN9.NodeColor = CList(Group, :);  % Color nodes by group membership
CN9.RenderingMethod = 'interp';   % RenderingMethod : interp

% Group layout settings
CN9.Group = Group;                % Group assignment for each node
CN9.GroupSep = 1/4;               % Group gaps occupy 1/4 of the circle
% CN9.GroupName  = groupName;
% CN9.GroupLabelRadius = 1.35;


CN9 = CN9.draw();

% Enable label rotation for better readability.
CN9.labelRotate('on')
% Set global label style: monospaced font, size 12.
CN9.setLabel('FontName', 'Monospaced', 'FontSize',12)
% % Set global group label style: monospaced font, size 21.
% CN9.setGroupLabel('FontName', 'Monospaced', 'FontSize',21)


% Create legend for each group
[~, ind] = unique(Group);
legend(CN9.nodeHdl(ind), groupName, 'FontName', 'Monospaced', 'FontSize',12, 'Location','best')