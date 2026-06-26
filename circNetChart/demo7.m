%% Display both positive and negative correlations

% Define a diverging colormap for positive/negative values (定义用于正负值的发散配色)
cmp = [103,   0,  31; 157,  17,  40; 193,  55,  58; 218, 106,  85; 240, 155, 122;
       249, 196, 169; 251, 227, 213; 247, 247, 246; 220, 234, 242; 182, 215, 232;
       135, 190, 218;  78, 154, 199;  48, 121, 182;  25,  87, 151;   5,  48,  97]./255;

rng(1)
Data = triu(rand([15, 15]) - .5) .* (rand([15,15]) > .8);

% Create circular network chart (创建圆形网络图)
CN = circNetChart(Data);
CN.NodeSizeLim = [.05, .05];   % Fixed node size (固定节点大小)
CN.NodeValue = ones(1, 15);    % Uniform node values (统一节点值)
CN.RenderingMethod = 'map';    % Color edges by value (按值对边上色)
CN.EdgeOrder = 'ascend';       % Draw edges from small to large (从小到大绘制边)
CN.EdgeAlpha = .6;             % Edge transparency (边透明度)
CN.draw()                      

colormap(cmp)
colorbar()
clim([-.5, .5])               