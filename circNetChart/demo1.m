%% demo1 : Basic usage and rendering method

Data = [25,  0,  0, 22, 24, 25,  8,  0, 0;
         0, 14,  0,  0,  0,  0,  6,  4, 1;
         0,  0, 11,  0,  0,  0,  0,  0, 7;
         0,  0,  0, 22,  0, 20, 17,  0, 0;
         0,  0,  0,  0, 24,  3,  6,  3, 0;
         0,  0,  0,  0,  0, 25,  7,  0, 2;
         0,  0,  0,  0,  0,  0, 17,  0, 0;
         0,  0,  0,  0,  0,  0,  0, 11, 0;
         0,  0,  0,  0,  0,  0,  0,  0, 5];

% Input required: Upper triangular adjacency matrix
% Node radius is mapped from diagonal values; 
% edge width is mapped from off‑diagonal values (separate mappings).


%% Basic usage (default RenderingMethod : simple)
figure()
% Create circular network chart object and draw.
CN1 = circNetChart(Data);
CN1 = CN1.draw();


%% Change color (RenderingMethod : interp)
figure()
CList = [127, 91, 93; 187,128,110; 197,173,143;  59, 71,111; 104, 95,126;  76,103, 86; 
         112,112,124;  72, 39, 24; 197,119,106; 160,126, 88; 238,208,146]./255;

CN2 = circNetChart(Data);
CN2.RenderingMethod = 'interp';  % RenderingMethod : interp
CN2.NodeColor = CList;           % Change node color
% CN2.EdgeColor = CList;         % Change edge color (Edge color defaults to match node color)
CN2 = CN2.draw();


%% RenderingMethod : map
figure()
CN3 = circNetChart(Data);
CN3.RenderingMethod = 'map';     % RenderingMethod : map (Map values to colors) 
CN3 = CN3.draw();

colormap(turbo)
colorbar('FontName','Times New Roman', 'FontSize',15)

