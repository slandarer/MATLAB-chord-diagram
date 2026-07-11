classdef biChordChart < handle
% biChordChart Create and customize bidirectional chord diagrams (有向弦图)
%   BCC = biChordChart(dataMat); creates a bidirectional chord diagram from
%   a square numerical matrix where element (i, j) represents flow from i to j.
%   从方阵数值矩阵创建有向弦图，元素 (i, j) 表示从 i 到 j 的流量。
%
%   BCC = biChordChart(dataMat, 'Label', label); specifies labels for the nodes.
%   指定节点标签。
%
%   BCC = biChordChart(ax, ___); creates a bidirectional chord diagram in
%   the specified axes.
%   在特定坐标区域生成有向弦图对象。
%
%   BCC = biChordChart(___, propName, propVal); specifies property name-value
%   pairs when creating the bidirectional chord diagram object.
%   创建有向弦图对象时为其设置属性。
%   
%   BCC.propName = propVal; sets properties for the bidirectional chord diagram
%   object after creation, before rendering.
%   创建有向弦图对象后，绘图前为其设置属性。
%
%   BCC = BCC.draw(); renders the bidirectional chord diagram.
%   渲染有向弦图对象。
%
% Note:
%   Unlike chordChart which has separate bottom and top blocks, biChordChart
%   arranges all nodes in a full circle, with chords flowing in both directions
%   between nodes. The element dataMat(i, j) represents the flow from node i to
%   node j, which determines the width of the chord on the source side.
%   The 'Arrow' property turns the chord ends into sharp corners to indicate
%   the flow direction.
%   与 chordChart 不同（分上下方块），biChordChart 将所有节点排列在完整圆周上，
%   节点之间的弦可双向流动。dataMat(i, j) 表示从节点 i 到节点 j 的流量，
%   该数值决定源端弦的宽度。'Arrow' 属性可将弦的末端变成尖角以展示流向。
%
% Basic usage:
%   dataMat = randi([0,8], [6,6]);
%   BCC = biChordChart(dataMat, 'Arrow', 'on');
%   BCC = BCC.draw();
%
% Methods: (try: help biChordChart.setChord)
%   draw                   - Render the biChordChart object (渲染双向弦图对象)
%   labelRotate            - Label rotation control (标签旋转控制)
%   tickState              - Show/hide tick marks (显示/隐藏刻度线)
%   tickLabelState         - Show/hide tick labels (显示/隐藏刻度标签)
%   setLabelRadius         - Set label radius (设置标签半径)
%   setFont                - Label property settings (标签属性设置)
%   setFontColor           - Node label color settings (节点标签颜色设置)
%   setTick                - Tick line property settings (刻度线属性设置)
%   setTickFont            - Tick label property settings (刻度标签属性设置)
%   setTickLabelFormat     - Set custom format for tick labels (设置刻度标签的自定义格式)
%   setSquare              - Node square property settings (节点弧形块属性设置)
%   setSquareCData         - Set the 'CData' property of each square (设置方块的 CData 属性)
%   setSquareColor         - Set color for each square (弧形块颜色设置)
%   setSubSquareS          - Source sub‑square property settings (来源子方块属性设置)
%   setSubSquareT          - Target sub-square property settings (目标子方块属性设置)
%   setChord               - Chord property settings (弦属性设置)
%   setChordCData          - Set the 'CData' property of each chord patch (设置弦的 CData 属性)
%   setChordColorBySquareS - Color each chord using its source block color (根据来源方块颜色为弦着色)
%   setChordColorBySquareT - Color each chord using its target block color (根据目标方块颜色为弦着色)
%   addHighlightArrow      - Add highlight arrow indicator (添加高亮箭头指示器)


