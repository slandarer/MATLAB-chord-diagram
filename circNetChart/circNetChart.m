classdef circNetChart < handle
% circNetChart: Circular network chart visualization
%   Creates a circular layout network with customizable nodes and edges.
%   Supports multiple rendering methods, group layout, and curvature control.
% =========================================================================
% Basic usage
% -------------------------------------------------------------------------
% Data = triu(randi([1, 5], [6, 6]));
% CN = circNetChart(Data);
% CN = CN.draw();
% =========================================================================
% Zhaoxu Liu / slandarer (2026). circular network chart 
% (https://www.mathworks.com/matlabcentral/fileexchange/118655-circular-network-chart), 
% MATLAB Central File Exchange. Retrieved April 25, 2026.

    properties
        ax
        arginList = {'RenderingMethod', 'NodeSizeLim', 'EdgeWidthLim', ...
                     'NodeColor', 'EdgeColor', 'Group', 'GroupSep', 'LabelRotate',...
                     'NodeName', 'Curvature', 'GroupName'} 

        
        Curvature = 0.5;            % Edge curvature: 0 = straight line, 1 = full Bezier curve
        dataMat                     % Input adjacency matrix

        % Rendering method: 'simple' (uniform), 'interp' (gradient), 'map' (value-based)
        RenderingMethod = 'simple'

        NodeName = {}               % Node labels
        LabelRotate = 'off'         % Weather to rotate labels

        Group = []                  % Group assignment for each node
        GroupName = {};             % Group labels
        GroupSep = 1/32             % Total gap fraction between groups (0-0.5)
        GroupLabelRadius = 1.3;     % Radius for group labels

        % Node and edge size limits [min, max] mapped from data values
        NodeSizeLim  = [0.05, 0.1]
        EdgeWidthLim = [0.02, 0.05]
        
        NodeColor = [0.4, 0.4, 0.4]   % Node color
        EdgeColor = 'flat'            % Edge color
        NodeAlpha = 1                 % Node alpha
        EdgeAlpha = 0.3               % Edge alpha
        
        nodeThetaSet                  
        edgeMatHdl                    % Handles for edges
        nodeHdl                       % Handles for nodes
        labelHdl                      % Handles for node labels
        groupLabelHdl                 % Handles for group labels
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
            obj.dataMat = abs(varargin{1});
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
        end

        function obj = draw(obj)
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
            tt = linspace(0, 2*pi, 100);                        

            % Find min/max values for scaling node radii and edge widths
            diagVals = obj.dataMat(eye(size(obj.dataMat)) == 1 & obj.dataMat ~= 0);
            minN = min(diagVals); maxN = max(diagVals);
            offDiagVals = obj.dataMat(eye(size(obj.dataMat)) == 0 & obj.dataMat ~= 0);
            minE = min(offDiagVals); maxE = max(offDiagVals);
            if isempty(minE), minE = 0; end
            if isempty(maxE), maxE = 0; end
            if isempty(minN), minN = 0; end
            if isempty(maxN), maxN = 0; end

            % Draw edges (upper triangular only)
            for i = 1:nodeNum
                for j = (i + 1):nodeNum
                    % Skip if data is sparse and entry is zero
                    if nodeNum < 30 || obj.dataMat(i, j) ~= 0
                    
                    % Map edge width from data value
                    if maxE == minE
                        edgeR = 0 * (obj.dataMat(i, j) == 0) + max(abs(obj.EdgeWidthLim)) * (obj.dataMat(i, j) > 0);
                    else
                        edgeR = 0 * (obj.dataMat(i, j) == 0) + ...
                                ((obj.dataMat(i, j) - minE) ./ (maxE - minE) .* abs(diff(obj.EdgeWidthLim)) + min(abs(obj.EdgeWidthLim))) * (obj.dataMat(i, j) > 0);
                    end
                    
                    % Node angular positions
                    nodeTi = 2*pi * ((tGroup(i) - 1) * gSep + (i - 1) * nSep);
                    nodeTj = 2*pi * ((tGroup(j) - 1) * gSep + (j - 1) * nSep);
                    thetaC = 2 * asin(edgeR / 2);
                    
                    % Edge boundary points
                    nodePiA = nodeNum * [cos(nodeTi + thetaC), sin(nodeTi + thetaC)];
                    nodePiB = nodeNum * [cos(nodeTi - thetaC), sin(nodeTi - thetaC)];
                    nodePjA = nodeNum * [cos(nodeTj - thetaC), sin(nodeTj - thetaC)];
                    nodePjB = nodeNum * [cos(nodeTj + thetaC), sin(nodeTj + thetaC)];
                    
                    % Control points for Bezier curves (inward offset based on Curvature)
                    midPijA = (nodePiA + nodePjA) ./ 2 .* (1 - obj.Curvature);
                    midPijB = (nodePiB + nodePjB) ./ 2 .* (1 - obj.Curvature);
                    
                    % Generate Bezier curves for edge boundaries
                    lineA = bezierCurve([nodePiA; midPijA; nodePjA], 100);
                    lineB = bezierCurve([nodePjB; midPijB; nodePiB], 100);
                    
                    % Arc sections at node ends
                    lineI = [cos(linspace(nodeTi - thetaC, nodeTi + thetaC, 30));
                             sin(linspace(nodeTi - thetaC, nodeTi + thetaC, 30))]' .* nodeNum;
                    lineJ = [cos(linspace(nodeTj - thetaC, nodeTj + thetaC, 30));
                             sin(linspace(nodeTj - thetaC, nodeTj + thetaC, 30))]' .* nodeNum;
                    
                    % Mesh for interpolated rendering
                    meshT = repmat(linspace(0, 1, 30), [100, 1]);
                    meshX = [lineI(end:-1:1, 1)'; 
                             (repmat(lineB(end:-1:1, 1), [1, 30]) - repmat(lineA(:, 1), [1, 30])) .* meshT + repmat(lineA(:, 1), [1, 30]); 
                             lineJ(:, 1)'];
                    meshY = [lineI(end:-1:1, 2)'; 
                             (repmat(lineB(end:-1:1, 2), [1, 30]) - repmat(lineA(:, 2), [1, 30])) .* meshT + repmat(lineA(:, 2), [1, 30]); 
                             lineJ(:, 2)'];

                    % Color interpolation for edges (from node i to node j)
                    MC = ones(102, 30, 3);
                    tCi = tmpColor(mod(i - 1, size(tmpColor, 1)) + 1, :);
                    tCj = tmpColor(mod(j - 1, size(tmpColor, 1)) + 1, :);
                    MC(:, :, 1) = repmat(linspace(tCi(1), tCj(1), 102)', [1, 30]);
                    MC(:, :, 2) = repmat(linspace(tCi(2), tCj(2), 102)', [1, 30]);
                    MC(:, :, 3) = repmat(linspace(tCi(3), tCj(3), 102)', [1, 30]);

                    % Render edge based on RenderingMethod
                    switch lower(obj.RenderingMethod)
                        case 'simple'
                            % Uniform color edge patch
                            obj.edgeMatHdl(i, j) = fill(obj.ax, ...
                                [lineA(:, 1); lineJ(:, 1); lineB(:, 1); lineI(:, 1)]', ...
                                [lineA(:, 2); lineJ(:, 2); lineB(:, 2); lineI(:, 2)]', ...
                                tmpColor(1, :), 'FaceAlpha', obj.EdgeAlpha, 'EdgeColor', 'none');
                        case 'map'
                            % Value-based color mapping
                            obj.edgeMatHdl(i, j) = fill(obj.ax, ...
                                [lineA(:, 1); lineJ(:, 1); lineB(:, 1); lineI(:, 1)]', ...
                                [lineA(:, 2); lineJ(:, 2); lineB(:, 2); lineI(:, 2)]', ...
                                [0, 0, 0], 'FaceAlpha', obj.EdgeAlpha, 'EdgeColor', 'none', ...
                                'FaceColor', 'flat', 'CData', obj.dataMat(i, j));
                        case 'interp'
                            % Smooth gradient interpolated edge
                            obj.edgeMatHdl(i, j) = surf(obj.ax, ...
                                meshX, meshY, meshX .* 0, 'CData', MC, ...
                                'EdgeColor', 'none', 'FaceAlpha', obj.EdgeAlpha);
                    end
                    end
                end
            end

            % Draw nodes
            for i = 1:nodeNum
                nodeTheta = 2*pi * ((tGroup(i) - 1) * gSep + (i - 1) * nSep);
                obj.nodeThetaSet(i) = nodeTheta;
                
                % Map node size from diagonal value
                if maxN == minN
                    nodeR = 0 * (obj.dataMat(i, i) == 0) + max(abs(obj.NodeSizeLim)) * (obj.dataMat(i, i) > 0);
                else
                    nodeR = 0 * (obj.dataMat(i, i) == 0) + ...
                            ((obj.dataMat(i, i) - minN) ./ (maxN - minN) .* abs(diff(obj.NodeSizeLim)) + min(abs(obj.NodeSizeLim))) * (obj.dataMat(i, i) > 0);
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
        
        % =================================================================
        % Label customization functions
        % =================================================================
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
    end
end