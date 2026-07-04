classdef circNetChart < handle
% circNetChart Create and customize circular network charts (圆形网络图)
%   CN = circNetChart(dataMat); creates a circular network chart from a square 
%   adjacency matrix.
%   从方阵邻接矩阵创建圆形网络图。
%
%   CN = circNetChart(dataMat, 'GraphType', type); specifies the graph type:
%       'un' - undirected graph (upper triangular matrix, diagonal for node values)
%       'bi' - bidirectional graph (allows asymmetric weights, node values computed from row/column maxima)
%   指定图形类型：
%       'un' - 为无向图(上三角矩阵，对角线用于节点值)
%       'bi' - 为双向图(允许非对称权重，节点值由行/列最大值计算)
%
%   CN = circNetChart(dataMat, 'NodeName', nodeName); specifies the node names.
%   指定节点名称。
%
%   CN = circNetChart(ax, ___); creates the chart in the specified axes.
%   在指定坐标区创建图表。
%
%   CN = circNetChart(___, propName, propVal); specifies property name-value
%   pairs when creating the object.
%   创建对象时指定属性名-属性值对。
%
%   CN.propName = propVal; sets properties after creation, before rendering.
%   创建对象后、绘图前设置属性。
%
%   CN = CN.draw(); renders the circular network chart.
%   渲染圆形网络图。
%
% Note:
%   The element dataMat(i, j) represents the connection weight from node i 
%   to node j. dataMat(i, j) 的值代表从节点 i 到节点 j 的连接权重。
%
% Basic usage:
%   Data = triu(randi([1, 5], [6, 6]));
%   CN = circNetChart(Data);
%   CN = CN.draw();


