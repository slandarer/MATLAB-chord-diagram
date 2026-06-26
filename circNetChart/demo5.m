%% GraphType : 'bi'

rng(6)
Data = rand(9,9).*(rand(9,9) > .5);
% Determine global value limits from non‑zero entries for consistent mapping across figures 
% (确定非零元素的全局数值范围，用于两张图统一的数值映射)
VLim = [min(Data(Data~=0)), max(Data(Data~=0))];


figure()
CN1 = circNetChart(Data, 'GraphType','bi');
CN1.EdgeWidthLim = [0.005, 0.04];          
CN1.EdgeValueLim = VLim;                   % Set value mapping range (设置数值映射范围)
CN1.NodeColor = turbo(9);                  % Node colors from turbo (节点颜色使用 turbo 配色)
CN1.RenderingMethod = 'source';            % Color edges by source node (按源节点对边着色)
CN1.EdgeAlpha = .6;                        % Set edge transparency (设置边透明度)
CN1 = CN1.draw();


%% % Plot only the edges whose source is node N (仅绘制源为 N 的边)
figure()
S = 2; % also try: 2, 4, 7, 9, ...
DataS = 0.*Data;
DataS(S, :) = Data(S, :);

CN2 = circNetChart(DataS, 'GraphType','bi');
CN2.NodeValue = max(max(Data, [], 1), max(Data, [], 2).');  % Keep original node values (保留原始节点值)
CN2.EdgeWidthLim = [0.005, 0.04];
CN2.EdgeValueLim = VLim;
CN2.NodeColor = turbo(9);
CN2.RenderingMethod = 'source';
CN2.EdgeAlpha = .6;
CN2 = CN2.draw();