% =========================================================================
% Copyright (c) 2022-2026, Zhaoxu Liu / slandarer
% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer
% -------------------------------------------------------------------------
% Zhaoxu Liu / slandarer (2026). biChordChart (bidirectional chord diagram | 有向弦图) 
% (https://www.mathworks.com/matlabcentral/fileexchange/121043-bichordchart-bidirectional-chord-diagram), 
% MATLAB Central File Exchange. Retrieved April 14, 2026.
% =========================================================================


% =========================================================================
% Version History (版本更新)
% =========================================================================
% # version 1.1.0
%   + Added 'LRadius' property for adjustable label radius
%     (增添了可调节标签半径的属性)
%   + Added 'LRotate' property and labelRotate function
%     (增添了可调节标签旋转的属性)
%   + Added tickLabelState function to display tick labels
%     (可使用函数显示刻度标签)
% -------------------------------------------------------------------------
% # version 2.0.0
%   + Added two new tick marking methods (新增两种标志刻度的方法)
%     - 'value' : default (默认)
%     - 'auto'  : Automatically adjust overlapping tick labels (自动调整重叠刻度)
%     - 'linear': Draw evenly spaced tick marks (均匀绘制刻度线)
%   + Added linearTickCompactDegree and linearMinorTick properties
%     (线性刻度相关属性)
% -------------------------------------------------------------------------
% # version 3.0.0
%   + Added 'SSqRatio' property to adjust arc block/square ratio at chord ends
%     (可使用 SSqRatio 属性调整弦末端弧形块占比)
%   + Added 'OSqRatio' property to adjust original arc block/square ratio
%     (新增 OSqRatio 属性)
%   + Added 'Rotation' property for global diagram rotation
%     (新增 Rotation 属性)
% -------------------------------------------------------------------------
% # version 4.0.0
%   + Left-click to add data tooltip, right-click to hide highlight
%     (左键添加数据提示框，右键隐藏高亮)
% -------------------------------------------------------------------------
% # version 4.1.0
%   + Added addHighlightArrow function to add arrow indicators (添加提示箭头)
%   + Nodes are groupable (节点可分组)
% -------------------------------------------------------------------------
% # version 5.0.0
%   + Added 'TickRadius' property to control tick radius
%     (新增 TickRadius 属性)
%   + Added 'SquareRadius' property to control the 
%     inner and outer radius of the arc block/square
%     (新增 SquareRadius 属性)
%   + Property shorthands (属性简写)
%     TRadius    % TickRadius       - Tick mark radius / 刻度线半径
%     SRadius    % SquareRadius     - Arc block radial range [inner, outer] / 弧块径向范围
%     LRadius    % LabelRadius      - Category label radius / 分类标签半径
%     LRotate    % LabelRotate      - Label rotation mode / 标签是否旋转
%     SSqRatio   % SubSquareRatio   - Subordinate square size ratio / 从属方块大小比例
%     OSqRatio   % OriSquareRatio   - Origin square size ratio / 起点方块大小比例
% -------------------------------------------------------------------------
% # version 6.0.0
%   + Optimized variable and graphics object name display, 
%     significantly improving plotting speed for large-scale matrix
% -------------------------------------------------------------------------
% # version 7.0.0
%   + Replace 'F' with 'S' (Source replaces From-side).
%     squareFMatHdl -> squareSMatHdl, for example
%     (Variable names previously associated with 'F' remain available.)
%   + The setChord method replaces setChordProp and setChordMN.
%     setChord(___)          | Set properties for all chord
%     setChord(m, n, ___)    | Set the properties for the chord which
%                              connect m-th and n-th nodes
%   + The setSquare method replaces setSquareProp and setSquareN.
%     setSquare(___)         | Set properties for all square
%     setSquare(n, ___)      | Set the properties for the n-th square
%   + The setSubSquareS method replaces setEachSquareF_Prop.
%   + The setSubSquareT method replaces setEachSquareT_Prop.
% -------------------------------------------------------------------------
% # version 7.1.0
%   + Added setChordCData method to set the 'CData' property of each chord patch (设置弦的 CData 属性) 
%   + Added setSquareCData method to set the 'CData' property of each square (设置方块的 CData 属性) 
%   + Added setSquareColor, setChordColorBySquareS, setChordColorBySquareT methods
%   + For methods: Added support for logical matrix inputs.

    properties
        ax                                                     % Axes handle (坐标区句柄)
       
        arginList = {'Label','Sep','Group','GroupSep','Arrow','CData','Rotation','TickMode',...
                     'TRadius' , 'TickRadius', ...
                     'SRadius' , 'SquareRadius', ...
                     'LRadius' , 'LabelRadius', ...
                     'LRotate' , 'LabelRotate', ...
                     'SSqRatio', 'SubSquareRatio', ...
                     'OSqRatio', 'OriSquareRatio'}  % Name-value pair list (名称-值对参数列表)  
        
        dataMat                                                % Numerical matrix (数值矩阵)
        Label = {}                                             % Node labels (节点标签)

        Sep      = 1/10                                        % Separation between square nodes (弧形块间隙)
        CData    = [127, 91, 93; 187,128,110; 197,173,143;
                     59, 71,111; 104, 95,126;  76,103, 86;
                    112,112,124;  72, 39, 24; 197,119,106;
                    160,126, 88; 238,208,146]./255;            % Color data (颜色数据)
        Arrow    = 'off'                                       % Arrow mode: 'on'/'off' (箭头模式)
        Group    = []                                          % Group assignment for nodes (节点分组)
        GroupSep = 1/15                                        % Separation between groups (组间间隙)
        TickRadius = 1.17                                      % Tick radius (刻度半径)
        SquareRadius = [1.05, 1.15]                            % Inner and outer radius of the arc square (弦块的内外半径)
        LabelRadius  = 1.28                                    % Label radius (标签半径)
        LabelRotate  = 'off'                                   % Label rotation mode: 'on'/'off'/'none' (标签旋转模式)
        SubSquareRatio = 0                                     % Subordinate square ratio: Square ratio at chord ends (弦末端方块比例)
        OriSquareRatio = 1                                     % Original square ratio (原始弧形块比例)
        Rotation = 0                                           % Global rotation angle (全局旋转角度)
        TickMode = 'value'                                     % Tick mode: 'value'/'auto'/'linear' (刻度模式)
        LinearTickSep                                          % Linear tick spacing (线性刻度间隔)
        LinearTickCompactDegree = 3.5                          % Linear tick compact degree (线性刻度紧密程度)
        LinearMinorTick = 'off'                                % Minor tick mode: 'on'/'off' (次刻度线模式)

        % {color, srcLabel, tgtLabel, valLabel, format} (颜色、源标签、目标标签、数值标签、格式)
        dataTipFormat = {'k', 'Source:', 'Target:', 'Value:', 'auto'}   

        squareHdl                                              % squares (节点方块)
        squareSMatHdl                                          % Source-side sub-squares | Source split squares for chord ends (弦末端下方拆分方块)
        squareTMatHdl                                          % Target-side sub-squares | Target split squares for chord ends (弦末端上方拆分方块)
        labelHdl                                               % Labels (标签)
        chordMatHdl                                            % Chord ribbons (弦)
        thetaTickHdl                                           % Theta tick lines (角度刻度线)
        RTickHdl                                               % Radius tick lines (半径刻度线)
        thetaTickLabelHdl                                      % Theta tick labels (角度刻度标签)
    end

    properties (Hidden)
        % Angular positions (角度位置) % read only
        thetaSet = []                                          % Angular positions for blocks/squares (方块角度位置)
        meanThetaSet; iMidThetaSet; jMidThetaSet               % Midpoint angles (中点角度)
        rotationSet; thetaFullSet                              % Rotation angles and full theta set (旋转角度与完整角度集)
    end

    properties (Dependent, Hidden)
        linearTickSep; linearTickCompactDegree; linearMinorTick; 
        squareFMatHdl; nameHdl
    end

    % Shorthands / alias
    properties (Dependent)
        TRadius    % TickRadius
        SRadius    % SquareRadius
        LRadius    % LabelRadius
        LRotate    % LabelRotate
        SSqRatio   % SubSquareRatio
        OSqRatio   % OriSquareRatio
    end

    methods 
        function val = get.TRadius(obj),  val = obj.TickRadius;     end
        function val = get.SRadius(obj),  val = obj.SquareRadius;   end
        function val = get.LRadius(obj),  val = obj.LabelRadius;    end
        function val = get.LRotate(obj),  val = obj.LabelRotate;    end
        function val = get.SSqRatio(obj), val = obj.SubSquareRatio; end
        function val = get.OSqRatio(obj), val = obj.OriSquareRatio; end
        function val = get.linearTickSep(obj), val = obj.LinearTickSep; end
        function val = get.linearTickCompactDegree(obj), val = obj.LinearTickCompactDegree; end
        function val = get.linearMinorTick(obj), val = obj.LinearMinorTick; end
        function val = get.squareFMatHdl(obj), val = obj.squareSMatHdl; end
        function val = get.nameHdl(obj), val = obj.labelHdl; end
       
        function set.TRadius(obj, val),  obj.TickRadius = val;      end
        function set.SRadius(obj, val),  obj.SquareRadius = val;    end
        function set.LRadius(obj, val),  obj.LabelRadius = val;     end
        function set.LRotate(obj, val),  obj.LabelRotate = val;     end
        function set.SSqRatio(obj, val), obj.SubSquareRatio = val;  end
        function set.OSqRatio(obj, val), obj.OriSquareRatio = val;  end
        function set.linearTickSep(obj, val), obj.LinearTickSep = val;  end
        function set.linearTickCompactDegree(obj, val), obj.LinearTickCompactDegree = val;  end
        function set.linearMinorTick(obj, val), obj.LinearMinorTick = val;  end
        function set.squareFMatHdl(obj, val), obj.squareSMatHdl = val;  end
        function set.nameHdl(obj, val), obj.labelHdl = val;  end

% =========================================================================
% Constructor (构造函数)
% =========================================================================
        function obj = biChordChart(varargin)
            % Parse axes handle (解析坐标区句柄)
            if isa(varargin{1}, 'matlab.graphics.axis.Axes')
                obj.ax = varargin{1};
                varargin(1) = [];
            else
                obj.ax = gca;
            end
            obj.ax.NextPlot = 'add';

            % Parse data matrix (解析数据矩阵)
            obj.dataMat = abs(varargin{1});
            varargin(1) = [];
            % obj.Group = ones(1, size(obj.dataMat, 2));

            % Parse name-value pairs (解析名称-值对)
            for i = 1:2:(length(varargin) - 1)
                tid = ismember(lower(obj.arginList), lower(varargin{i}));
                if any(tid)
                    obj.(obj.arginList{tid}) = varargin{i + 1};
                end
            end

            % Set default labels if not provided (若未提供则设置默认标签)
            if isempty(obj.Label) || length(obj.Label) < size(obj.dataMat, 1)
                obj.Label = compose('C%d', 1:size(obj.dataMat, 1));
            end

            % % Ensure diagonal elements are non-negative (确保对角线元素非负)
            % for i = 1:size(obj.dataMat, 1)
            %     obj.dataMat(i, i) = abs(obj.dataMat(i, i));
            % end
        end

% =========================================================================
% Main drawing method (主绘图方法)
% =========================================================================
        function varargout = draw(obj)
            % varargout = obj.draw() - Render the biChordChart object (渲染双向弦图对象)

            % Validate gap parameters (验证间隙参数)
            if obj.Sep > 1/2, obj.Sep = 1/2; end
            if obj.GroupSep > 1/2, obj.GroupSep = 1/2; end

            % Adjust color count if needed (调整颜色数量)
            if size(obj.CData, 1) < size(obj.dataMat, 1)
                obj.CData = [obj.CData; rand([size(obj.dataMat, 1), 3]) * 0.5 + 0.5];
            end

            % Validate label radius (验证标签半径)
            if obj.LabelRadius < 1
                obj.LabelRadius = 1;
            end

            % Validate Tick radius (验证刻度半径)
            if obj.TickRadius < 1
                obj.TickRadius = 1;
            end

            % Validate square radius (验证节点弧形块半径)
            obj.SquareRadius = sort(abs(obj.SquareRadius));
            if obj.SquareRadius(1) < 1
                obj.SquareRadius(1) = 1;
            end

            % =============================================================

            % Configure axes (配置坐标区)
            obj.ax.XLim = [-1.38, 1.38];
            obj.ax.YLim = [-1.38, 1.38];
            obj.ax.XTick = [];
            obj.ax.YTick = [];
            obj.ax.XColor = 'none';
            obj.ax.YColor = 'none';
            obj.ax.PlotBoxAspectRatio = [1, 1, 1];

            % Compute ratios (计算比例)
            if length(obj.Group) < size(obj.dataMat, 1)
                obj.Group = ones(1, size(obj.dataMat, 2));
            end

            tGroup = groupConsecutive(obj.Group);
            groupNum = max(tGroup) - (obj.Group(end) == obj.Group(1));

            numC = size(obj.dataMat, 1);
            ratioC1 = sum(abs(obj.dataMat), 2) ./ sum(sum(abs(obj.dataMat)));
            ratioC2 = sum(abs(obj.dataMat), 1) ./ sum(sum(abs(obj.dataMat)));
            ratioC = (ratioC1' + ratioC2) ./ 2;
            ratioC = [0, ratioC];

            % # version 2.0.0 Linear tick spacing (线性刻度间隔)
            obj.LinearTickSep = obj.getTick(sum(sum(obj.dataMat))./(size(obj.dataMat, 1) + size(obj.dataMat, 2))*2, obj.LinearTickCompactDegree);

            % # version 4.1.0 Separation lengths (分离长度)
            if groupNum == 0
                gsepLen = 0;
                sepLen   = (2 * pi * obj.Sep) ./ numC;
                baseLen  = 2 * pi * (1 - obj.Sep);
            else
                gsepLen = (2 * pi * obj.GroupSep) ./ groupNum;
                sepLen  = (2 * pi * obj.Sep * (1 - obj.GroupSep)) ./ numC;
                baseLen = 2 * pi * (1 - obj.Sep) * (1 - obj.GroupSep);
            end

            if length(obj.Rotation) < 2
                obj.Rotation = repmat(obj.Rotation, [numC, 1]);
            end

            % =============================================================
            % Draw blocks and labels (绘制方块和标签)
            % =============================================================
            obj.squareHdl = gobjects(1, numC);
            obj.labelHdl  = gobjects(1, numC);
            obj.RTickHdl  = gobjects(1, numC);
            diffTheta = zeros(1, numC);
            for i = 1:numC
                theta1 = sum(ratioC(1:i)) * baseLen + (i - 1 + 0.5) * sepLen + obj.Rotation(i) + (tGroup(i) - 1 + 0.5) * gsepLen;
                theta2 = sum(ratioC(1:i+1)) * baseLen + (i - 1 + 0.5) * sepLen + obj.Rotation(i) + (tGroup(i) - 1 + 0.5) * gsepLen;
                diffTheta(i) = theta2 - theta1;

                if abs(obj.Rotation(1) - obj.Rotation(2)) > eps
                    theta1 = obj.Rotation(i) - diffTheta(i) / 2;
                    theta2 = obj.Rotation(i) + diffTheta(i) / 2;
                end

                theta = linspace(theta1, theta2, 100);
                X = cos(theta);
                Y = sin(theta);

                % Draw blocks (节点绘制)
                obj.squareHdl(i) = fill(obj.ax, [(obj.SquareRadius(2) - diff(obj.SquareRadius) * obj.OriSquareRatio) .* X, obj.SquareRadius(2) .* X(end:-1:1)], ...
                                                [(obj.SquareRadius(2) - diff(obj.SquareRadius) * obj.OriSquareRatio) .* Y, obj.SquareRadius(2) .* Y(end:-1:1)], ...
                                             obj.CData(i, :), 'EdgeColor', 'none');

                % Label position and rotation (标签位置与旋转)
                theta3 = mod((theta1 + theta2) / 2, 2 * pi);
                obj.meanThetaSet(i) = theta3;
                rotation = theta3 / pi * 180;

                if rotation > 0 && rotation < 180
                    obj.labelHdl(i) = text(obj.ax, cos(theta3) * obj.LabelRadius, sin(theta3) * obj.LabelRadius, obj.Label{i}, ...
                        'FontSize', 14, 'FontName', 'Arial', 'HorizontalAlignment', 'center', ...
                        'Rotation', -(0.5 * pi - theta3) / pi * 180, 'Tag', 'BiChordLabel');
                    obj.rotationSet(i) = -(0.5 * pi - theta3) / pi * 180;
                else
                    obj.labelHdl(i) = text(obj.ax, cos(theta3) * obj.LabelRadius, sin(theta3) * obj.LabelRadius, obj.Label{i}, ...
                        'FontSize', 14, 'FontName', 'Arial', 'HorizontalAlignment', 'center', ...
                        'Rotation', -(1.5 * pi - theta3) / pi * 180, 'Tag', 'BiChordLabel');
                    obj.rotationSet(i) = -(1.5 * pi - theta3) / pi * 180;
                end
                obj.RTickHdl(i) = plot(obj.ax, cos(theta) .* obj.TickRadius, sin(theta) .* obj.TickRadius, ...
                    'Color', [0, 0, 0], 'LineWidth', 0.8, 'Visible', 'off');
            end

            % =============================================================
            % Draw chords (绘制弦)
            % =============================================================
            obj.chordMatHdl   = gobjects(numC, numC);
            obj.squareSMatHdl = gobjects(numC, numC);
            obj.squareTMatHdl = gobjects(numC, numC);
            for i = 1:numC
                for j = 1:numC
                    % Theta calculations for source and target (源与目标的角度计算)
                    theta_i_1 = sum(ratioC(1:i)) * baseLen + (i - 1 + 0.5) * sepLen + (tGroup(i) - 1 + 0.5) * gsepLen;
                    theta_i_2 = sum(ratioC(1:i+1)) * baseLen + (i - 1 + 0.5) * sepLen + (tGroup(i) - 1 + 0.5) * gsepLen;
                    theta_i_3 = theta_i_1 + (theta_i_2 - theta_i_1) .* sum(abs(obj.dataMat(:, i))) ./ ...
                               (sum(abs(obj.dataMat(:, i))) + sum(abs(obj.dataMat(i, :))));

                    theta_j_1 = sum(ratioC(1:j)) * baseLen + (j - 1 + 0.5) * sepLen + (tGroup(j) - 1 + 0.5) * gsepLen;
                    theta_j_2 = sum(ratioC(1:j+1)) * baseLen + (j - 1 + 0.5) * sepLen + (tGroup(j) - 1 + 0.5) * gsepLen;
                    theta_j_3 = theta_j_1 + (theta_j_2 - theta_j_1) .* sum(abs(obj.dataMat(:, j))) ./ ...
                               (sum(abs(obj.dataMat(:, j))) + sum(abs(obj.dataMat(j, :))));

                    ratio_i_1 = obj.dataMat(i, :);
                    ratio_i_1 = [0, ratio_i_1 ./ sum(ratio_i_1)];
                    ratio_j_2 = obj.dataMat(:, j)';
                    ratio_j_2 = [0, ratio_j_2 ./ sum(ratio_j_2)];

                    theta1 = theta_i_2 + (theta_i_3 - theta_i_2) .* sum(ratio_i_1(1:j)) + obj.Rotation(i);
                    theta2 = theta_i_2 + (theta_i_3 - theta_i_2) .* sum(ratio_i_1(1:j+1)) + obj.Rotation(i);
                    theta3 = theta_j_3 + (theta_j_1 - theta_j_3) .* sum(ratio_j_2(1:i)) + obj.Rotation(j);
                    theta4 = theta_j_3 + (theta_j_1 - theta_j_3) .* sum(ratio_j_2(1:i+1)) + obj.Rotation(j);

                    if abs(obj.Rotation(1) - obj.Rotation(2)) > eps
                        theta1 = theta1 - diffTheta(i) / 2 - theta_i_1;
                        theta2 = theta2 - diffTheta(i) / 2 - theta_i_1;
                        theta3 = theta3 - diffTheta(j) / 2 - theta_j_1;
                        theta4 = theta4 - diffTheta(j) / 2 - theta_j_1;
                    end

                    tPnt1 = [cos(theta1), sin(theta1)];
                    tPnt2 = [cos(theta2), sin(theta2)];
                    tPnt3 = [cos(theta3), sin(theta3)];
                    tPnt4 = [cos(theta4), sin(theta4)];

                    % Store angles for tick marks (存储角度用于刻度)
                    obj.thetaFullSet{i}(j)            = theta1;
                    obj.thetaFullSet{i}(j + 1)        = theta2;
                    obj.thetaFullSet{j}(i + numC)     = theta3;
                    obj.thetaFullSet{j}(i + numC + 1) = theta4;
                    obj.iMidThetaSet(i, j) = (theta1 + theta2) / 2;
                    obj.jMidThetaSet(i, j) = (theta3 + theta4) / 2;

                    if abs(obj.dataMat(i, j)) > 0
                    % Bezier curves and rendering (贝塞尔曲线与渲染)
                    if strcmp(obj.Arrow, 'off')
                        tLine1 = bezierCurve([tPnt1; 0, 0; tPnt4], 200);
                        tLine2 = bezierCurve([tPnt2; 0, 0; tPnt3], 200);
                        tline3 = [cos(linspace(theta2, theta1, 100))', sin(linspace(theta2, theta1, 100))'];
                        tline4 = [cos(linspace(theta4, theta3, 100))', sin(linspace(theta4, theta3, 100))'];
                    else
                        tLine1 = bezierCurve([tPnt1; 0, 0; tPnt4 .* 0.96], 200);
                        tLine2 = bezierCurve([tPnt2; 0, 0; tPnt3 .* 0.96], 200);
                        tline3 = [cos(linspace(theta2, theta1, 100))', sin(linspace(theta2, theta1, 100))'];
                        tline4 = [cos(theta4) .* 0.96, sin(theta4) .* 0.96;
                                  cos((theta3 + theta4) / 2) .* 0.99, sin((theta3 + theta4) / 2) .* 0.99;
                                  cos(theta3) .* 0.96, sin(theta3) .* 0.96];
                    end

                    % Chord fill (弦填充)
                    obj.chordMatHdl(i, j) = fill(obj.ax, [tLine1(:, 1); tline4(:, 1); tLine2(end:-1:1, 1); tline3(:, 1)], ...
                                                         [tLine1(:, 2); tline4(:, 2); tLine2(end:-1:1, 2); tline3(:, 2)], ...
                                                          obj.CData(i, :), 'FaceAlpha', 0.3, 'EdgeColor', 'none', ...
                                                          'UserData', [i, j], 'ButtonDownFcn', @obj.onChordClick);
                    

                    % Split blocks at chord ends (弦末端拆分方块)
                    XF = cos(linspace(theta1, theta2, 100));
                    YF = sin(linspace(theta1, theta2, 100));
                    XT = cos(linspace(theta3, theta4, 100));
                    YT = sin(linspace(theta3, theta4, 100));

                    obj.squareSMatHdl(i, j) = fill(obj.ax, [obj.SquareRadius(1) .* XF, (obj.SquareRadius(1) + obj.SubSquareRatio * diff(obj.SquareRadius)) .* XF(end:-1:1)], ...
                                                           [obj.SquareRadius(1) .* YF, (obj.SquareRadius(1) + obj.SubSquareRatio * diff(obj.SquareRadius)) .* YF(end:-1:1)], ...
                                                            obj.CData(j, :), 'EdgeColor', 'none');
                    obj.squareTMatHdl(i, j) = fill(obj.ax, [obj.SquareRadius(1) .* XT, (obj.SquareRadius(1) + obj.SubSquareRatio * diff(obj.SquareRadius)) .* XT(end:-1:1)], ...
                                                           [obj.SquareRadius(1) .* YT, (obj.SquareRadius(1) + obj.SubSquareRatio * diff(obj.SquareRadius)) .* YT(end:-1:1)], ...
                                                            obj.CData(i, :), 'EdgeColor', 'none');
                    end
                end
            end

            % Remove NaN entries from thetaFullSet (移除 NaN 条目)
            isNANListF{numC} = [];
            for i = 1:numC
                tTFS = obj.thetaFullSet{i};
                isNANListF{i} = isnan(tTFS);
                obj.thetaFullSet{i} = tTFS(~isNANListF{i});
            end

            % =============================================================
            % Draw tick marks (绘制刻度线)
            % =============================================================
            uniListF{numC} = [];
            for i = 1:numC
                [obj.thetaFullSet{i}, uniListF{i}] = unique(obj.thetaFullSet{i}, 'stable');
            end

            switch lower(obj.TickMode)
                case 'value'
                    tickX = [cos([obj.thetaFullSet{:}]) .* obj.TickRadius; cos([obj.thetaFullSet{:}]) .* (obj.TickRadius + .02); nan .* [obj.thetaFullSet{:}]];
                    tickY = [sin([obj.thetaFullSet{:}]) .* obj.TickRadius; sin([obj.thetaFullSet{:}]) .* (obj.TickRadius + .02); nan .* [obj.thetaFullSet{:}]];
                case 'auto'
                    tTFS0{numC} = [];
                    tTFS1{numC} = [];
                    for i = 1:numC
                        tTFS0{i} = obj.thetaFullSet{i};
                        for k = 1:3
                            tTFS1{i} = obj.thetaFullSet{i};
                            tTFSA = abs(diff(tTFS1{i}));
                            tTFSB = [inf, tTFSA] < mean(tTFSA)/2 | [tTFSA, inf] < mean(tTFSA)/2;
                            if ~isempty(tTFS1{i})
                                tTFS2 = linspace(tTFS1{i}(1), tTFS1{i}(end), length(tTFS1{i}));
                                tTFSC = tTFS1{i};
                                tTFSC(tTFSB) = tTFS2(tTFSB);
                                tTFSC(tTFSC > tTFS1{i} + pi/30) = tTFS1{i}(tTFSC > tTFS1{i} + pi/30) + pi/30;
                                tTFSC(tTFSC < tTFS1{i} - pi/30) = tTFS1{i}(tTFSC < tTFS1{i} - pi/30) - pi/30;
                                obj.thetaFullSet{i} = sort((2 .* tTFS1{i} + tTFSC) ./ 3, 'descend');
                            end
                        end
                    end

                    tickX = [cos([tTFS0{:}]) .* obj.TickRadius; cos([tTFS0{:}]) .* (obj.TickRadius + 1/3*0.02); ...
                             cos([obj.thetaFullSet{:}]) .* (obj.TickRadius + 2/3*0.02); cos([obj.thetaFullSet{:}]) .* (obj.TickRadius + .02); ...
                             nan .* [obj.thetaFullSet{:}]];
                    tickY = [sin([tTFS0{:}]) .* obj.TickRadius; sin([tTFS0{:}]) .* (obj.TickRadius + 1/3*0.02); ...
                             sin([obj.thetaFullSet{:}]) .* (obj.TickRadius + 2/3*0.02); sin([obj.thetaFullSet{:}]) .* (obj.TickRadius + .02); ...
                             nan .* [obj.thetaFullSet{:}]];
                case 'linear'
                    tMTFS{numC} = [];
                    for i = 1:numC
                        tTFS = obj.thetaFullSet{i};
                        if ~isempty(tTFS)
                            totalFlow = sum(obj.dataMat(i, :)) + sum(obj.dataMat(:, i));
                            obj.thetaFullSet{i} = (tTFS(end) - tTFS(1)) ./ totalFlow .* (0:obj.LinearTickSep:totalFlow) + tTFS(1);
                            tMTFS{i} = (tTFS(end) - tTFS(1)) ./ totalFlow .* (0:obj.LinearTickSep/5:totalFlow) + tTFS(1);
                        else
                            tMTFS{i} = [];
                        end
                    end

                    if strcmp(obj.LinearMinorTick, 'on')
                        tickX = [cos([tMTFS{:}]) .* obj.TickRadius, cos([obj.thetaFullSet{:}]) .* obj.TickRadius;
                                 cos([tMTFS{:}]) .* (obj.TickRadius + .01), cos([obj.thetaFullSet{:}]) .* (obj.TickRadius + .02);
                                 nan .* [[obj.thetaFullSet{:}], [tMTFS{:}]]];
                        tickY = [sin([tMTFS{:}]) .* obj.TickRadius, sin([obj.thetaFullSet{:}]) .* obj.TickRadius;
                                 sin([tMTFS{:}]) .* (obj.TickRadius + .01), sin([obj.thetaFullSet{:}]) .* (obj.TickRadius + .02);
                                 nan .* [[obj.thetaFullSet{:}], [tMTFS{:}]]];
                    else
                        tickX = [cos([obj.thetaFullSet{:}]) .* obj.TickRadius; cos([obj.thetaFullSet{:}]) .* (obj.TickRadius + .02); nan .* [obj.thetaFullSet{:}]];
                        tickY = [sin([obj.thetaFullSet{:}]) .* obj.TickRadius; sin([obj.thetaFullSet{:}]) .* (obj.TickRadius + .02); nan .* [obj.thetaFullSet{:}]];
                    end
            end
            obj.thetaTickHdl = plot(obj.ax, tickX(:), tickY(:), 'Color', [0, 0, 0], 'LineWidth', 0.8, 'Visible', 'off');

            % =============================================================
            % Draw tick labels (绘制刻度标签)
            % =============================================================
            obj.thetaTickLabelHdl = gobjects(numC, max(cellfun(@length, obj.thetaFullSet)));
            for i = 1:numC
                if strcmpi(obj.TickMode, 'linear')
                    cumsumV = 0:obj.LinearTickSep:(sum(obj.dataMat(i, :)) + sum(obj.dataMat(:, i)));
                else
                    cumsumV = [0, cumsum([obj.dataMat(i, :), obj.dataMat(:, i)'])];
                    cumsumV = cumsumV(~isNANListF{i});
                    cumsumV = cumsumV(uniListF{i});
                end

                for j = 1:length(obj.thetaFullSet{i})
                    rotation = mod(obj.thetaFullSet{i}(j) / pi * 180, 360);
                    if ~isnan(obj.thetaFullSet{i}(j))
                        if rotation > 90 && rotation < 270
                            rotation = rotation + 180;
                            obj.thetaTickLabelHdl(i, j) = text(obj.ax, ...
                                cos(obj.thetaFullSet{i}(j)) .* (obj.TickRadius + .03), ...
                                sin(obj.thetaFullSet{i}(j)) .* (obj.TickRadius + .03), num2str(cumsumV(j)), ...
                                'Rotation', rotation, 'HorizontalAlignment', 'right', 'FontSize', 9, ...
                                'FontName', 'Arial', 'Visible', 'off', 'UserData', cumsumV(j));
                        else
                            obj.thetaTickLabelHdl(i, j) = text(obj.ax, ...
                                cos(obj.thetaFullSet{i}(j)) .* (obj.TickRadius + .03), ...
                                sin(obj.thetaFullSet{i}(j)) .* (obj.TickRadius + .03), num2str(cumsumV(j)), ...
                                'Rotation', rotation, 'FontSize', 9, 'FontName', 'Arial', ...
                                'Visible', 'off', 'UserData', cumsumV(j));
                        end
                    end
                end
            end

            % for i = 1:numC
            %     uistack(obj.RTickHdl(i), 'top')
            %     uistack(obj.nameHdl(i), 'top')
            % end

            % =============================================================
            % Helper functions (辅助函数)
            % =============================================================
            function pnts = bezierCurve(pnts, N)
                % Bezier curve calculation (贝塞尔曲线计算)
                t = linspace(0, 1, N);
                p = size(pnts, 1) - 1;
                coe1 = factorial(p) ./ factorial(0:p) ./ factorial(p:-1:0);
                coe2 = ((t) .^ ((0:p)')) .* ((1 - t) .^ ((p:-1:0)'));
                pnts = (pnts' * (coe1' .* coe2))';
            end

            function group_id = groupConsecutive(arr)
                % Consecutive group numbering (连续分组编号)
                if isempty(arr)
                    group_id = [];
                    return;
                end
                group_id = ones(size(arr));
                current_group = 1;
                for ind = 2:length(arr)
                    if arr(ind) ~= arr(ind - 1)
                        current_group = current_group + 1;
                    end
                    group_id(ind) = current_group;
                end
            end

            % Apply label rotation (应用标签旋转)
            obj.labelRotate(obj.LabelRotate)

            if nargout == 1
                varargout{1} = obj;
            end
        end

% =========================================================================
% Chord property settings (弦属性设置)
% =========================================================================
        function setChord(obj, varargin)
            % obj.setChord(varargin) - Chord property settings (弦属性设置)
            %
            %   obj.setChord(___); Set properties for all chord.
            %
            %   obj.setChord(m, n, ___); Set the properties for the chord which
            %   connect m-th square node and n-th square node.
            %
            %   obj.setChord([m1, m2, ...], [n1, n2, ...], ___); Set properties for
            %   multiple chords specified by corresponding pairs of source indices (m) and target indices (n).
            %
            %   obj.setChord([m1; m2; ...], [n1, n2, ...], ___);
            %   obj.setChord([m1, m2, ...], [n1; n2; ...], ___); Set properties for 
            %   all combinations when the source vector and target vector have different sizes.
            %
            %   obj.setChord([m1, m2, ...], [], ___); Set properties for all chords 
            %   from the specified source indices to every target.
            %
            %   obj.setChord([], [n1, n2, ...], ___); Set properties for all chords 
            %   from every source to the specified target indices.
            %
            %   obj.setChord(Bool, ___); Set properties for chords where the logical
            %   matrix Bool is true. Bool(m, n) = true selects the chord between source m and target n.
            if islogical(varargin{1})
                [M, N] = find(varargin{1});
                for i = 1:length(M)
                    m = M(i); n = N(i);
                    if isa(obj.chordMatHdl(m, n), 'matlab.graphics.primitive.Patch')
                        set(obj.chordMatHdl(m, n), varargin{2:end});
                    end
                end
            elseif isnumeric(varargin{1})
                M = varargin{1}; N = varargin{2};
                if all(size(M) == size(N))
                    for i = 1:length(M)
                        m = M(i); n = N(i);
                        if isa(obj.chordMatHdl(m, n), 'matlab.graphics.primitive.Patch')
                            set(obj.chordMatHdl(m, n), varargin{3:end});
                        end
                    end
                else
                    if isempty(M); M = 1:size(obj.dataMat, 1); end
                    if isempty(N); N = 1:size(obj.dataMat, 2); end
                    for i = 1:length(M)
                        for j = 1:length(N)
                            m = M(i); n = N(j);
                            if isa(obj.chordMatHdl(m, n), 'matlab.graphics.primitive.Patch')
                                set(obj.chordMatHdl(m, n), varargin{3:end});
                            end
                        end
                    end
                end
            else
                for i = 1:size(obj.dataMat, 1)
                    for j = 1:size(obj.dataMat, 2)
                        if isa(obj.chordMatHdl(i, j), 'matlab.graphics.primitive.Patch')
                            set(obj.chordMatHdl(i, j), varargin{:});
                        end
                    end
                end
            end
        end

        function setChordCData(obj, CMat)
            % obj.setChordCData(CMat) - Set the 'CData' property of each chord patch (设置弦的 CData 属性)  
            % 
            % Input:
            %   CMat - Matrix of size [N, N, 1] or [N, N, 3] where, N = number of nodes. 
            for i = 1:size(obj.dataMat, 1)
                for j = 1:size(obj.dataMat, 2)
                    if isa(obj.chordMatHdl(i, j), 'matlab.graphics.primitive.Patch')
                        set(obj.chordMatHdl(i, j), 'CData', CMat(i, j, :), 'FaceColor','flat');
                    end
                end
            end
        end

        function setChordColorBySquareS(obj)
            % obj.setChordColorBySquareS() - Color each chord using its source block color (根据来源方块颜色为弦着色) 
            for i = 1:size(obj.dataMat, 1)
                for j = 1:size(obj.dataMat, 2)
                    fColor = get(obj.squareHdl(i), 'FaceColor');
                    eColor = get(obj.squareHdl(i), 'EdgeColor');
                    obj.setChordMN(i,j, 'FaceColor',fColor, 'EdgeColor',eColor)
                end
            end
        end
        function setChordColorBySquareT(obj)
            % obj.setChordColorBySquareT() - Color each chord using its target block color (根据目标方块颜色为弦着色)
            for i = 1:size(obj.dataMat, 1)
                for j = 1:size(obj.dataMat, 2)
                    fColor = get(obj.squareHdl(j), 'FaceColor');
                    eColor = get(obj.squareHdl(j), 'EdgeColor');
                    obj.setChordMN(i,j, 'FaceColor',fColor, 'EdgeColor',eColor)
                end
            end
        end

% =========================================================================
% Square property settings (方块属性设置)
% =========================================================================
        function setSquare(obj, varargin)
            % obj.setSquare(varargin) - Node square property settings (节点弧形块属性设置)
            %
            %   obj.setSquare(___); Set properties for all squares.
            %
            %   obj.setSquare(n, ___); Set properties for n-th square.
            %
            %   obj.setSquare([n1, n2, ...], ___); Set properties for 
            %   multiple specified squares (by their indices).
            %
            %   obj.setSquare(Bool, ___); Set properties for squares where the
            %   logical vector Bool (length = number of nodes) is true.
            if islogical(varargin{1})
                N = find(varargin{1});
                for i = 1:length(N)
                    set(obj.squareHdl(N(i)), varargin{2:end});
                end
            elseif isnumeric(varargin{1})
                N = varargin{1};
                for i = 1:length(N)
                    set(obj.squareHdl(N(i)), varargin{2:end});
                end
            else
                for i = 1:size(obj.dataMat, 1)
                    set(obj.squareHdl(i), varargin{:});
                end
            end
        end


        function setSubSquareT(obj, varargin)
            % obj.setSubSquareT(varargin) - Target sub-square property settings (目标子方块属性设置)
            %
            %   obj.setSubSquareT(___); Set properties for all target sub-squares.
            %
            %   obj.setSubSquareT(m, n, ___); Set properties for the m‑th sub‑square inside the n‑th square.
            %
            %   obj.setSubSquareT([m1, m2, ...], [n1, n2, ...],___); Set properties for
            %   multiple specified target-side sub‑square (by their indices).
            %
            %   obj.setSubSquareT([m1; m2; ...], [n1, n2, ...], ___);
            %   obj.setSubSquareT([m1, m2, ...], [n1; n2; ...], ___); Set properties for 
            %   all combinations when the source vector and target vector have different sizes.
            %
            %   obj.setSubSquareT([m1, m2, ...], [], ___); Set properties for all target-side sub-square 
            %   from the specified source indices to every target.
            %
            %   obj.setSubSquareT([], [n1, n2, ...], ___); Set properties for all target-side sub-square 
            %   from every source to the specified target indices.
            %
            %   obj.setSubSquareT(Bool, ___); Set properties for target-side sub‑squares 
            %   where the logical matrix Bool is true.
            if islogical(varargin{1})
                [M, N] = find(varargin{1});
                for i = 1:length(M)
                    m = M(i); n = N(i);
                    if isa(obj.squareTMatHdl(m, n), 'matlab.graphics.primitive.Patch')
                        set(obj.squareTMatHdl(m, n), 'Visible', 'on', varargin{2:end})
                    end
                end
            elseif isnumeric(varargin{1})
                M = varargin{1}; N = varargin{2};
                if all(size(M) == size(N))
                    for i = 1:length(M)
                        m = M(i); n = N(i);
                        if isa(obj.squareTMatHdl(m, n), 'matlab.graphics.primitive.Patch')
                            set(obj.squareTMatHdl(m, n), 'Visible', 'on', varargin{3:end})
                        end
                    end
                else
                    if isempty(M); M = 1:size(obj.dataMat, 1); end
                    if isempty(N); N = 1:size(obj.dataMat, 2); end
                    for i = 1:length(M)
                        for j = 1:length(N)
                            m = M(i); n = N(j);
                            if isa(obj.squareTMatHdl(m, n), 'matlab.graphics.primitive.Patch')
                                set(obj.squareTMatHdl(m, n), 'Visible', 'on', varargin{3:end})
                            end
                        end
                    end
                end
            else
                for m = 1:size(obj.dataMat, 1)
                    for n = 1:size(obj.dataMat, 2)
                        if isa(obj.squareTMatHdl(m, n), 'matlab.graphics.primitive.Patch')
                            set(obj.squareTMatHdl(m, n), 'Visible', 'on', varargin{:})
                        end
                    end
                end
            end
        end

        function setSubSquareS(obj, varargin)
            % obj.setSubSquareS(varargin) - Source sub‑square property settings (来源子方块属性设置)
            %
            %   obj.setSubSquareS(___); Set properties for all source sub‑squares.
            %
            %   obj.setSubSquareS(m, n, ___); Set properties for the n‑th sub‑square inside the m‑th square.
            %
            %   obj.setSubSquareS([m1, m2, ...], [n1, n2, ...],___); Set properties for
            %   multiple specified source-side sub‑square (by their indices).
            %
            %   obj.setSubSquareS([m1; m2; ...], [n1, n2, ...], ___);
            %   obj.setSubSquareS([m1, m2, ...], [n1; n2; ...], ___); Set properties for 
            %   all combinations when the source vector and target vector have different sizes.
            %
            %   obj.setSubSquareS([m1, m2, ...], [], ___); Set properties for all source-side sub-square 
            %   from the specified source indices to every target.
            %
            %   obj.setSubSquareS([], [n1, n2, ...], ___); Set properties for all source-side sub-square 
            %   from every source to the specified target indices.
            %
            %   obj.setSubSquareS(Bool, ___); Set properties for source-side sub‑squares 
            %   where the logical matrix Bool is true.
            if islogical(varargin{1})
                [M, N] = find(varargin{1});
                for i = 1:length(M)
                    m = M(i); n = N(i);
                    if isa(obj.squareSMatHdl(m, n), 'matlab.graphics.primitive.Patch')
                        set(obj.squareSMatHdl(m, n), 'Visible', 'on', varargin{2:end})
                    end
                end
            elseif isnumeric(varargin{1})
                M = varargin{1}; N = varargin{2};
                if all(size(M) == size(N))
                    for i = 1:length(M)
                        m = M(i); n = N(i);
                        if isa(obj.squareSMatHdl(m, n), 'matlab.graphics.primitive.Patch')
                            set(obj.squareSMatHdl(m, n), 'Visible', 'on', varargin{3:end})
                        end
                    end
                else
                    if isempty(M); M = 1:size(obj.dataMat, 1); end
                    if isempty(N); N = 1:size(obj.dataMat, 2); end
                    for i = 1:length(M)
                        for j = 1:length(N)
                            m = M(i); n = N(j);
                            if isa(obj.squareSMatHdl(m, n), 'matlab.graphics.primitive.Patch')
                                set(obj.squareSMatHdl(m, n), 'Visible', 'on', varargin{3:end})
                            end
                        end
                    end
                end
            else
                for m = 1:size(obj.dataMat, 1)
                    for n = 1:size(obj.dataMat, 2)
                        if isa(obj.squareSMatHdl(m, n), 'matlab.graphics.primitive.Patch')
                            set(obj.squareSMatHdl(m, n), 'Visible', 'on', varargin{:})
                        end
                    end
                end
            end
        end       

        function setSquareColor(obj, FaceCList, EdgeCList)
            % obj.setSquareColor(FaceCList, EdgeCList) - Set color for each square (弧形块颜色设置)
            for i = 1:size(obj.dataMat, 1)
                obj.setSquareN(i, 'FaceColor', FaceCList(i,:))
                if nargin == 3
                    obj.setSquareN(i, 'EdgeColor', EdgeCList(i,:))
                end
            end
            for i = 1:size(obj.dataMat, 1)
                for j = 1:size(obj.dataMat, 2)
                    obj.setEachSquareT_Prop(i, j, 'FaceColor', FaceCList(i,:))
                    obj.setEachSquareS_Prop(i, j, 'FaceColor', FaceCList(j,:))
                    % if nargin == 3
                    %     obj.setEachSquareT_Prop(i, j, 'EdgeColor', EdgeCList(i,:))
                    %     obj.setEachSquareS_Prop(i, j, 'EdgeColor', EdgeCList(j,:))
                    % end
                end
            end
        end

        function setSquareCData(obj, CVal)
            % obj.setSquareCData(CVal) - Set the 'CData' property of each square (设置方块的 CData 属性)  
            if isvector(CVal)
                CVal = CVal(:);
            end
            for i = 1:size(obj.dataMat, 1)
                obj.setSquare(i, 'FaceColor', 'flat', 'CData', CVal(i, :, :))
            end
        end

% =========================================================================
% Set labels (标签设置)
% =========================================================================
        function setFont(obj, varargin)
            % obj.setFont(varargin) - Label property settings (标签属性设置)
            for i = 1:size(obj.dataMat, 1)
                set(obj.labelHdl(i), varargin{:});
            end
        end

        function setFontColor(obj, CList)
            % setFontColor(CList) - Node label color settings (节点标签颜色设置)
            for i = 1:size(obj.dataMat, 1)
                set(obj.labelHdl(i), 'Color',CList(i, :));
            end
        end

        function obj = setLabelRadius(obj, Radius)
            % obj.setLabelRadius(Radius) - Set label radius (设置标签半径)
            obj.LabelRadius = Radius;
            for i = 1:size(obj.dataMat, 1)
                set(obj.labelHdl(i), 'Position', [cos(obj.meanThetaSet(i)), sin(obj.meanThetaSet(i))] .* obj.LabelRadius);
            end
        end

        function labelRotate(obj, Rotate)
            % obj.labelRotate(Rotate) - Label rotation control (标签旋转控制)
            %
            % Input:
            %   Rotate - Rotation mode (旋转模式):
            %       'on'   - Labels parallel to radial direction (标签平行于径向)
            %       'off'  - Labels perpendicular to radial (tangential) (标签垂直于径向/切线方向)
            %       'none' - Labels horizontal (no rotation) (标签水平，无旋转)
            %
            % Example:
            %   obj.labelRotate('on');   % 平行于径向
            %   obj.labelRotate('off');  % 垂直于径向
            %   obj.labelRotate('none'); % 水平
            obj.LabelRotate = Rotate;
            for i = 1:size(obj.dataMat, 1)
                set(obj.labelHdl(i), 'HorizontalAlignment', 'center', 'Rotation', obj.rotationSet(i))
            end
            if strcmpi(obj.LabelRotate, 'on')
                textHdl = findobj(obj.ax, 'Tag', 'BiChordLabel');
                for i = 1:length(textHdl)
                    if textHdl(i).Rotation < -90
                        textHdl(i).Rotation = textHdl(i).Rotation + 180;
                    end
                    switch true                        
                        case textHdl(i).Rotation < 0 && textHdl(i).Position(2) > 0
                            textHdl(i).Rotation = textHdl(i).Rotation + 90;
                            textHdl(i).HorizontalAlignment = 'left';
                        case textHdl(i).Rotation >= 0 && textHdl(i).Position(2) > 0
                            textHdl(i).Rotation = textHdl(i).Rotation - 90;
                            textHdl(i).HorizontalAlignment = 'right';
                        case textHdl(i).Rotation < 0 && textHdl(i).Position(2) <= 0
                            textHdl(i).Rotation = textHdl(i).Rotation + 90;
                            textHdl(i).HorizontalAlignment = 'right';
                        case textHdl(i).Rotation >= 0 && textHdl(i).Position(2) <= 0
                            textHdl(i).Rotation = textHdl(i).Rotation - 90;
                            textHdl(i).HorizontalAlignment = 'left';
                    end
                    if abs(textHdl(i).Rotation) < eps
                        if textHdl(i).Position(1) > 0
                            textHdl(i).HorizontalAlignment = 'left';
                        else
                            textHdl(i).HorizontalAlignment = 'right';
                        end
                    end
                end
            elseif strcmpi(obj.LabelRotate, 'none')
                textHdl = findobj(gca, 'Tag','BiChordLabel');
                for i = 1:length(textHdl)
                    set(textHdl(i), 'Rotation',0)
                    if textHdl(i).Position(1) < -.1
                        set(textHdl(i), 'HorizontalAlignment','right')
                    elseif textHdl(i).Position(1) > .1
                        set(textHdl(i), 'HorizontalAlignment','left')
                    end
                end
            end
        end

% =========================================================================
% Set ticks (刻度设置)
% =========================================================================
        function tickState(obj, state)
            % obj.tickState(state) - Show/hide tick marks (显示/隐藏刻度线)
            for i = 1:size(obj.dataMat, 1)
                set(obj.RTickHdl(i), 'Visible', state);
            end
            set(obj.thetaTickHdl, 'Visible', state);
        end

        function tickLabelState(obj, state)
            % obj.tickLabelState(state) - Show/hide tick labels (显示/隐藏刻度标签)
            for m = 1:length(obj.thetaFullSet)
                for n = 1:length(obj.thetaFullSet{m})
                    if ~(n < length(obj.thetaFullSet{m}) && abs(obj.thetaFullSet{m}(n) - obj.thetaFullSet{m}(n+1)) < eps)
                        set(obj.thetaTickLabelHdl(m, n), 'Visible', state)
                    end
                end
            end
        end

        function setTick(obj, varargin)
            % obj.setTick(varargin) - Tick line property settings (刻度线属性设置)
            for i = 1:size(obj.dataMat, 1)
                set(obj.RTickHdl(i), varargin{:});
            end
            set(obj.thetaTickHdl, varargin{:});
        end

        function setTickFont(obj, varargin)
            % obj.setTickFont(varargin) - Tick label property settings (刻度标签属性设置)
            for m = 1:length(obj.thetaFullSet)
                for n = 1:length(obj.thetaFullSet{m})
                    set(obj.thetaTickLabelHdl(m, n), varargin{:})
                end
            end
        end

        function setTickLabelFormat(obj, func)
            % obj.setTickLabelFormat(func) - Set custom format for tick labels (设置刻度标签的自定义格式)
            for m = 1:length(obj.thetaFullSet)
                for n = 1:length(obj.thetaFullSet{m})
                    tStr = func(get(obj.thetaTickLabelHdl(m, n), 'UserData'));
                    set(obj.thetaTickLabelHdl(m, n), 'String', tStr)
                end
            end
        end

% =========================================================================
% Utility functions (功能函数)
% =========================================================================
        function tXS = getTick(~, Len, N)
            % Calculate optimal tick spacing (计算最优刻度间隔)
            tXS = Len / N;
            tXN = ceil(log(tXS) / log(10));
            tXS = round(round(tXS / 10^(tXN-2)) / 5) * 5 * 10^(tXN - 2);
        end

        function tHdl = addHighlightArrow(obj, i, j, Color)
            % tHdl = obj.addHighlightArrow(i, j, Color) - Add highlight arrow indicator (添加高亮箭头指示器)
            if nargin < 4
                Color = [0,0,0];
            end
            tPnt1 = [cos(obj.iMidThetaSet(i, j)), sin(obj.iMidThetaSet(i, j))];
            tPnt2 = [cos(obj.jMidThetaSet(i, j)), sin(obj.jMidThetaSet(i, j))];
            tLine = bezierCurve([tPnt1; 0, 0; tPnt2.*.95], 200);
            tHdl.Line = plot(obj.ax, tLine(:, 1), tLine(:, 2), 'LineWidth', 1, 'Color', Color);

            tPnt3 = [cos(obj.jMidThetaSet(i, j) - pi/100) .* 0.95, sin(obj.jMidThetaSet(i, j) - pi/100) .* 0.95];
            tPnt4 = [cos(obj.jMidThetaSet(i, j) + pi/100) .* 0.95, sin(obj.jMidThetaSet(i, j) + pi/100) .* 0.95];
            tHdl.Arrow = fill(obj.ax, [tPnt2(1), tPnt3(1), tPnt4(1)], [tPnt2(2), tPnt3(2), tPnt4(2)], Color, 'EdgeColor',Color);

            function pnts = bezierCurve(pnts, N)
                t = linspace(0, 1, N);
                p = size(pnts, 1) - 1;
                coe1 = factorial(p) ./ factorial(0:p) ./ factorial(p:-1:0);
                coe2 = ((t) .^ ((0:p)')) .* ((1 - t) .^ ((p:-1:0)'));
                pnts = (pnts' * (coe1' .* coe2))';
            end
        end

        function onChordClick(obj, src, event)
            % Chord click callback for data tips (弦点击回调：数据提示框)
            % Left click: show data tooltip (左键: 显示数据提示框)
            % Right click: hide highlight (右键: 隐藏高亮)
            if ~verLessThan('matlab', '9.7')
                if event.Button == 1
                    src.EdgeColor = obj.dataTipFormat{1};
                    src.LineWidth = 1;
                    datatip(src, event.IntersectionPoint(1), event.IntersectionPoint(2));
                    src.DataTipTemplate.DataTipRows(1) = ...
                        dataTipTextRow(obj.dataTipFormat{2}, repmat(obj.Label(src.UserData(1)), length(src.XData), 1));
                    src.DataTipTemplate.DataTipRows(2) = ...
                        dataTipTextRow(obj.dataTipFormat{3}, repmat(obj.Label(src.UserData(2)), length(src.XData), 1));
                    src.DataTipTemplate.DataTipRows(3) = ...
                        dataTipTextRow(obj.dataTipFormat{4}, repmat(obj.dataMat(src.UserData(1), src.UserData(2)), ...
                        [length(src.XData), 1]), obj.dataTipFormat{5});
                else
                    src.EdgeColor = 'none';
                    src.LineWidth = 0.5;
                end
            end
        end
    end

% =========================================================================
% Hidden methods >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% =========================================================================
    methods (Hidden)
        function setFontN(obj, n, varargin)
            % Set font properties for a specific label (设置特定标签的字体属性)
            set(obj.labelHdl(n), varargin{:});
        end

        function setChordProp(obj, varargin)
            % Batch chord property setting (批量设置弦的属性)
            for i = 1:size(obj.dataMat, 1)
                for j = 1:size(obj.dataMat, 2)
                    if isa(obj.chordMatHdl(i, j), 'matlab.graphics.primitive.Patch')
                        set(obj.chordMatHdl(i, j), varargin{:});
                    end
                end
            end
        end

        function setChordMN(obj, m, n, varargin)
            % Set properties for a specific chord (设置特定弦的属性)
            if isa(obj.chordMatHdl(m, n), 'matlab.graphics.primitive.Patch')
                set(obj.chordMatHdl(m, n), varargin{:});
            end
        end
        function setChordN(obj, n, varargin)
            % Set properties for all chords from node n (设置从节点 n 出发的所有弦的属性)
            for i = n
                for j = 1:size(obj.dataMat, 2)
                    if isa(obj.chordMatHdl(i, j), 'matlab.graphics.primitive.Patch')
                        set(obj.chordMatHdl(i, j), varargin{:});
                    end
                end
            end
        end

        function setSquareN(obj, n, varargin)
            % Set properties for a specific block (设置特定方块的属性)
            set(obj.squareHdl(n), varargin{:});
        end

        function setSquareProp(obj, varargin)
            % Batch block property setting (批量设置方块的属性)
            for i = 1:size(obj.dataMat, 1)
                set(obj.squareHdl(i), varargin{:});
            end
        end

        function setEachSquareT_Prop(obj, m, n, varargin)
            % Set properties for a specific target-side block (设置特定目标端方块的属性)
            if isa(obj.squareTMatHdl(m, n), 'matlab.graphics.primitive.Patch')
                set(obj.squareTMatHdl(m, n), 'Visible', 'on', varargin{:})
            end
        end

        function setEachSquareF_Prop(obj, m, n, varargin)
            % Set properties for a specific source-side block (设置特定源端方块的属性)
            if isa(obj.squareSMatHdl(m, n), 'matlab.graphics.primitive.Patch')
                set(obj.squareSMatHdl(m, n), 'Visible', 'on', varargin{:})
            end
        end

        function setEachSquareS_Prop(obj, m, n, varargin)
            % Set properties for a specific source-side block (设置特定源端方块的属性)
            if isa(obj.squareSMatHdl(m, n), 'matlab.graphics.primitive.Patch')
                set(obj.squareSMatHdl(m, n), 'Visible', 'on', varargin{:})
            end
        end

    end
end


% =========================================================================
% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer
% -------------------------------------------------------------------------
% Zhaoxu Liu / slandarer (2026). biChordChart (bidirectional chord diagram | 有向弦图) 
% (https://www.mathworks.com/matlabcentral/fileexchange/121043-bichordchart-bidirectional-chord-diagram), 
% MATLAB Central File Exchange. Retrieved April 14, 2026.
% =========================================================================