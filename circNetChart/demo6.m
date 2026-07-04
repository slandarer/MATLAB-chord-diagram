%% Apply distinct colormaps to edges and nodes

% Define colormap for edges (定义边的配色)
cmpE = [247, 251, 255; 233, 242, 250; 219, 233, 246; 205, 224, 241; 187, 214, 235;
        164, 204, 227; 136, 190, 220; 107, 174, 214;  84, 158, 205;  61, 141, 196;
         42, 122, 186;  26, 104, 174;  12,  86, 160;   8,  67, 135;   8,  48, 107]./255;

% Define colormap for nodes (定义节点的配色)
cmpN = [247, 252, 253; 237, 248, 251; 225, 244, 246; 211, 239, 235; 189, 230, 222;
        160, 219, 205; 131, 207, 185; 102, 194, 164;  81, 183, 138;  61, 169, 111;
         44, 149,  83;  25, 130,  62;   5, 113,  48;   0,  91,  37;   0,  68,  27]./255;

% Generate random upper triangular data (生成随机上三角数据)
rng(11)
Data = triu(rand([15, 15])).*(1 - triu(rand([15, 15]), 1)>.8);

% Create circular network chart and set properties (创建圆形网络图并设置属性)
CN = circNetChart(Data);
CN.EdgeWidthLim = [.01, .05];   % Edge width range (边宽范围)
CN.Curvature = 0;               % Straight edges (直线边)
CN.RenderingMethod = 'map';     % Use colormap mapping (使用颜色映射)
CN.EdgeAlpha = .6;              % Edge transparency (边透明度)
CN.EdgeOrder = 'ascend';        % Draw edges from small to large (从小到大绘制边)
CN.draw()                       
set(CN.nodeHdl, 'EdgeColor','k', 'LineWidth',2)

% Apply node colormap and add colorbar (应用节点配色并添加颜色条)
cbarN = CN.setNodeColorByColormap(cmpN);
cbarN.Position = [.78, .11, .02, .35];
set(cbarN.Label, 'String','Node Value', 'FontSize',17, 'FontName','Times New Roman');

% Apply edge colormap and add colorbar (应用边配色并添加颜色条)
colormap(CN.ax, cmpE)
cbarE = colorbar(CN.ax);
cbarE.Position = [.78, .575, .02, .35];
set(cbarE.Label, 'String','Edge Value', 'FontSize',17, 'FontName','Times New Roman');










% % Apply node colormap and add colorbar (应用节点配色并添加颜色条)
% cbarN = CN.setNodeColorByColormap(cmpN);
% cbarN.Location = 'north';
% cbarN.Position = [.13, .1, .35, .025];
% set(cbarN.Label, 'String','Node Value', 'FontSize',17, 'FontName','Times New Roman');
% 
% % Apply edge colormap and add colorbar (应用边配色并添加颜色条)
% colormap(CN.ax, cmpE)
% cbarE = colorbar(CN.ax);
% cbarE.Location = 'north';
% cbarE.Position = [0.5550, .1, .35, .025];
% set(cbarE.Label, 'String','Edge Value', 'FontSize',17, 'FontName','Times New Roman');