% =========================================================================
% Zhaoxu Liu / slandarer (2026). circular network chart 
% (https://www.mathworks.com/matlabcentral/fileexchange/118655-circular-network-chart), 
% MATLAB Central File Exchange. Retrieved April 25, 2026.
% =========================================================================


% =========================================================================
% Version History (版本更新)
% =========================================================================
% # version 3.0.0
%   + The function now supports bidirectional graph rendering. 
%     try : CN = circNetChart(dataMat, 'GraphType', 'bi')
%   + Supports separate colormaps for nodes and edges.
%     try : obj.setNodeColorByColormap(cmp)
%   + Supports simultaneous display of positive and negative correlations.

    properties
        ax
        arginList = {'RenderingMethod', 'NodeSizeLim', 'EdgeWidthLim', ...
                     'NodeColor', 'EdgeColor', 'Group', 'GroupSep', 'LabelRotate',...
                     'NodeName', 'Curvature', 'GroupName', 'GraphType', ...
                     'NodeValueLim', 'EdgeValueLim', 'EdgeOrder'} 

        dataMat                     % Input adjacency matrix
        signMat                     % 
        NodeName = {}               % Node labels

        GraphType = 'un'            % 'un'/'bi' (undirected/bidirectional)
        NodeValue                   % For the un type, NodeValue(i) is assigned the diagonal element dataMat(i,i).
                                    % For the bi type, NodeValue(i) is set to the larger of the maximum of the i‑th row 
                                    %   and the maximum of the i‑th column of dataMat, i.e.,
                                    %   NodeValue = max(max(dataMat, [], 1), max(dataMat, [], 2).')

        EdgeOrder = 'none'          % 'none'/'ascend'/'descend'
        
        Group = []                  % Group assignment for each node
        GroupName = {};             % Group labels
        GroupSep = 1/32             % Total gap fraction between groups (0-0.5)
        GroupLabelRadius = 1.3;     % Radius for group labels


        % Rendering method: 'simple' (uniform), 'interp' (gradient), 'map' (value-based)
        %                   'source' (bi type only), 'target' (bi type only)
        RenderingMethod = 'simple'
        
        Curvature = 0.5;            % Edge curvature: 0 = straight line, 1 = full Bezier curve
        LabelRotate = 'off'         % Weather to rotate labels

        % Node and edge size limits [min, max] mapped from data values
        NodeSizeLim  = [0.05, 0.1]
        EdgeWidthLim = [0.02, 0.05]

        % Value range mapping: values >= NodeValueLim(2) are mapped to NodeSizeLim(2),
        %                      values <= NodeValueLim(1) are mapped to NodeSizeLim(1). 
        % Similarly,           values >= EdgeValueLim(2) are mapped to EdgeWidthLim(2)
        %                      values <= EdgeValueLim(1) are mapped to EdgeWidthLim(1).
        NodeValueLim = []   
        EdgeValueLim = []

        
        NodeColor = [0.4, 0.4, 0.4]   % Node color
        EdgeColor = 'flat'            % Edge color
        NodeAlpha = 1                 % Node alpha
        EdgeAlpha = 0.3               % Edge alpha
        
                        
        edgeMatHdl                    % Handles for edges
        nodeHdl                       % Handles for nodes
        labelHdl                      % Handles for node labels
        groupLabelHdl                 % Handles for group labels
    end

    properties (Hidden)
        nodeThetaSet  
    end

    methods
        function obj = circNetChart(varargin)
            if isa(varargin{1}, 'matlab.graphics.axis.Axes')
                obj.ax = varargin{1};
                varargin(1) = [];
            else
                obj.ax = gca;
            end
           
            % Store adjacency matrix (take absolute value for weights)
            obj.dataMat = varargin{1};
            obj.signMat = (obj.dataMat < 0).*(- 2) + 1;
            obj.dataMat = abs(obj.dataMat);
            varargin(1) = [];

            % Parse name-value input arguments
            for i = 1:2:(length(varargin) - 1)
                tid = ismember(lower(obj.arginList), lower(varargin{i}));
                if any(tid)
                    obj.(obj.arginList{tid}) = varargin{i + 1};
                end
            end
            
            % Generate default node names if not provided
            if isempty(obj.NodeName)
                obj.NodeName = compose('Node-%d', 1:size(obj.dataMat, 1));
            end
            
            % Validate GroupSep range [0, 0.5]
            obj.GroupSep = abs(obj.GroupSep);
            if obj.GroupSep > 0.5
                obj.GroupSep = 0.5;
            end

            % Set default group assignment if not provided
            if isempty(obj.Group)
                obj.Group = 1:size(obj.dataMat, 1);
            end
            
            % Clamp Curvature to [0, 1]
            obj.Curvature(obj.Curvature > 1) = 1;
            obj.Curvature(obj.Curvature < 0) = 0;

            if strcmpi(obj.GraphType, 'bi')
                obj.NodeValue = max(max(obj.dataMat, [], 1), max(obj.dataMat, [], 2).');
            else
                obj.NodeValue = diag(obj.dataMat).';
            end
        end

        function varargout = draw(obj)
            % Get consecutive group IDs (handles repeated group numbers)
            tGroup = groupConsecutive(obj.Group);
            groupNum = max(tGroup) - (obj.Group(end) == obj.Group(1));
            nodeNum = size(obj.dataMat, 2);

            % Configure axes
            obj.ax.NextPlot = 'add'; 
            obj.ax.XLim = [-nodeNum, nodeNum] .* (1 + max(obj.NodeSizeLim)) .* 1.2;
            obj.ax.YLim = [-nodeNum, nodeNum] .* (1 + max(obj.NodeSizeLim)) .* 1.2;
            obj.ax.XTick = [];
            obj.ax.YTick = [];
            obj.ax.XColor = 'none';
            obj.ax.YColor = 'none';
            obj.ax.PlotBoxAspectRatio = [1, 1, 1];

            % Determine edge color source
            if isstring(obj.EdgeColor) || ischar(obj.EdgeColor)
                tmpColor = obj.NodeColor;      % Use node colors for edges
            else
                tmpColor = obj.EdgeColor;      % Use custom edge colors
            end
            
            % Calculate angular spacing
            gSep = obj.GroupSep ./ groupNum;                    
            nSep = (1 - obj.GroupSep) ./ nodeNum;               
            tt = linspace(0, 2*pi, 50);                        

            % Find min/max values for scaling node radii and edge widths
            minN = min(obj.NodeValue(obj.NodeValue ~= 0));
            maxN = max(obj.NodeValue(obj.NodeValue ~= 0));

            if strcmpi(obj.GraphType, 'bi')
                offDiagVals = obj.dataMat(obj.dataMat ~= 0);
            else
                offDiagVals = obj.dataMat(eye(size(obj.dataMat)) == 0 & obj.dataMat ~= 0);
            end
            minE = min(offDiagVals); maxE = max(offDiagVals);
            if isempty(minE), minE = 0; end
            if isempty(maxE), maxE = 0; end
            if isempty(minN), minN = 0; end
            if isempty(maxN), maxN = 0; end

            if ~isempty(obj.EdgeValueLim)
                maxE = obj.EdgeValueLim(2); minE = obj.EdgeValueLim(1);
            end
            if ~isempty(obj.NodeValueLim)
                maxN = obj.NodeValueLim(2); minN = obj.NodeValueLim(1);
            end

            if strcmpi(obj.GraphType, 'bi')
                MC = ones(100, 30, 3); meshT = repmat(linspace(0, 1, 30), [100, 1]);
                [row, col] = find((obj.dataMat ~= 0)); 
                % nzInd = find((obj.dataMat ~= 0));
                nzInd = sub2ind([nodeNum, nodeNum], row, col);
                switch obj.EdgeOrder
                    case 'none'
                    case 'ascend'
                        [~, tind] = sort(obj.dataMat(nzInd), 'ascend');
                        row = row(tind); col = col(tind);
                    case 'descend'
                        [~, tind] = sort(obj.dataMat(nzInd), 'descend');
                        row = row(tind); col = col(tind);
                end
                nzInd = nzInd(:).';
                obj.edgeMatHdl = gobjects(1, length(nzInd));

                for k = 1:length(row)
                    i = row(k); j = col(k);

                    % Map edge width from data value
                    if maxE == minE
                        edgeR = max(abs(obj.EdgeWidthLim));
                    else
                        if (~isempty(obj.EdgeValueLim))&&(obj.dataMat(i, j)>maxE)
                            edgeR = max(abs(obj.EdgeWidthLim));
                        elseif (~isempty(obj.EdgeValueLim))&&(obj.dataMat(i, j)<minE)
                            edgeR = min(abs(obj.EdgeWidthLim));
                        else
                            edgeR = (obj.dataMat(i, j) - minE) ./ (maxE - minE) .* abs(diff(obj.EdgeWidthLim)) + min(abs(obj.EdgeWidthLim));
                        end
                    end

                    if i == j
                        nodeTi = 2*pi * ((tGroup(i) - 1) * gSep + (i - 1) * nSep);
                        nodePiC = nodeNum * [cos(nodeTi), sin(nodeTi)];
                        [X_ring, Y_ring] = getEllipseRing(nodePiC(1), nodePiC(2), edgeR*nodeNum*2);

                        tind = i + (j - 1)*nodeNum == nzInd;
                        % Render edge based on RenderingMethod
                        switch lower(obj.RenderingMethod)
                            case 'simple'
                                % Uniform color edge patch
                                obj.edgeMatHdl(tind) = fill(obj.ax, X_ring, Y_ring, ...
                                    tmpColor(1, :), 'FaceAlpha', obj.EdgeAlpha, 'EdgeColor', 'none');
                            case 'map'
                                % Value-based color mapping
                                obj.edgeMatHdl(tind) = fill(obj.ax, X_ring, Y_ring, ...
                                    [0, 0, 0], 'FaceAlpha', obj.EdgeAlpha, 'EdgeColor', 'none', ...
                                    'FaceColor', 'flat', 'CData', obj.dataMat(i, j).*obj.signMat(i, j));
                            case {'interp', 'source','target'}
                                obj.edgeMatHdl(tind) = fill(obj.ax, X_ring, Y_ring, ...
                                    tmpColor(i, :), 'FaceAlpha', obj.EdgeAlpha, 'EdgeColor', 'none');
                        end
                    else
                        % Node angular positions
                        nodeTi = 2*pi * ((tGroup(i) - 1) * gSep + (i - 1) * nSep);
                        nodeTj = 2*pi * ((tGroup(j) - 1) * gSep + (j - 1) * nSep);

                        nodePiC = nodeNum * [cos(nodeTi), sin(nodeTi)];
                        nodePjC = nodeNum * [cos(nodeTj), sin(nodeTj)];
                        baseV = nodePjC - nodePiC;
                        baseTheta = atan(obj.Curvature*1.4);
                        bezierV = [baseV(1)*cos(baseTheta) + baseV(2)*sin(baseTheta), baseV(2)*cos(baseTheta) - baseV(1)*sin(baseTheta)];
                        bezierV = bezierV./2./abs(cos(baseTheta));
                        midPijC = nodePiC + bezierV;
                        % scatter(midPijC(1,1),midPijC(1,2),20,tmpColor(i, :),'filled')

                        PiC2 = ((1/99) - 1)^2.*nodePiC - 2*(1/99)*((1/99) - 1).*midPijC + (1/99)^2.*nodePjC;
                        PjC2 = ((98/99) - 1)^2.*nodePiC - 2*(98/99)*((98/99) - 1).*midPijC + (98/99)^2.*nodePjC;

                        Ri = rotmatUV([0, 0] - nodePiC, PiC2 - nodePiC);
                        Rj = rotmatUV([0, 0] - nodePjC, PjC2 - nodePjC);
                        %
                        % thetaC = 2 * asin(edgeR / 2);
                        % % Edge boundary points
                        % nodePiA = nodeNum * [cos(nodeTi + thetaC), sin(nodeTi + thetaC)];
                        % nodePiB = nodeNum * [cos(nodeTi - thetaC), sin(nodeTi - thetaC)];
                        % nodePjA = nodeNum * [cos(nodeTj - thetaC), sin(nodeTj - thetaC)];
                        % nodePjB = nodeNum * [cos(nodeTj + thetaC), sin(nodeTj + thetaC)];

                        RVi = [nodePiC(1)*cos(pi/2) + nodePiC(2)*sin(pi/2), nodePiC(2)*cos(pi/2) - nodePiC(1)*sin(pi/2)].*edgeR;
                        RVj = [nodePjC(1)*cos(pi/2) + nodePjC(2)*sin(pi/2), nodePjC(2)*cos(pi/2) - nodePjC(1)*sin(pi/2)].*edgeR;
                        nodePiA = nodePiC - RVi;
                        nodePiB = nodePiC + RVi;
                        nodePjA = nodePjC + RVj;
                        nodePjB = nodePjC - RVj;

                        nodePiA = (nodePiA - nodePiC)*(Ri') + nodePiC;
                        nodePiB = (nodePiB - nodePiC)*(Ri') + nodePiC;
                        nodePjA = (nodePjA - nodePjC)*(Rj') + nodePjC;
                        nodePjB = (nodePjB - nodePjC)*(Rj') + nodePjC;

                        % Control points for Bezier curves (inward offset based on Curvature)
                        midPijA = (nodePiA + nodePjA) ./ 2 .* (1 - abs(obj.Curvature)) + abs(obj.Curvature).*midPijC;
                        midPijB = (nodePiB + nodePjB) ./ 2 .* (1 - abs(obj.Curvature)) + abs(obj.Curvature).*midPijC;

                        % Generate Bezier curves for edge boundaries
                        lineA = bezierCurve([nodePiA; midPijA; nodePjA], 100);
                        lineB = bezierCurve([nodePjB; midPijB; nodePiB], 100);
                        tind = i + (j - 1)*nodeNum == nzInd;
                        % Render edge based on RenderingMethod
                        switch lower(obj.RenderingMethod)
                            case 'simple'
                                % Uniform color edge patch
                                obj.edgeMatHdl(tind) = fill(obj.ax, ...
                                    [lineA(:, 1); lineB(:, 1)]', ...
                                    [lineA(:, 2); lineB(:, 2)]', ...
                                    tmpColor(1, :), 'FaceAlpha', obj.EdgeAlpha, 'EdgeColor', 'none');
                            case 'map'
                                % Value-based color mapping
                                obj.edgeMatHdl(tind) = fill(obj.ax, ...
                                    [lineA(:, 1); lineB(:, 1)]', ...
                                    [lineA(:, 2); lineB(:, 2)]', ...
                                    [0, 0, 0], 'FaceAlpha', obj.EdgeAlpha, 'EdgeColor', 'none', ...
                                    'FaceColor', 'flat', 'CData', obj.dataMat(i, j));
                            case 'interp'
                                meshX = (repmat(lineB(end:-1:1, 1), [1, 30]) - repmat(lineA(:, 1), [1, 30])) .* meshT + repmat(lineA(:, 1), [1, 30]);
                                meshY = (repmat(lineB(end:-1:1, 2), [1, 30]) - repmat(lineA(:, 2), [1, 30])) .* meshT + repmat(lineA(:, 2), [1, 30]);

                                % Color interpolation for edges (from node i to node j)
                                tCi = tmpColor(mod(i - 1, size(tmpColor, 1)) + 1, :);
                                tCj = tmpColor(mod(j - 1, size(tmpColor, 1)) + 1, :);
                                MC(:, :, 1) = repmat(linspace(tCi(1), tCj(1), 100)', [1, 30]);
                                MC(:, :, 2) = repmat(linspace(tCi(2), tCj(2), 100)', [1, 30]);
                                MC(:, :, 3) = repmat(linspace(tCi(3), tCj(3), 100)', [1, 30]);

                                % Smooth gradient interpolated edge
                                obj.edgeMatHdl(tind) = surf(obj.ax, ...
                                    meshX, meshY, meshX .* 0, 'CData', MC, ...
                                    'EdgeColor', 'none', 'FaceAlpha', obj.EdgeAlpha);
                            case 'source'
                                obj.edgeMatHdl(tind) = fill(obj.ax, ...
                                    [lineA(:, 1); lineB(:, 1)]', ...
                                    [lineA(:, 2); lineB(:, 2)]', ...
                                    tmpColor(i, :), 'FaceAlpha', obj.EdgeAlpha, 'EdgeColor', 'none');
                            case 'target'
                                obj.edgeMatHdl(tind) = fill(obj.ax, ...
                                    [lineA(:, 1); lineB(:, 1)]', ...
                                    [lineA(:, 2); lineB(:, 2)]', ...
                                    tmpColor(j, :), 'FaceAlpha', obj.EdgeAlpha, 'EdgeColor', 'none');

                        end
                    end
                end
            else
                % obj.edgeMatHdl = gobjects(nodeNum, nodeNum);
                MC = ones(100, 30, 3); meshT = repmat(linspace(0, 1, 30), [100, 1]);
                [row, col] = find((obj.dataMat ~= 0) & ~eye(nodeNum));
                % nzInd = find((obj.dataMat ~= 0) & ~eye(nodeNum));
                nzInd = sub2ind([nodeNum, nodeNum], row, col);
                switch obj.EdgeOrder
                    case 'none'
                    case 'ascend'
                        [~, tind] = sort(obj.dataMat(nzInd), 'ascend');
                        row = row(tind); col = col(tind);
                    case 'descend'
                        [~, tind] = sort(obj.dataMat(nzInd), 'descend');
                        row = row(tind); col = col(tind);
                end
                nzInd = nzInd(:).';
                obj.edgeMatHdl = gobjects(1, length(nzInd));
                % Draw edges (upper triangular only)
                for k = 1:length(row)
                    i = row(k); j = col(k);

                    % Map edge width from data value
                    if maxE == minE
                        edgeR = max(abs(obj.EdgeWidthLim));
                    else
                        if (~isempty(obj.EdgeValueLim))&&(obj.dataMat(i, j)>maxE)
                            edgeR = max(abs(obj.EdgeWidthLim));
                        elseif (~isempty(obj.EdgeValueLim))&&(obj.dataMat(i, j)<minE)
                            edgeR = min(abs(obj.EdgeWidthLim));
                        else
                            edgeR = (obj.dataMat(i, j) - minE) ./ (maxE - minE) .* abs(diff(obj.EdgeWidthLim)) + min(abs(obj.EdgeWidthLim));
                        end
                    end

                    % Node angular positions
                    nodeTi = 2*pi * ((tGroup(i) - 1) * gSep + (i - 1) * nSep);
                    nodeTj = 2*pi * ((tGroup(j) - 1) * gSep + (j - 1) * nSep);

                    nodePiC = nodeNum * [cos(nodeTi), sin(nodeTi)];
                    nodePjC = nodeNum * [cos(nodeTj), sin(nodeTj)];
                    midPijC = (nodePiC + nodePjC) ./ 2 .* (1 - abs(obj.Curvature));

                    PiC2 = ((1/99) - 1)^2.*nodePiC - 2*(1/99)*((1/99) - 1).*midPijC + (1/99)^2.*nodePjC;
                    PjC2 = ((98/99) - 1)^2.*nodePiC - 2*(98/99)*((98/99) - 1).*midPijC + (98/99)^2.*nodePjC;

                    Ri = rotmatUV([0, 0] - nodePiC, PiC2 - nodePiC);
                    Rj = rotmatUV([0, 0] - nodePjC, PjC2 - nodePjC);

                    thetaC = 2 * asin(edgeR / 2);
                    % Edge boundary points
                    nodePiA = nodeNum * [cos(nodeTi + thetaC), sin(nodeTi + thetaC)];
                    nodePiB = nodeNum * [cos(nodeTi - thetaC), sin(nodeTi - thetaC)];
                    nodePjA = nodeNum * [cos(nodeTj - thetaC), sin(nodeTj - thetaC)];
                    nodePjB = nodeNum * [cos(nodeTj + thetaC), sin(nodeTj + thetaC)];

                    % RVi = [nodePiC(1)*cos(pi/2) + nodePiC(2)*sin(pi/2), nodePiC(2)*cos(pi/2) - nodePiC(1)*sin(pi/2)].*edgeR;
                    % RVj = [nodePjC(1)*cos(pi/2) + nodePjC(2)*sin(pi/2), nodePjC(2)*cos(pi/2) - nodePjC(1)*sin(pi/2)].*edgeR;
                    % nodePiA = nodePiC - RVi;
                    % nodePiB = nodePiC + RVi;
                    % nodePjA = nodePjC + RVj;
                    % nodePjB = nodePjC - RVj;

                    nodePiA = (nodePiA - nodePiC)*(Ri') + nodePiC;
                    nodePiB = (nodePiB - nodePiC)*(Ri') + nodePiC;
                    nodePjA = (nodePjA - nodePjC)*(Rj') + nodePjC;
                    nodePjB = (nodePjB - nodePjC)*(Rj') + nodePjC;

                    % Control points for Bezier curves (inward offset based on Curvature)
                    midPijA = (nodePiA + nodePjA) ./ 2 .* (1 - abs(obj.Curvature));
                    midPijB = (nodePiB + nodePjB) ./ 2 .* (1 - abs(obj.Curvature));
                    % midPijA = (nodePiA + nodePjA) ./ 2 + midPijC - (nodePiC + nodePjC) ./ 2;
                    % midPijB = (nodePiB + nodePjB) ./ 2 + midPijC - (nodePiC + nodePjC) ./ 2;

                    % Generate Bezier curves for edge boundaries
                    lineA = bezierCurve([nodePiA; midPijA; nodePjA], 100);
                    lineB = bezierCurve([nodePjB; midPijB; nodePiB], 100);

                    tind = i + (j - 1)*nodeNum == nzInd;
                    % Render edge based on RenderingMethod
                    switch lower(obj.RenderingMethod)
                        case 'simple'
                            % Uniform color edge patch
                            obj.edgeMatHdl(tind) = fill(obj.ax, ...
                                [lineA(:, 1); lineB(:, 1)]', ...
                                [lineA(:, 2); lineB(:, 2)]', ...
                                tmpColor(1, :), 'FaceAlpha', obj.EdgeAlpha, 'EdgeColor', 'none');
                        case 'map'
                            % Value-based color mapping
                            obj.edgeMatHdl(tind) = fill(obj.ax, ...
                                [lineA(:, 1); lineB(:, 1)]', ...
                                [lineA(:, 2); lineB(:, 2)]', ...
                                [0, 0, 0], 'FaceAlpha', obj.EdgeAlpha, 'EdgeColor', 'none', ...
                                'FaceColor', 'flat', 'CData', obj.dataMat(i, j).*obj.signMat(i, j));
                        case {'interp', 'source', 'target'}
                            meshX = (repmat(lineB(end:-1:1, 1), [1, 30]) - repmat(lineA(:, 1), [1, 30])) .* meshT + repmat(lineA(:, 1), [1, 30]);
                            meshY = (repmat(lineB(end:-1:1, 2), [1, 30]) - repmat(lineA(:, 2), [1, 30])) .* meshT + repmat(lineA(:, 2), [1, 30]);

                            % Color interpolation for edges (from node i to node j)
                            tCi = tmpColor(mod(i - 1, size(tmpColor, 1)) + 1, :);
                            tCj = tmpColor(mod(j - 1, size(tmpColor, 1)) + 1, :);
                            MC(:, :, 1) = repmat(linspace(tCi(1), tCj(1), 100)', [1, 30]);
                            MC(:, :, 2) = repmat(linspace(tCi(2), tCj(2), 100)', [1, 30]);
                            MC(:, :, 3) = repmat(linspace(tCi(3), tCj(3), 100)', [1, 30]);

                            % Smooth gradient interpolated edge
                            obj.edgeMatHdl(tind) = surf(obj.ax, ...
                                meshX, meshY, meshX .* 0, 'CData', MC, ...
                                'EdgeColor', 'none', 'FaceAlpha', obj.EdgeAlpha);
                    end
                end
            end

            obj.nodeHdl = gobjects(1, nodeNum);
            obj.labelHdl = gobjects(1, nodeNum);
            % Draw nodes
            for i = 1:nodeNum
                nodeTheta = 2*pi * ((tGroup(i) - 1) * gSep + (i - 1) * nSep);
                obj.nodeThetaSet(i) = nodeTheta;
                
                % Map node size from diagonal value
                if maxN == minN
                    nodeR = 0 * (obj.NodeValue(i) == 0) + max(abs(obj.NodeSizeLim)) * (obj.NodeValue(i) > 0);
                else
                    if (~isempty(obj.NodeValueLim))&&(obj.NodeValue(i) > maxN)&&(obj.NodeValue(i) ~= 0)
                        nodeR = max(abs(obj.NodeSizeLim));
                    elseif (~isempty(obj.NodeValueLim))&&(obj.NodeValue(i) < minN)&&(obj.NodeValue(i) ~= 0)
                        nodeR = min(abs(obj.NodeSizeLim));
                    else
                        nodeR = 0 * (obj.NodeValue(i) == 0) + ...
                            ((obj.NodeValue(i) - minN) ./ (maxN - minN) .* abs(diff(obj.NodeSizeLim)) + ...
                            min(abs(obj.NodeSizeLim))) * (obj.NodeValue(i) > 0);
                    end
                end
                
                % Node polygon vertices
                nodeX = nodeNum * cos(nodeTheta) + nodeNum * nodeR * cos(tt);
                nodeY = nodeNum * sin(nodeTheta) + nodeNum * nodeR * sin(tt);
                
                obj.nodeHdl(i) = fill(obj.ax, nodeX, nodeY, ...
                    obj.NodeColor(mod(i - 1, size(obj.NodeColor, 1)) + 1, :), ...
                    'EdgeColor', 'none', 'FaceAlpha', obj.NodeAlpha);
                
                % Draw node label with appropriate rotation
                if nodeTheta >= 0 && nodeTheta <= pi
                    obj.labelHdl(i) = text(obj.ax, ...
                        1.05 .* nodeNum .* (1 + max(obj.NodeSizeLim)) .* cos(nodeTheta), ...
                        1.05 .* nodeNum .* (1 + max(obj.NodeSizeLim)) .* sin(nodeTheta), ...
                        obj.NodeName{i}, 'FontSize', 17, 'FontName', 'Times New Roman', ...
                        'Rotation', nodeTheta/pi*180 + 270, 'HorizontalAlignment', 'center', ...
                        'VerticalAlignment', 'bottom');
                else
                    obj.labelHdl(i) = text(obj.ax, ...
                        1.05 .* nodeNum .* (1 + max(obj.NodeSizeLim)) .* cos(nodeTheta), ...
                        1.05 .* nodeNum .* (1 + max(obj.NodeSizeLim)) .* sin(nodeTheta), ...
                        obj.NodeName{i}, 'FontSize', 17, 'FontName', 'Times New Roman', ...
                        'Rotation', nodeTheta/pi*180 + 90, 'HorizontalAlignment', 'center', ...
                        'VerticalAlignment', 'cap');
                end
            end


            % Draw group labels if provided
            if ~isempty(obj.GroupName)
                obj.groupLabelHdl = gobjects(1, groupNum);
                for i = 1:groupNum
                    % Circular mean of node angles within group
                    nodeTheta = circMeanTheta(obj.nodeThetaSet(i == tGroup));
                    
                    if nodeTheta >= 0 && nodeTheta <= pi
                        obj.groupLabelHdl(i) = text(obj.ax, ...
                            obj.GroupLabelRadius .* nodeNum .* (1 + max(obj.NodeSizeLim)) .* cos(nodeTheta), ...
                            obj.GroupLabelRadius .* nodeNum .* (1 + max(obj.NodeSizeLim)) .* sin(nodeTheta), ...
                            obj.GroupName{i}, 'FontSize', 17, 'FontName', 'Times New Roman', ...
                            'Rotation', nodeTheta/pi*180 + 270, 'HorizontalAlignment', 'center', ...
                            'VerticalAlignment', 'bottom');
                    else
                        obj.groupLabelHdl(i) = text(obj.ax, ...
                            obj.GroupLabelRadius .* nodeNum .* (1 + max(obj.NodeSizeLim)) .* cos(nodeTheta), ...
                            obj.GroupLabelRadius .* nodeNum .* (1 + max(obj.NodeSizeLim)) .* sin(nodeTheta), ...
                            obj.GroupName{i}, 'FontSize', 17, 'FontName', 'Times New Roman', ...
                            'Rotation', nodeTheta/pi*180 + 90, 'HorizontalAlignment', 'center', ...
                            'VerticalAlignment', 'cap');
                    end
                end
            end

            % Nested helper functions
            function pnts = bezierCurve(pnts, N)
                t = linspace(0, 1, N);
                p = size(pnts, 1) - 1;
                coe1 = factorial(p) ./ factorial(0:p) ./ factorial(p:-1:0);
                coe2 = ((t) .^ ((0:p)')) .* ((1 - t) .^ ((p:-1:0)'));
                pnts = (pnts' * (coe1' .* coe2))';
            end

            function R = rotmatUV(u, v)
                u = u(:); v = v(:);
                u = u / norm(u);
                v = v / norm(v);
                angle_u = atan2(u(2), u(1));
                angle_v = atan2(v(2), v(1));
                theta = angle_v - angle_u;
                R = [cos(theta), -sin(theta);
                    sin(theta),  cos(theta)];
            end
            
            function group_id = groupConsecutive(arr)
                if isempty(arr)
                    group_id = [];
                    return;
                end
                group_id = ones(size(arr));
                current_group = 1;
                for idx = 2:length(arr)
                    if arr(idx) ~= arr(idx - 1)
                        current_group = current_group + 1;
                    end
                    group_id(idx) = current_group;
                end
            end
            
            function thetaMean = circMeanTheta(theta)
                x = mean(cos(theta));
                y = mean(sin(theta));
                thetaMean = atan2(y, x);
                thetaMean = mod(thetaMean, 2*pi);
            end
            function [X_ring, Y_ring] = getEllipseRing(x, y, w)
                C = [x*1.15, y*1.15];
                r = [x, y] - C;
                R = norm(r);
                u = r / R;
                v = [-u(2), u(1)];
                R_inner = R - w/2;
                R_outer = R + w/2;
                theta = linspace(0, 2*pi, 100);
                s = [sin(linspace(pi*.1, pi*.5, 50)), sin(linspace(pi*.5, pi*.1, 50))];

                X_outer = C(1) + R_outer * cos(theta) * u(1) + R_outer .* s.* sin(theta) * v(1);
                Y_outer = C(2) + R_outer * cos(theta) * u(2) + R_outer .* s.* sin(theta) * v(2);
                X_inner = C(1) + R_inner * cos(theta) * u(1) + R_inner .* s.* sin(theta) * v(1);
                Y_inner = C(2) + R_inner * cos(theta) * u(2) + R_inner .* s.* sin(theta) * v(2);
                X_ring = [X_outer, fliplr(X_inner)];
                Y_ring = [Y_outer, fliplr(Y_inner)];
            end
            if nargout == 1
                varargout{1} = obj;
            end
        end
        
        function labelRotate(obj, Rotate)
            % labelRotate: Set label rotation mode
            %   'off': Labels point radially outward from center
            %   'on':  Labels follow the circular orientation
            obj.LabelRotate = Rotate;
            switch lower(obj.LabelRotate)
                case 'off'
                    for i = 1:size(obj.dataMat, 2)
                        nodeTheta = obj.nodeThetaSet(i);
                        if nodeTheta >= 0 && nodeTheta <= pi
                            set(obj.labelHdl(i), 'Rotation', nodeTheta/pi*180 + 270, ...
                                'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
                        else
                            set(obj.labelHdl(i), 'Rotation', nodeTheta/pi*180 + 90, ...
                                'HorizontalAlignment', 'center', 'VerticalAlignment', 'cap');
                        end
                    end
                case 'on'
                    for i = 1:size(obj.dataMat, 2)
                        nodeTheta = obj.nodeThetaSet(i);
                        if nodeTheta <= 0.5*pi || nodeTheta >= 1.5*pi
                            set(obj.labelHdl(i), 'Rotation', nodeTheta/pi*180, ...
                                'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle');
                        else
                            set(obj.labelHdl(i), 'Rotation', nodeTheta/pi*180 + 180, ...
                                'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle');
                        end
                    end
            end
        end
        
% =========================================================================
% Label customization functions
% =========================================================================
        function setLabelN(obj, n, varargin)
            % setLabelN: Set properties for a single node label
            set(obj.labelHdl(n), varargin{:})
        end
        
        function setLabel(obj, varargin)
            % setLabel: Set properties for all node labels
            for n = 1:length(obj.labelHdl)
                set(obj.labelHdl(n), varargin{:})
            end
        end
        
        function setGroupLabelN(obj, n, varargin)
            % setGroupLabelN: Set properties for a single group label
            set(obj.groupLabelHdl(n), varargin{:})
        end
        
        function setGroupLabel(obj, varargin)
            % setGroupLabel: Set properties for all group labels
            for n = 1:length(obj.groupLabelHdl)
                set(obj.groupLabelHdl(n), varargin{:})
            end
        end
% =========================================================================
% Set node color by colormap
% =========================================================================
        function cbar = setNodeColorByColormap(obj, cmp)
            minN = min(obj.NodeValue(obj.NodeValue ~= 0));
            maxN = max(obj.NodeValue(obj.NodeValue ~= 0));
            if ~isempty(obj.NodeValueLim)
                maxN = obj.NodeValueLim(2); minN = obj.NodeValueLim(1);
            end
            climit = [minN, maxN];
            cmap   = cmp;

            values = linspace(climit(1), climit(2), size(cmap, 1) + 1);

            for i = 1:length(obj.NodeValue)
                % Find which color bin the value falls into (确定数值落在哪个颜色分箱)
                tind = sum(obj.NodeValue(i) >= values);
                tind(tind <= 0) = 1;
                tind(tind > size(cmap, 1)) = size(cmap, 1);
                % Apply the fixed color (应用固定颜色)
                set(obj.nodeHdl(i), 'FaceColor', cmap(tind, :));
            end

            cbar = colorbar(obj.ax);
            cbar.Colormap = cmap;
            cbar.Limits   = climit;
        end
    end     
end


% =========================================================================
% Zhaoxu Liu / slandarer (2026). circular network chart 
% (https://www.mathworks.com/matlabcentral/fileexchange/118655-circular-network-chart), 
% MATLAB Central File Exchange. Retrieved April 25, 2026.
% =========================================================================