classdef chordChart < handle
% chordChart Create and customize chord diagrams (弦图)
%   CC = chordChart(dataMat); creates a chord diagram from a numerical matrix.
%   从数值矩阵创建弦图。
%
%   CC = chordChart(dataMat, 'RowName', rowName, 'ColName', colName); specifies
%   row and column names for the diagram.
%   指定图表的行名和列名。
%
%   CC = chordChart(ax, ___); creates a chord diagram in the specified axes.
%   在指定坐标区创建弦图。
%
%   CC = chordChart(___, propName, propVal); specifies property name-value pairs
%   when creating the chord diagram object.
%   创建弦图对象时指定属性名-属性值对。
%   
%   CC.propName = propVal; sets properties for the chord diagram object
%   after creation, before rendering.
%   创建弦图对象后、绘图前设置其属性。
%
%   CC = CC.draw(); renders the chord diagram.
%   渲染弦图。
%
% Note:
%   The element dataMat(i, j) represents the flow value from the i-th bottom
%   block (squareS) to the j-th top block (squareT), which determines the
%   width of the corresponding chord (ribbon).
%   dataMat(i, j) 的值代表从第 i 个下方方块 (squareS) 到第 j 个上方方块 (squareT)
%   的流量数值，该数值决定对应弦(连接带)的宽度。
%
% Basic usage:
%   dataMat = [2 0 1 2 5 1 2;
%              3 5 1 4 2 0 1;
%              4 0 5 5 2 4 3];
%   colName = {'G1','G2','G3','G4','G5','G6','G7'};
%   rowName = {'S1','S2','S3'};
%   CC = chordChart(dataMat, 'RowName', rowName, 'ColName', colName);
%   CC = CC.draw();
%
% Methods: (try: help chordChart.setChord)
%   draw                   - Render the chordChart object (渲染弦图对象)
%   labelRotate            - Label rotation control (标签旋转控制)
%   tickState              - Show/hide tick marks (显示/隐藏刻度线)
%   tickLabelState         - Show/hide tick labels (显示/隐藏刻度标签)
%   setLabelRadius         - Set label radius (设置标签半径)
%   setFont                - Label property settings (标签属性设置)
%   setFontColorS          - Source node label color settings (来源节点标签颜色设置)
%   setFontColorT          - Target node label color settings (目标节点标签颜色设置)
%   setTick                - Tick line property settings (刻度线属性设置)
%   setTickFont            - Tick label property settings (刻度标签属性设置)
%   setTickLabelFormat     - Set custom format for tick labels (设置刻度标签的自定义格式)
%   setSquareS             - Source node square property settings (来源节点弧形块属性设置)
%   setSquareT             - Target node square property settings (目标节点弧形块属性设置)
%   setSquareCDataS        - Set the 'CData' property of each source square (设置来源块的 CData 属性)
%   setSquareCDataT        - Set the 'CData' property of each target square (设置目标块的 CData 属性)
%   setSquareColorS        - Set color for each source square (来源弧形块颜色设置)
%   setSquareColorT        - Set color for each target square (目标弧形块颜色设置)
%   setSubSquareS          - Source sub‑square property settings (来源子方块属性设置)
%   setSubSquareT          - Target sub-square property settings (目标子方块属性设置)
%   setChord               - Chord property settings (弦属性设置)
%   setChordCData          - Set the 'CData' property of each chord patch (设置弦的 CData 属性)
%   setChordColorBySquareS - Color each chord using its source block color (根据来源方块颜色为弦着色)
%   setChordColorBySquareT - Color each chord using its target block color (根据目标方块颜色为弦着色)
%   addHighlightArrow      - Add highlight arrow indicator (添加高亮箭头指示器)


% =========================================================================
% Copyright (c) 2022-2026, Zhaoxu Liu / slandarer
% -------------------------------------------------------------------------
% Zhaoxu Liu / slandarer (2026). chordChart (chord diagram | 弦图) 
% (https://www.mathworks.com/matlabcentral/fileexchange/116550-chordchart-chord-diagram), 
% MATLAB Central File Exchange. Retrieved April 14, 2026.
% =========================================================================


% =========================================================================
% Version History (版本更新)
% =========================================================================
% # version 1.5.0
%   + Fixed bug with sum(....,[1,2]) in older versions (修复老版本 sum 函数 Bug)
%   + Added 'Sep' property for adjustable square spacing (增添可调节方块间距属性)
%   + Added demo3 for label rotation (增添旋转标签角度示例)
% -------------------------------------------------------------------------
% # version 1.7.0
%   + Added 'LRadius' property for adjustable label radius (增添可调节标签半径属性)
%   + Added 'LRotate' property and labelRotate function (增添可调节标签旋转属性)
%   + Direct colormap adjustment using `colormap` function (可直接使用 colormap 调整颜色)
%   + Added `tickLabelState` function to display tick labels (可使用函数显示刻度标签)
% -------------------------------------------------------------------------
% # version 2.1.0
%   + Fixed incorrect label rotation bug in older versions (修复老版本标签错误旋转 Bug)
%   + Added setEachSquareF_Prop / setEachSquareT_Prop for individual chord end blocks
%     (单独设置每一个弦末端方块)
% -------------------------------------------------------------------------
% # version 2.2.0
%   + Added 'SSqRatio' property to adjust arc-shaped block ratio at chord ends
%     (可使用 SSqRatio 属性调整弦末端弧形块占比)
% -------------------------------------------------------------------------
% # version 3.0.0
%   + Added two new tick marking methods (新增两种标志刻度的方法)
%     - 'auto' : Automatically adjust overlapping tick labels
%     - 'linear': Draw evenly spaced tick marks
%   + Added linearTickCompactDegree and linearMinorTick properties
%     (线性刻度相关属性)
% -------------------------------------------------------------------------
% # version 3.1.0
%   + Added 'OSqRatio' property to adjust original arc block ratio (新增 OSqRatio 属性)
%   + Added 'Rotation' property for global diagram rotation (新增 Rotation 属性)
% -------------------------------------------------------------------------
% # version 4.0.0
%   + Left-click to add data tooltip, right-click to hide highlight
%     (左键添加数据提示框，右键隐藏高亮)
% -------------------------------------------------------------------------
% # version 4.1.0
%   + Added addHighlightArrow function to add arrow indicators (添加提示箭头)
% -------------------------------------------------------------------------
% # version 5.0.0
%   + Added setSquareColorT function 
%     to set colors for top squares and their corresponding 
%     split blocks/squares for chord ends
%     (新增 setSquareColorT 函数用以设置上方弧形块及与之对应的子弧形块颜色)
%   + Added setSquareColorF function 
%     to set colors for bottom squares and their corresponding 
%     split blocks/squares for chord ends
%     (新增 setSquareColorF 函数用以设置下方弧形块及与之对应的子弧形块颜色)
%   + Added setChordColorBySquareT() function 
%     to render chords using colors from top squares
%     (新增 setChordColorBySquareT 函数使用上方方块颜色渲染弦)
%   + Added setChordColorBySquareF() function 
%     to render chords using colors from bottom squares
%     (新增 setChordColorBySquareF 函数使用下方方块颜色渲染弦)
%
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
%     squareFHdl         -> squareSHdl
%     squareFMatHdl      -> squareSMatHdl
%     nameFHdl           -> nameSHdl
%     thetaTickFHdl      -> thetaTickSHdl
%     RTickFHdl          -> RTickSHdl
%     thetaTickLabelFHdl -> thetaTickLabelSHdl
%     (Variable names previously associated with 'F' remain available.)
%   + The setChord method replaces setChordProp and setChordMN.
%     setChord(___)          | Set properties for all chord
%     setChord(M, N, ___)    | Set the properties for the chord which
%                              connect M-th square bellow
%                              and N-th square above
%   + The setSquareS method replaces setSquareF_Prop and setSquareF_N.
%   + The setSquareT method replaces setSquareT_Prop and setSquareT_N.
%     setSquareS(___)        | Set properties for all blocks bellow (source)
%     setSquareS(N, ___)     | Set properties for N-th block bellow (source)
%     setSquareT(___)        | Set properties for all blocks above (target)
%     setSquareT(N, ___)     | Set properties for N-th block above (target)
%   + The setSubSquareS method replaces setEachSquareF_Prop.
%   + The setSubSquareT method replaces setEachSquareT_Prop.
% -------------------------------------------------------------------------
% # version 7.1.0
%   + Added setChordCData method to set the 'CData' property of each chord patch (设置弦的 CData 属性) 
%   + Added setSquareCDataS method to set the 'CData' property of each source square (设置来源方块的 CData 属性) 
%   + Added setSquareCDataT method to set the 'CData' property of each target square (设置目标方块的 CData 属性) 
%   + Refine the inline comments for methods.
% -------------------------------------------------------------------------
% # version 7.2.0
%   + For methods: Added support for logical matrix inputs.


    properties
        ax                                                    % Axes handle (坐标区句柄)
        
        
        arginList = {'ColName', 'RowName','Sep','GroupSep','Arrow','CData','Rotation','TickMode',...
                     'TRadius' , 'TickRadius', ...
                     'SRadius' , 'SquareRadius', ...
                     'LRadius' , 'LabelRadius', ...
                     'LRotate' , 'LabelRotate', ...
                     'SSqRatio', 'SubSquareRatio', ...
                     'OSqRatio', 'OriSquareRatio'} % Name-value pair list (名称-值对参数列表)
        
        chordTable                                            % Table array (表格数组)
        dataMat                                               % Numerical matrix (数值矩阵)
        ColName = {}                                          % Column names (列名称)
        RowName = {}                                          % Row names (行名称)

        Sep      = 1/40                                       % Separation between square nodes (弧形块间隙)
        CData    = [61 96 137; 76 103 86] ./ 255;             % Color data (颜色数据)
        Arrow    = 'off'                                      % Arrow mode: 'on'/'off' (箭头模式)
        GroupSep = 1/16                                       % Separation between group top and bottom (上下组间间隙)
        TickRadius = 1.17                                     % Tick radius (刻度半径)
        SquareRadius = [1.05, 1.15]                           % Inner and outer radius of the arc square (弦块的内外半径)
        LabelRadius  = 1.28                                   % Label radius (标签半径)
        LabelRotate  = 'off'                                  % Label rotation mode: 'on'/'off'/'none' (标签旋转模式)
        SubSquareRatio = 0                                    % Subordinate square ratio: Square ratio at chord ends (弦末端方块比例)
        OriSquareRatio = 1                                    % Original arc block/square ratio (原始弧形块比例)
        Rotation = 0                                          % Global rotation angle (全局旋转角度)
        TickMode = 'value'                                    % Tick mode: 'value'/'auto'/'linear' (刻度模式)
        LinearTickSep                                         % Linear tick spacing (线性刻度间隔)
        LinearTickCompactDegree = 2.5                         % Linear tick Compact degree (线性刻度紧密程度)
        LinearMinorTick         = 'off'                       % Minor tick mode: 'on'/'off' (次刻度线模式)

        % {color, srcLabel, tgtLabel, valLabel, format} (颜色、源标签、目标标签、数值标签、格式)
        dataTipFormat = {'k', 'Source:', 'Target:', 'Value:', 'auto'}    

        squareSHdl                                             % Source/Bottom squares (下方方块)
        squareTHdl                                             % Target/Top squares (上方方块)
        squareSMatHdl                                          % Source-side sub-squares | Bottom split squares for chord ends (弦末端下方拆分方块)
        squareTMatHdl                                          % Target-side sub-squares | Top split squares for chord ends (弦末端上方拆分方块)
        labelSHdl                                              % Source/Bottom labels (下方标签)
        labelTHdl                                              % Target/Top labels (上方标签)
        chordMatHdl                                            % Chord ribbons (弦)
        thetaTickSHdl                                          % Theta tick lines for bottom (下方角度刻度线)
        thetaTickTHdl                                          % Theta tick lines for top (上方角度刻度线)
        RTickSHdl                                              % Radius tick lines for bottom (下方半径刻度线)
        RTickTHdl                                              % Radius tick lines for top (上方半径刻度线)
        thetaTickLabelSHdl                                     % Theta tick labels for bottom (下方角度刻度标签)
        thetaTickLabelTHdl                                     % Theta tick labels for top (上方角度刻度标签)
    end
    properties (Hidden)
        % Midpoint angles for chord connections (弦连接中点角度)
        iMidThetaSet                                           % Source-side midpoints (来源侧中点)
        jMidThetaSet                                           % Target-side midpoints (目标侧中点)

        % Angular positions (角度位置)
        thetaSetS                                              % Source node angles (来源节点角度)
        meanThetaSetS                                          % Mean source angles (来源节点平均角度)
        rotationS                                              % Source rotation angles (来源节点旋转角度)
        thetaSetT                                              % Target node angles (目标节点角度)
        meanThetaSetT                                          % Mean target angles (目标节点平均角度)
        rotationT                                              % Target rotation angles (目标节点旋转角度)
    end
    properties (Dependent, Hidden)
        linearTickSep; linearTickCompactDegree; linearMinorTick
        squareFHdl; squareFMatHdl; nameFHdl; nameSHdl; nameTHdl
        thetaTickFHdl; RTickFHdl; thetaTickLabelFHdl
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
        function val = get.squareFHdl(obj), val = obj.squareSHdl; end
        function val = get.squareFMatHdl(obj), val = obj.squareSMatHdl; end
        function val = get.nameFHdl(obj), val = obj.labelSHdl; end
        function val = get.nameSHdl(obj), val = obj.labelSHdl; end
        function val = get.nameTHdl(obj), val = obj.labelTHdl; end
        function val = get.thetaTickFHdl(obj), val = obj.thetaTickSHdl; end
        function val = get.RTickFHdl(obj), val = obj.RTickSHdl; end
        function val = get.thetaTickLabelFHdl(obj), val = obj.thetaTickLabelSHdl; end
        
        function set.TRadius(obj, val),  obj.TickRadius = val;      end
        function set.SRadius(obj, val),  obj.SquareRadius = val;    end
        function set.LRadius(obj, val),  obj.LabelRadius = val;     end
        function set.LRotate(obj, val),  obj.LabelRotate = val;     end
        function set.SSqRatio(obj, val), obj.SubSquareRatio = val;  end
        function set.OSqRatio(obj, val), obj.OriSquareRatio = val;  end
        function set.linearTickSep(obj, val), obj.LinearTickSep = val;  end
        function set.linearTickCompactDegree(obj, val), obj.LinearTickCompactDegree = val;  end
        function set.linearMinorTick(obj, val), obj.LinearMinorTick = val;  end
        function set.squareFHdl(obj, val), obj.squareSHdl = val;  end
        function set.squareFMatHdl(obj, val), obj.squareSMatHdl = val;  end
        function set.nameFHdl(obj, val), obj.labelSHdl = val;  end
        function set.nameSHdl(obj, val), obj.labelSHdl = val;  end
        function set.nameTHdl(obj, val), obj.labelTHdl = val;  end
        function set.thetaTickFHdl(obj, val), obj.thetaTickSHdl = val;  end
        function set.RTickFHdl(obj, val), obj.RTickSHdl = val;  end
        function set.thetaTickLabelFHdl(obj, val), obj.thetaTickLabelSHdl = val;  end

% =========================================================================
% Constructor: Create chordChart object (构造函数)
% =========================================================================
        function obj = chordChart(varargin)
            % Parse axes handle if provided (解析坐标区句柄)
            if isa(varargin{1}, 'matlab.graphics.axis.Axes')
                obj.ax = varargin{1};
                varargin(1) = [];
            else
                obj.ax = gca;
            end
            obj.ax.NextPlot = 'add';

            % Store data matrix (存储数据矩阵)
            obj.dataMat = abs(varargin{1});
            varargin(1) = [];

            % Parse name-value pairs (解析名称-值对)
            for i = 1:2:(length(varargin) - 1)
                tid = ismember(lower(obj.arginList), lower(varargin{i}));
                if any(tid)
                    obj.(obj.arginList{tid}) = varargin{i+1};
                end
            end

            % Handle table input or create table (处理表格输入或创建表格)
            if isa(obj.dataMat, 'table')
                obj.chordTable = obj.dataMat;
                obj.dataMat = obj.chordTable.Variables;
                
                if isempty(obj.chordTable.Properties.RowNames)
                    for i = 1:size(obj.chordTable.Variables, 1)
                        obj.RowName{i} = ['R', num2str(i)];
                    end
                end
                obj.RowName  = obj.chordTable.Properties.RowNames;
                obj.ColName    = obj.chordTable.Properties.VariableNames;
            else
                % Set default column names if empty (若列为空则设置默认列名)
                if isempty(obj.ColName)
                    obj.ColName = compose('C%d', 1:size(obj.dataMat, 2));
                end
                
                % Set default row names if empty (若行为空则设置默认行名)
                if isempty(obj.RowName)
                    obj.RowName = compose('R%d', 1:size(obj.dataMat, 1));
                end
            end
        end


% =========================================================================
% Draw: Render the chord diagram (渲染弦图)
% =========================================================================
        function varargout = draw(obj)
            % varargout = obj.draw() - Render the chordChart object (渲染弦图对象)

            tDMat  = obj.dataMat;
            tDFrom = obj.RowName;
            tDTo   = obj.ColName;

            numS = size(tDMat, 1);       % Number of source nodes (源节点数)
            numT = size(tDMat, 2);       % Number of target nodes (目标节点数)
            numM = max(numS, numT);

            % Validate parameter ranges (验证参数范围)
            if obj.Sep*(numM - 1) > 1; obj.Sep = 1/(2*(numM - 1)); end
            if obj.GroupSep > 1/2, obj.GroupSep = 1/2; end

            if size(obj.CData, 1) < 2
                obj.CData = [61 96 137; 76 103 86] ./ 255;
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
            % Setup axes (设置坐标区)
            obj.ax.XLim = [-1.38, 1.38];
            obj.ax.YLim = [-1.38, 1.38];
            obj.ax.XTick = [];
            obj.ax.YTick = [];
            obj.ax.XColor = 'none';
            obj.ax.YColor = 'none';
            obj.ax.PlotBoxAspectRatio = [1, 1, 1];
            
            obj.LinearTickSep = obj.getTick(sum(sum(tDMat)) ./ (size(tDMat, 1) + size(tDMat, 2)) .* 2, obj.LinearTickCompactDegree);
            % % Normalize data for coloring (归一化数据用于着色)
            % tDMatUni = tDMat - min(min(tDMat));
            % tDMatUni = tDMatUni ./ max(max(tDMatUni));
            sep1 = obj.GroupSep;            % Group separation (上下两组分隔)
            sep2 = obj.Sep;                 % Node separation (节点分隔)
            % Calculate ratio of each row/column (计算每行/列的比例)
            ratioS = [0; sum(tDMat, 2) ./ sum(sum(tDMat))];
            ratioT = [0, sum(tDMat, 1) ./ sum(sum(tDMat))];
            % Calculate arc lengths (计算弧长)
            sepLen   = pi * (1 - sep1) * sep2;
            baseLenF = (pi * (1 - sep1) - numS * sepLen);
            baseLenT = (pi * (1 - sep1) - numT * sepLen);

            % =============================================================
            % Draw bottom blocks (绘制下方方块)
            % =============================================================
            obj.squareSHdl = gobjects(1, numS);
            obj.labelSHdl   = gobjects(1, numS);
            obj.RTickSHdl  = gobjects(1, numS);
            for i = 1:numS
                theta1 = 2*pi - pi*sep1/2 - sum(ratioS(1:i))   * baseLenF - (i-.5)*sepLen + obj.Rotation;
                theta2 = 2*pi - pi*sep1/2 - sum(ratioS(1:i+1)) * baseLenF - (i-.5)*sepLen + obj.Rotation;
                theta  = linspace(theta1, theta2, 100);
                X = cos(theta); Y = sin(theta);
                obj.squareSHdl(i) = fill(obj.ax, [(obj.SquareRadius(2) - diff(obj.SquareRadius)*obj.OriSquareRatio).*X, obj.SquareRadius(2).*X(end:-1:1)], ...
                                                 [(obj.SquareRadius(2) - diff(obj.SquareRadius)*obj.OriSquareRatio).*Y, obj.SquareRadius(2).*Y(end:-1:1)], ...
                                          obj.CData(1, :), 'EdgeColor', 'none');
                theta3 = mod((theta1 + theta2) / 2, 2*pi);
                obj.meanThetaSetS(i) = theta3;
                rotation = mod(theta3 / pi * 180, 360);
                if rotation > 0 && rotation < 180
                    obj.labelSHdl(i) = text(obj.ax, cos(theta3).*obj.LabelRadius, sin(theta3).*obj.LabelRadius, tDFrom{i}, ...
                                           'FontSize', 12, 'FontName', 'Arial', 'HorizontalAlignment', 'center', ...
                                           'Rotation', -(.5*pi - theta3) ./ pi .* 180, 'Tag', 'ChordLabel');
                    obj.rotationS(i) = -(.5*pi - theta3) ./ pi .* 180;
                else
                    obj.labelSHdl(i) = text(obj.ax, cos(theta3).*obj.LabelRadius, sin(theta3).*obj.LabelRadius, tDFrom{i}, ...
                                           'FontSize', 12, 'FontName', 'Arial', 'HorizontalAlignment', 'center', ...
                                           'Rotation', -(1.5*pi - theta3) ./ pi .* 180, 'Tag', 'ChordLabel');
                    obj.rotationS(i) = -(1.5*pi - theta3) ./ pi .* 180;
                end
                obj.RTickSHdl(i) = plot(obj.ax, cos(theta).*obj.TickRadius, sin(theta).*obj.TickRadius, ...
                                        'Color', [0, 0, 0], 'LineWidth', .8, 'Visible', 'off');
            end

            % =============================================================
            % Draw top blocks (绘制上方方块)
            % =============================================================
            obj.squareTHdl = gobjects(1, numT);
            obj.labelTHdl  = gobjects(1, numT);
            obj.RTickTHdl  = gobjects(1, numT);
            for j = 1:numT
                theta1 = pi - pi*sep1/2 - sum(ratioT(1:j))   * baseLenT - (j-.5)*sepLen + obj.Rotation;
                theta2 = pi - pi*sep1/2 - sum(ratioT(1:j+1)) * baseLenT - (j-.5)*sepLen + obj.Rotation;
                theta  = linspace(theta1, theta2, 100);
                X = cos(theta);
                Y = sin(theta);    
                obj.squareTHdl(j) = fill(obj.ax, [(obj.SquareRadius(2) - diff(obj.SquareRadius)*obj.OriSquareRatio).*X, obj.SquareRadius(2).*X(end:-1:1)], ...
                                                 [(obj.SquareRadius(2) - diff(obj.SquareRadius)*obj.OriSquareRatio).*Y, obj.SquareRadius(2).*Y(end:-1:1)], ...
                                          obj.CData(2, :), 'EdgeColor', 'none');           
                theta3 = mod((theta1 + theta2) / 2, 2*pi);
                obj.meanThetaSetT(j) = theta3;
                rotation = theta3 / pi * 180;
                if rotation > 0 && rotation < 180
                    obj.labelTHdl(j) = text(obj.ax, cos(theta3).*obj.LabelRadius, sin(theta3).*obj.LabelRadius, tDTo{j}, ...
                                           'FontSize', 12, 'FontName', 'Arial', 'HorizontalAlignment', 'center', ...
                                           'Rotation', -(.5*pi - theta3) ./ pi .* 180, 'Tag', 'ChordLabel');
                    obj.rotationT(j) = -(.5*pi - theta3) ./ pi .* 180;
                else
                    obj.labelTHdl(j) = text(obj.ax, cos(theta3).*obj.LabelRadius, sin(theta3).*obj.LabelRadius, tDTo{j}, ...
                                           'FontSize', 12, 'FontName', 'Arial', 'HorizontalAlignment', 'center', ...
                                           'Rotation', -(1.5*pi - theta3) ./ pi .* 180, 'Tag', 'ChordLabel');
                    obj.rotationT(j) = -(1.5*pi - theta3) ./ pi .* 180;
                end
                obj.RTickTHdl(j) = plot(obj.ax, cos(theta).*obj.TickRadius, sin(theta).*obj.TickRadius, ...
                                        'Color', [0, 0, 0], 'LineWidth', .8, 'Visible', 'off');
            end

            % Set colormap (设置颜色映射)
            colormap(obj.ax, flipud(summer(50)))
            try clim([0, max(max(tDMat))]), catch, end; try caxis([0, max(max(tDMat))]), catch, end

            % =============================================================
            % Draw chords (ribbons) (绘制弦/连接带)
            % =============================================================
            obj.squareSMatHdl = gobjects(numS, numT);
            obj.squareTMatHdl = gobjects(numS, numT);
            obj.chordMatHdl   = gobjects(numS, numT);
            for i = 1:numS
                for j = numT:-1:1
                    theta1 = 2*pi - pi*sep1/2 - sum(ratioS(1:i))   * baseLenF - (i-.5)*sepLen + obj.Rotation;
                    theta2 = 2*pi - pi*sep1/2 - sum(ratioS(1:i+1)) * baseLenF - (i-.5)*sepLen + obj.Rotation;
                    theta3 = pi - pi*sep1/2 - sum(ratioT(1:j))   * baseLenT - (j-.5)*sepLen + obj.Rotation;
                    theta4 = pi - pi*sep1/2 - sum(ratioT(1:j+1)) * baseLenT - (j-.5)*sepLen + obj.Rotation;
                    % Calculate sub-block ratios (计算子块比例)
                    tRowV = tDMat(i, :);
                    tRowV = [0, tRowV(end:-1:1) ./ sum(tRowV)];
                    tColV = tDMat(:, j)';
                    tColV = [0, tColV ./ sum(tColV)];
                    % Sub-block angles (子块角度)
                    theta5 = (theta2 - theta1) .* sum(tRowV(1:(numT+1-j))) + theta1;
                    theta6 = (theta2 - theta1) .* sum(tRowV(1:(numT+2-j))) + theta1;
                    theta7 = (theta3 - theta4) .* sum(tColV(1:i)) + theta4;
                    theta8 = (theta3 - theta4) .* sum(tColV(1:i+1)) + theta4;
                    % Draw square end blocks (绘制末端方块)
                    if abs(tDMat(i, j)) > 0
                    theta = linspace(theta5, theta6, 100); X = cos(theta); Y = sin(theta);
                    obj.squareSMatHdl(i, j) = fill(obj.ax, [obj.SquareRadius(1).*X, (obj.SquareRadius(1)+obj.SubSquareRatio*diff(obj.SquareRadius)).*X(end:-1:1)], ...
                                                           [obj.SquareRadius(1).*Y, (obj.SquareRadius(1)+obj.SubSquareRatio*diff(obj.SquareRadius)).*Y(end:-1:1)], ...
                                                    obj.CData(2, :), 'EdgeColor', 'none', 'Visible','off');
                    theta = linspace(theta7, theta8, 100); X = cos(theta); Y = sin(theta);
                    obj.squareTMatHdl(i, j) = fill(obj.ax, [obj.SquareRadius(1).*X, (obj.SquareRadius(1)+obj.SubSquareRatio*diff(obj.SquareRadius)).*X(end:-1:1)], ...
                                                           [obj.SquareRadius(1).*Y, (obj.SquareRadius(1)+obj.SubSquareRatio*diff(obj.SquareRadius)).*Y(end:-1:1)], ...
                                                    obj.CData(2, :), 'EdgeColor', 'none', 'Visible','off');
                    end
                    % Bezier curve control points (贝塞尔曲线控制点)
                    tPnt1 = [cos(theta5), sin(theta5)];
                    tPnt2 = [cos(theta6), sin(theta6)];
                    tPnt3 = [cos(theta7), sin(theta7)];
                    tPnt4 = [cos(theta8), sin(theta8)];
                    % Store midpoint angles (存储中点角度)
                    obj.iMidThetaSet(i, j) = (theta5 + theta6) ./ 2;
                    obj.jMidThetaSet(i, j) = (theta7 + theta8) ./ 2;
                    % Store tick positions for non-linear modes (存储非线性模式的刻度位置)
                    if ~strcmpi(obj.TickMode, 'linear')
                        if j == numT
                            obj.thetaSetS{i}(1) = theta5;
                        end
                        obj.thetaSetS{i}(j+1) = theta6; 
                        if i == 1
                            obj.thetaSetT{j}(1) = theta7;
                        end
                        
                        obj.thetaSetT{j}(i+1) = theta8;
                    end
                    
                    if abs(tDMat(i, j)) > 0
                    % Generate chord ribbon (生成弦带)
                    if strcmp(obj.Arrow, 'off')
                        tLine1 = bezierCurve([tPnt1; 0, 0; tPnt3], 200);
                        tLine2 = bezierCurve([tPnt2; 0, 0; tPnt4], 200);
                        tline3 = [cos(linspace(theta6, theta5, 100))', sin(linspace(theta6, theta5, 100))'];
                        tline4 = [cos(linspace(theta7, theta8, 100))', sin(linspace(theta7, theta8, 100))'];
                    else
                        tLine1 = bezierCurve([tPnt1; 0, 0; tPnt3.* 0.96], 200);
                        tLine2 = bezierCurve([tPnt2; 0, 0; tPnt4.* 0.96], 200);
                        tline3 = [cos(linspace(theta6, theta5, 100))', sin(linspace(theta6, theta5, 100))'];
                        tline4 = [cos(theta7) .* 0.96, sin(theta7) .* 0.96;
                                  cos((theta7 + theta8) / 2) .* 0.99, sin((theta7 + theta8) / 2) .* 0.99;
                                  cos(theta8) .* 0.96, sin(theta8) .* 0.96];
                    end
                    obj.chordMatHdl(i, j) = fill(obj.ax, [tLine1(:,1); tline4(:,1); tLine2(end:-1:1,1); tline3(:,1)], ...
                                                   [tLine1(:,2); tline4(:,2); tLine2(end:-1:1,2); tline3(:,2)], ...
                                                   tDMat(i, j), 'FaceAlpha', .3, 'EdgeColor', 'none', ...
                                                   'ButtonDownFcn', @obj.onChordClick, 'UserData', [i, j]);
                    end
                end
            end

            if ~strcmpi(obj.TickMode, 'linear')
                for i = 1:numS
                    if any(isnan(obj.thetaSetS{i}))
                        obj.thetaSetS{i} = [];
                    end
                end
                for j = 1:numT
                    if any(isnan(obj.thetaSetT{j}))
                        obj.thetaSetT{j} = [];
                    end
                end
            end

            % =============================================================
            % Draw tick marks based on mode (根据模式绘制刻度)
            % =============================================================
            obj.thetaTickSHdl = gobjects(1, numS);
            uniListS{numS} = [];
            for i = 1:numS
                switch lower(obj.TickMode)
                    case 'value'    % Value-based ticks (基于值的刻度)
                        obj.thetaSetS{i}(2:end) = obj.thetaSetS{i}(end:-1:2);
                        [obj.thetaSetS{i}, uniListS{i}] = unique(obj.thetaSetS{i}, 'stable');
                        
                        tX = [cos(obj.thetaSetS{i}) .* obj.TickRadius; cos(obj.thetaSetS{i}) .* (obj.TickRadius + .02); nan .* ones(1, length(obj.thetaSetS{i}))];
                        tY = [sin(obj.thetaSetS{i}) .* obj.TickRadius; sin(obj.thetaSetS{i}) .* (obj.TickRadius + .02); nan .* ones(1, length(obj.thetaSetS{i}))];
                        
                    case 'auto'     % Auto-adjust overlapping ticks (自动调整重叠刻度)
                        obj.thetaSetS{i}(2:end) = obj.thetaSetS{i}(end:-1:2);
                        [obj.thetaSetS{i}, uniListS{i}] = unique(obj.thetaSetS{i}, 'stable');
                        tTSF0 = obj.thetaSetS{i};
                        
                        for k = 1:3
                            tTSF1 = obj.thetaSetS{i};
                            tTSFA = abs(diff(tTSF1));
                            tTSFB = [inf, tTSFA] < mean(tTSFA)/2 | [tTSFA, inf] < mean(tTSFA)/2;
                            tTSF2 = linspace(tTSF1(1), tTSF1(end), length(tTSF1));
                            tTSFC = tTSF1;
                            tTSFC(tTSFB) = tTSF2(tTSFB);
                            tTSFC(tTSFC > tTSF1 + pi/30) = tTSF1(tTSFC > tTSF1 + pi/30) + pi/30;
                            tTSFC(tTSFC < tTSF1 - pi/30) = tTSF1(tTSFC < tTSF1 - pi/30) - pi/30;
                            obj.thetaSetS{i} = sort((2.*tTSF1 + tTSFC) ./ 3, 'descend');
                        end
                        
                        tX = [cos(tTSF0) .* obj.TickRadius; cos(tTSF0) .* (obj.TickRadius + 1/3*.02); ...
                              cos(obj.thetaSetS{i}) .* (obj.TickRadius + 2/3*.02); cos(obj.thetaSetS{i}) .* (obj.TickRadius + .02); ...
                              nan .* ones(1, length(obj.thetaSetS{i}))];
                        tY = [sin(tTSF0) .* obj.TickRadius; sin(tTSF0) .* (obj.TickRadius + 1/3*.02); ...
                              sin(obj.thetaSetS{i}) .* (obj.TickRadius + 2/3*.02); sin(obj.thetaSetS{i}) .* (obj.TickRadius + .02); ...
                              nan .* ones(1, length(obj.thetaSetS{i}))];
                        
                    case 'linear'   % Linear evenly-spaced ticks (线性等距刻度)
                        theta1 = 2*pi - pi*sep1/2 - sum(ratioS(1:i))   * baseLenF - (i-.5)*sepLen;
                        theta2 = 2*pi - pi*sep1/2 - sum(ratioS(1:i+1)) * baseLenF - (i-.5)*sepLen;
                        obj.thetaSetS{i} = (theta2 - theta1) ./ sum(tDMat(i, :)) .* (0:obj.LinearTickSep:sum(tDMat(i, :))) + theta1;
                        
                        if any(isnan(obj.thetaSetS{i}))
                            obj.thetaSetS{i} = [];
                        end

                        if strcmp(obj.LinearMinorTick, 'on')
                            tMTSF = (theta2 - theta1) ./ sum(tDMat(i, :)) .* (0:(obj.LinearTickSep/5):sum(tDMat(i, :))) + theta1;
                            tX = [cos(tMTSF) .* obj.TickRadius, cos(obj.thetaSetS{i}) .* obj.TickRadius; ...
                                  cos(tMTSF) .* (obj.TickRadius + .01), cos(obj.thetaSetS{i}) .* (obj.TickRadius + .02); ...
                                  nan .* ones(1, length([tMTSF, obj.thetaSetS{i}]))];
                            tY = [sin(tMTSF) .* obj.TickRadius, sin(obj.thetaSetS{i}) .* obj.TickRadius; ...
                                  sin(tMTSF) .* (obj.TickRadius + .01), sin(obj.thetaSetS{i}) .* (obj.TickRadius + .02); ...
                                  nan .* ones(1, length([tMTSF, obj.thetaSetS{i}]))];
                        else
                            tX = [cos(obj.thetaSetS{i}) .* obj.TickRadius; cos(obj.thetaSetS{i}) .* (obj.TickRadius + .02); nan .* ones(1, length(obj.thetaSetS{i}))];
                            tY = [sin(obj.thetaSetS{i}) .* obj.TickRadius; sin(obj.thetaSetS{i}) .* (obj.TickRadius + .02); nan .* ones(1, length(obj.thetaSetS{i}))];
                        end
                end
                if isempty(tX)
                    tX = nan(3, 1); tY = nan(3, 1);
                end
                obj.thetaTickSHdl(i) = plot(obj.ax, tX(:), tY(:), 'Color', [0, 0, 0], 'LineWidth', .8, 'Visible', 'off');
            end
            
            % Tick drawing for top blocks (上方块刻度绘制)
            obj.thetaTickTHdl = gobjects(1, numT);
            uniListT{numT} = [];
            for j = 1:numT
                switch lower(obj.TickMode)
                    case 'value'
                        obj.thetaSetT{j}(1:end) = obj.thetaSetT{j}(end:-1:1);
                        [obj.thetaSetT{j}, uniListT{j}] = unique(obj.thetaSetT{j}, 'stable');
                        
                        tX = [cos(obj.thetaSetT{j}) .* obj.TickRadius; cos(obj.thetaSetT{j}) .* (obj.TickRadius + .02); nan .* ones(1, length(obj.thetaSetT{j}))];
                        tY = [sin(obj.thetaSetT{j}) .* obj.TickRadius; sin(obj.thetaSetT{j}) .* (obj.TickRadius + .02); nan .* ones(1, length(obj.thetaSetT{j}))];
                        
                    case 'auto'
                        obj.thetaSetT{j}(1:end) = obj.thetaSetT{j}(end:-1:1);
                        [obj.thetaSetT{j}, uniListT{j}] = unique(obj.thetaSetT{j}, 'stable');
                        tTST0 = obj.thetaSetT{j};
                        
                        for k = 1:3
                            tTST1 = obj.thetaSetT{j};
                            tTSTA = abs(diff(tTST1));
                            tTSTB = [inf, tTSTA] < mean(tTSTA)/2 | [tTSTA, inf] < mean(tTSTA)/2;
                            tTST2 = linspace(tTST1(1), tTST1(end), length(tTST1));
                            tTSTC = tTST1;
                            tTSTC(tTSTB) = tTST2(tTSTB);
                            tTSTC(tTSTC > tTST1 + pi/30) = tTST1(tTSTC > tTST1 + pi/30) + pi/30;
                            tTSTC(tTSTC < tTST1 - pi/30) = tTST1(tTSTC < tTST1 - pi/30) - pi/30;
                            obj.thetaSetT{j} = (2.*tTST1 + tTSTC) ./ 3;
                        end
                        
                        tX = [cos(tTST0) .* obj.TickRadius; cos(tTST0) .* (obj.TickRadius + 1/3*.02); ...
                              cos(obj.thetaSetT{j}) .* (obj.TickRadius + 2/3*.02); cos(obj.thetaSetT{j}) .* (obj.TickRadius + .02); ...
                              nan .* ones(1, length(obj.thetaSetT{j}))];
                        tY = [sin(tTST0) .* obj.TickRadius; sin(tTST0) .* (obj.TickRadius + 1/3*.02); ...
                              sin(obj.thetaSetT{j}) .* (obj.TickRadius + 2/3*.02); sin(obj.thetaSetT{j}) .* (obj.TickRadius + .02); ...
                              nan .* ones(1, length(obj.thetaSetT{j}))];
                        
                    case 'linear'
                        theta3 = pi - pi*sep1/2 - sum(ratioT(1:j))   * baseLenT - (j-.5)*sepLen;
                        theta4 = pi - pi*sep1/2 - sum(ratioT(1:j+1)) * baseLenT - (j-.5)*sepLen;
                        obj.thetaSetT{j} = (theta4 - theta3) ./ sum(tDMat(:, j)) .* (0:obj.LinearTickSep:sum(tDMat(:, j))) + theta3;
                        
                        if any(isnan(obj.thetaSetT{j}))
                            obj.thetaSetT{j} = [];
                        end

                        if strcmp(obj.LinearMinorTick, 'on')
                            tMTST = (theta4 - theta3) ./ sum(tDMat(:, j)) .* (0:(obj.LinearTickSep/5):sum(tDMat(:, j))) + theta3;
                            tX = [cos(tMTST) .* obj.TickRadius, cos(obj.thetaSetT{j}) .* obj.TickRadius; ...
                                  cos(tMTST) .* (obj.TickRadius + .01), cos(obj.thetaSetT{j}) .* (obj.TickRadius + .02); ...
                                  nan .* ones(1, length([tMTST, obj.thetaSetT{j}]))];
                            tY = [sin(tMTST) .* obj.TickRadius sin(obj.thetaSetT{j}) .* obj.TickRadius; ...
                                  sin(tMTST) .* (obj.TickRadius + .01), sin(obj.thetaSetT{j}) .* (obj.TickRadius + .02); ...
                                  nan .* ones(1, length([tMTST, obj.thetaSetT{j}]))];
                        else
                            tX = [cos(obj.thetaSetT{j}) .* obj.TickRadius; cos(obj.thetaSetT{j}) .* (obj.TickRadius + .02); nan .* ones(1, length(obj.thetaSetT{j}))];
                            tY = [sin(obj.thetaSetT{j}) .* obj.TickRadius; sin(obj.thetaSetT{j}) .* (obj.TickRadius + .02); nan .* ones(1, length(obj.thetaSetT{j}))];
                        end
                end
                if isempty(tX)
                    tX = nan(3, 1); tY = nan(3, 1);
                end
                obj.thetaTickTHdl(j) = plot(obj.ax, tX(:), tY(:), 'Color', [0, 0, 0], 'LineWidth', .8, 'Visible', 'off');
            end

            % Apply label rotation (应用标签旋转)
            obj.labelRotate(obj.LabelRotate)

            % =============================================================
            % Add tick labels (添加刻度标签)
            % =============================================================
            obj.thetaTickLabelSHdl = gobjects(length(obj.thetaSetS), max(cellfun(@length, obj.thetaSetS)));
            for m = 1:length(obj.thetaSetS)
                if strcmpi(obj.TickMode, 'linear')
                    cumsumV = 0:obj.LinearTickSep:sum(tDMat(m, :));
                else
                    cumsumV = [0, cumsum(obj.dataMat(m, end:-1:1))];
                    cumsumV = cumsumV(uniListS{m});
                end
                
                for n = 1:length(obj.thetaSetS{m})
                    rotation = obj.thetaSetS{m}(n) / pi * 180;
                    
                    if rotation > 90 && rotation < 270
                        rotation = rotation + 180;
                        obj.thetaTickLabelSHdl(m, n) = text(obj.ax, ...
                            cos(obj.thetaSetS{m}(n)) .* (obj.TickRadius + .03), ...
                            sin(obj.thetaSetS{m}(n)) .* (obj.TickRadius + .03), num2str(cumsumV(n)), ...
                            'Rotation', rotation, 'HorizontalAlignment', 'right', ...
                            'FontSize', 9, 'FontName', 'Arial', 'Visible', 'off', 'UserData', cumsumV(n));
                    else
                        obj.thetaTickLabelSHdl(m, n) = text(obj.ax, ...
                            cos(obj.thetaSetS{m}(n)) .* (obj.TickRadius + .03), ...
                            sin(obj.thetaSetS{m}(n)) .* (obj.TickRadius + .03), num2str(cumsumV(n)), ...
                            'Rotation', rotation, 'FontSize', 9, 'FontName', 'Arial', ...
                            'Visible', 'off', 'UserData', cumsumV(n));
                    end
                end
            end
            
            obj.thetaTickLabelTHdl = gobjects(length(obj.thetaSetT), max(cellfun(@length, obj.thetaSetT)));
            for m = 1:length(obj.thetaSetT)
                if strcmpi(obj.TickMode, 'linear')
                    cumsumV = 0:obj.LinearTickSep:sum(tDMat(:, m));
                else
                    cumsumV = [0, cumsum(obj.dataMat(end:-1:1, m)).'];
                    cumsumV = cumsumV(uniListT{m});
                end
                
                for n = 1:length(obj.thetaSetT{m})
                    rotation = obj.thetaSetT{m}(n) / pi * 180;
                    
                    if rotation > 90 && rotation < 270
                        rotation = rotation + 180;
                        obj.thetaTickLabelTHdl(m, n) = text(obj.ax, ...
                            cos(obj.thetaSetT{m}(n)) .* (obj.TickRadius + .03), ...
                            sin(obj.thetaSetT{m}(n)) .* (obj.TickRadius + .03), num2str(cumsumV(n)), ...
                            'Rotation', rotation, 'HorizontalAlignment', 'right', ...
                            'FontSize', 9, 'FontName', 'Arial', 'Visible', 'off', 'UserData', cumsumV(n));
                    else
                        obj.thetaTickLabelTHdl(m, n) = text(obj.ax, ...
                            cos(obj.thetaSetT{m}(n)) .* (obj.TickRadius + .03), ...
                            sin(obj.thetaSetT{m}(n)) .* (obj.TickRadius + .03), num2str(cumsumV(n)), ...
                            'Rotation', rotation, 'FontSize', 9, 'FontName', 'Arial', ...
                            'Visible', 'off', 'UserData', cumsumV(n));
                    end
                end
            end

            % Nested Bezier curve function (嵌套贝塞尔曲线函数)
            function pnts = bezierCurve(pnts, N)
                t = linspace(0, 1, N);
                p = size(pnts, 1) - 1;
                coe1 = factorial(p) ./ factorial(0:p) ./ factorial(p:-1:0);
                coe2 = ((t) .^ ((0:p)')) .* ((1-t) .^ ((p:-1:0)'));
                pnts = (pnts' * (coe1' .* coe2))';
            end
            if nargout == 1
                varargout = {obj};
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
            %   connect m-th square bellow and n-th square above.
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
            %   CMat - Matrix of size [M, N, 1] or [M, N, 3] where,
            %       M = number of source nodes,
            %       N = number of target nodes. 
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
                    fColor = get(obj.squareSHdl(i), 'FaceColor');
                    eColor = get(obj.squareSHdl(i), 'EdgeColor');
                    obj.setChordMN(i,j, 'FaceColor',fColor, 'EdgeColor',eColor)
                end
            end
        end
        function setChordColorBySquareT(obj)
            % obj.setChordColorBySquareT() - Color each chord using its target block color (根据目标方块颜色为弦着色)
            for i = 1:size(obj.dataMat, 1)
                for j = 1:size(obj.dataMat, 2)
                    fColor = get(obj.squareTHdl(j), 'FaceColor');
                    eColor = get(obj.squareTHdl(j), 'EdgeColor');
                    obj.setChordMN(i,j, 'FaceColor',fColor, 'EdgeColor',eColor)
                end
            end
        end

% =========================================================================
% Square property settings (方块属性设置)
% =========================================================================
        function setSquareT(obj, varargin)
            % obj.setSquareT(varargin) - Target node square property settings (目标节点弧形块属性设置)
            %
            %   obj.setSquareT(___); Set properties for all squares above (target).
            %
            %   obj.setSquareT(n, ___); Set properties for n-th square above (target).
            %
            %   obj.setSquareT([n1, n2, ...], ___); Set properties for 
            %   multiple specified target squares (by their indices).
            %
            %   obj.setSquareT(Bool, ___); Set properties for target squares where the
            %   logical vector Bool (length = number of target squares) is true.
            if islogical(varargin{1})
                N = find(varargin{1});
                for n = 1:length(N)
                    set(obj.squareTHdl(N(n)), varargin{2:end});
                end
            elseif isnumeric(varargin{1})
                N = varargin{1};
                for n = 1:length(N)
                    set(obj.squareTHdl(N(n)), varargin{2:end});
                end
            else
                for j = 1:size(obj.dataMat, 2)
                    set(obj.squareTHdl(j), varargin{:});
                end
            end
        end

        function setSquareS(obj, varargin)
            % obj.setSquareS(varargin) - Source node square property settings (来源节点弧形块属性设置)
            %
            %   obj.setSquareS(___); Set properties for all squares below (source).
            %
            %   obj.setSquareS(n, ___); Set properties for n-th square below (source).
            %
            %   obj.setSquareS([n1, n2, ...], ___); Set properties for
            %   multiple specified source squares (by their indices).
            %
            %   obj.setSquareS(Bool, ___); Set properties for source squares where the
            %   logical vector Bool (length = number of source squares) is true.
            if islogical(varargin{1})
                N = find(varargin{1});
                for n = 1:length(N)
                    set(obj.squareSHdl(N(n)), varargin{2:end});
                end
            elseif isnumeric(varargin{1})
                N = varargin{1};
                for n = 1:length(N)
                    set(obj.squareSHdl(N(n)), varargin{2:end});
                end
            else
                for i = 1:size(obj.dataMat, 1)
                    set(obj.squareSHdl(i), varargin{:});
                end
            end
        end

        function setSubSquareT(obj, varargin)
            % obj.setSubSquareT(varargin) - Target sub-square property settings (目标子方块属性设置)
            %
            %   obj.setSubSquareT(___); Set properties for all target sub-squares.
            %
            %   obj.setSubSquareT(m, n, ___); Set properties for the m‑th sub‑square inside the n‑th target square.
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
            %   obj.setSubSquareS(m, n, ___); Set properties for the n‑th sub‑square inside the m‑th source square.
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

        function setSquareColorS(obj, FaceCList, EdgeCList)
            % obj.setSquareColorS(FaceCList, EdgeCList) - Set color for each source square (来源弧形块颜色设置)
            for i = 1:size(obj.dataMat, 1)
                obj.setSquareS_N(i, 'FaceColor', FaceCList(i,:))
                if nargin == 3
                    obj.setSquareS_N(i, 'EdgeColor', EdgeCList(i,:))
                end
            end
            for i = 1:size(obj.dataMat, 1)
                for j = 1:size(obj.dataMat, 2)
                    obj.setEachSquareT_Prop(i, j, 'FaceColor', FaceCList(i,:))
                    % if nargin == 3
                    %     obj.setEachSquareT_Prop(i, j, 'EdgeColor', EdgeCList(i,:))
                    % end
                end
            end
        end

        function setSquareColorT(obj, FaceCList, EdgeCList)
            % obj.setSquareColorT(FaceCList, EdgeCList) - Set color for each target square (目标弧形块颜色设置)
            for j = 1:size(obj.dataMat, 2)
                obj.setSquareT_N(j, 'FaceColor', FaceCList(j,:))
                if nargin == 3
                    obj.setSquareT_N(j, 'EdgeColor', EdgeCList(j,:))
                end
            end
            for i = 1:size(obj.dataMat, 1)
                for j = 1:size(obj.dataMat, 2)
                    obj.setEachSquareS_Prop(i,j, 'FaceColor', FaceCList(j,:))
                    % if nargin == 3
                    %     obj.setEachSquareS_Prop(i,j, 'EdgeColor', EdgeCList(j,:))
                    % end
                end
            end
        end

        function setSquareCDataS(obj, CVal)
            % obj.setSquareCDataS(CVal) - Set the 'CData' property of each source square (设置来源块的 CData 属性)  
            if isvector(CVal)
                CVal = CVal(:);
            end
            for i = 1:size(obj.dataMat, 1)
                obj.setSquareS_N(i, 'FaceColor', 'flat', 'CData', CVal(i, :, :))
            end
        end

        function setSquareCDataT(obj, CVal)
            % obj.setSquareCDataT(CVal) - Set the 'CData' property of each target square (设置目标块的 CData 属性)  
            if isvector(CVal)
                CVal = CVal(:);
            end
            for i = 1:size(obj.dataMat, 2)
                obj.setSquareT_N(i, 'FaceColor', 'flat', 'CData', CVal(i, :, :))
            end
        end

% =========================================================================
% Set labels (标签设置)
% =========================================================================
        function setFont(obj, varargin) 
            % obj.setFont(varargin) - Label property settings (标签属性设置)
            for i = 1:size(obj.dataMat, 1)
                set(obj.labelSHdl(i), varargin{:});
            end
            
            for j = 1:size(obj.dataMat, 2)
                set(obj.labelTHdl(j), varargin{:});
            end
        end

        function setFontColorS(obj, CList)
            % obj.setFontColorS(CList) - Source node label color settings (来源节点标签颜色设置)
            for i = 1:size(obj.dataMat, 1)
                set(obj.labelSHdl(i), 'Color',CList(i, :));
            end
        end
        function setFontColorT(obj, CList)
            % obj.setFontColorT(CList) - Target node label color settings (来源节点标签颜色设置)
            for j = 1:size(obj.dataMat, 2)
                set(obj.labelTHdl(j), 'Color',CList(j, :));
            end
        end

        function obj = setLabelRadius(obj, Radius)
            % obj.setLabelRadius(Radius) - Set label radius (设置标签半径)
            obj.LabelRadius = Radius;
            
            for i = 1:length(obj.meanThetaSetS)
                set(obj.labelSHdl(i), 'Position', [cos(obj.meanThetaSetS(i)), sin(obj.meanThetaSetS(i))] .* obj.LabelRadius);
            end
            
            for j = 1:length(obj.meanThetaSetT)
                set(obj.labelTHdl(j), 'Position', [cos(obj.meanThetaSetT(j)), sin(obj.meanThetaSetT(j))] .* obj.LabelRadius);
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
            
            for i = 1:length(obj.meanThetaSetS)
                set(obj.labelSHdl(i), 'Rotation', obj.rotationS(i), 'HorizontalAlignment', 'center');
            end
            
            for j = 1:length(obj.meanThetaSetT)
                set(obj.labelTHdl(j), 'Rotation', obj.rotationT(j), 'HorizontalAlignment', 'center');
            end
            
            if strcmpi(obj.LabelRotate, 'on')
                textHdl = findobj(obj.ax, 'Tag', 'ChordLabel');
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
                textHdl = findobj(gca, 'Tag','ChordLabel');
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
                set(obj.thetaTickSHdl(i), 'Visible', state);
                set(obj.RTickSHdl(i), 'Visible', state);
            end
            
            for j = 1:size(obj.dataMat, 2)
                set(obj.thetaTickTHdl(j), 'Visible', state);
                set(obj.RTickTHdl(j), 'Visible', state);
            end
        end

        
        
        function tickLabelState(obj, state)
            % obj.tickLabelState(state) - Show/hide tick labels (显示/隐藏刻度标签)
            for m = 1:length(obj.thetaSetS)
                for n = 1:length(obj.thetaSetS{m})
                    set(obj.thetaTickLabelSHdl(m, n), 'Visible', state)
                end
            end
            
            for m = 1:length(obj.thetaSetT)
                for n = 1:length(obj.thetaSetT{m})
                    set(obj.thetaTickLabelTHdl(m, n), 'Visible', state)
                end
            end
        end
        function setTick(obj, varargin)
            % obj.setTick(varargin) - Tick line property settings (刻度线属性设置)
            for i = 1:size(obj.dataMat, 1)
                set(obj.thetaTickSHdl(i), varargin{:});
                set(obj.RTickSHdl(i), varargin{:});
            end

            for j = 1:size(obj.dataMat, 2)
                set(obj.thetaTickTHdl(j), varargin{:});
                set(obj.RTickTHdl(j), varargin{:});
            end
        end

        function setTickFont(obj, varargin)
            % obj.setTickFont(varargin) - Tick label property settings (刻度标签属性设置)
            for m = 1:length(obj.thetaSetS)
                for n = 1:length(obj.thetaSetS{m})
                    set(obj.thetaTickLabelSHdl(m, n), varargin{:})
                end
            end

            for m = 1:length(obj.thetaSetT)
                for n = 1:length(obj.thetaSetT{m})
                    set(obj.thetaTickLabelTHdl(m, n), varargin{:})
                end
            end
        end
        
        function setTickLabelFormat(obj, func)
            % obj.setTickLabelFormat(func) - Set custom format for tick labels (设置刻度标签的自定义格式)
            for m = 1:length(obj.thetaSetS)
                for n = 1:length(obj.thetaSetS{m})
                    tStr = func(get(obj.thetaTickLabelSHdl(m, n), 'UserData'));
                    set(obj.thetaTickLabelSHdl(m, n), 'String', tStr)
                end
            end
            
            for m = 1:length(obj.thetaSetT)
                for n = 1:length(obj.thetaSetT{m})
                    tStr = func(get(obj.thetaTickLabelTHdl(m, n), 'UserData'));
                    set(obj.thetaTickLabelTHdl(m, n), 'String', tStr)
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
            tXS = round(round(tXS / 10^(tXN-2)) / 5) * 5 * 10^(tXN-2);
        end

        function tHdl = addHighlightArrow(obj, i, j, Color)
            % tHdl = obj.addHighlightArrow(i, j, Color) - Add highlight arrow indicator (添加高亮箭头指示器)
            if nargin < 4
                Color = [0,0,0];
            end
            tPnt1 = [cos(obj.iMidThetaSet(i, j)), sin(obj.iMidThetaSet(i, j))];
            tPnt2 = [cos(obj.jMidThetaSet(i, j)), sin(obj.jMidThetaSet(i, j))];
            tLine = bezierCurve([tPnt1; 0, 0; tPnt2.*.95], 200);
            tHdl.Line = plot(obj.ax, tLine(:,1), tLine(:,2), 'LineWidth', 1, 'Color', Color);

            tPnt3 = [cos(obj.jMidThetaSet(i, j) - pi/100) .* .95, sin(obj.jMidThetaSet(i, j) - pi/100) .* .95];
            tPnt4 = [cos(obj.jMidThetaSet(i, j) + pi/100) .* .95, sin(obj.jMidThetaSet(i, j) + pi/100) .* .95];
            tHdl.Arrow = fill(obj.ax, [tPnt2(1), tPnt3(1), tPnt4(1)], [tPnt2(2), tPnt3(2), tPnt4(2)], Color, 'EdgeColor',Color);

            function pnts = bezierCurve(pnts, N)
                t = linspace(0, 1, N);
                p = size(pnts, 1) - 1;
                coe1 = factorial(p) ./ factorial(0:p) ./ factorial(p:-1:0);
                coe2 = ((t) .^ ((0:p)')) .* ((1-t) .^ ((p:-1:0)'));
                pnts = (pnts' * (coe1' .* coe2))';
            end
        end

        function onChordClick(obj, src, event)
            % onChordClick - Chord click callback for data tips (弦点击回调：数据提示框)
            % Left click: show data tooltip (左键: 显示数据提示框)
            % Right click: hide highlight (右键: 隐藏高亮)
            if ~verLessThan('matlab', '9.7')
                if event.Button == 1
                    src.EdgeColor = obj.dataTipFormat{1};
                    src.LineWidth = 1;
                    datatip(src, event.IntersectionPoint(1), event.IntersectionPoint(2));
                    src.DataTipTemplate.DataTipRows(1) = dataTipTextRow(obj.dataTipFormat{2}, repmat(obj.RowName(src.UserData(1)), length(src.XData), 1));
                    src.DataTipTemplate.DataTipRows(2) = dataTipTextRow(obj.dataTipFormat{3}, repmat(obj.ColName(src.UserData(2)), length(src.XData), 1));
                    src.DataTipTemplate.DataTipRows(3) = dataTipTextRow(obj.dataTipFormat{4}, repmat(obj.dataMat(src.UserData(1), src.UserData(2)), [length(src.XData), 1]), obj.dataTipFormat{5});
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
        function setEachSquareT_Prop(obj, m, n, varargin)
            if isa(obj.squareTMatHdl(m, n), 'matlab.graphics.primitive.Patch')
                set(obj.squareTMatHdl(m, n), 'Visible', 'on', varargin{:})
            end
        end

        function setEachSquareF_Prop(obj, m, n, varargin)
            if isa(obj.squareSMatHdl(m, n), 'matlab.graphics.primitive.Patch')
                set(obj.squareSMatHdl(m, n), 'Visible', 'on', varargin{:})
            end
        end

        function setEachSquareS_Prop(obj, m, n, varargin)
            if isa(obj.squareSMatHdl(m, n), 'matlab.graphics.primitive.Patch')
                set(obj.squareSMatHdl(m, n), 'Visible', 'on', varargin{:})
            end
        end

        function setSquareColorF(obj, CList)
            for i = 1:size(obj.dataMat, 1)
                obj.setSquareF_N(i, 'FaceColor', CList(i,:))
            end
            for i = 1:size(obj.dataMat, 1)
                for j = 1:size(obj.dataMat, 2)
                    obj.setEachSquareT_Prop(i, j, 'FaceColor', CList(i,:))
                end
            end
        end

        function setSquareT_Prop(obj, varargin)
            % Batch top block property setting (批量上方方块属性设置)
            for j = 1:size(obj.dataMat, 2)
                set(obj.squareTHdl(j), varargin{:});
            end
        end
        function setSquareT_N(obj, n, varargin)
            % Individual top block property setting (单独上方方块属性设置)
            set(obj.squareTHdl(n), varargin{:});
        end

        function setSquareF_Prop(obj, varargin)
            % Batch bottom block property setting (批量下方方块属性设置)
            for i = 1:size(obj.dataMat, 1)
                set(obj.squareSHdl(i), varargin{:});
            end
        end
        function setSquareF_N(obj, n, varargin)
            % Individual bottom block property setting (单独下方方块属性设置)
            set(obj.squareSHdl(n), varargin{:});
        end

        function setSquareS_Prop(obj, varargin)
            % Batch bottom block property setting (批量下方方块属性设置)
            for i = 1:size(obj.dataMat, 1)
                set(obj.squareSHdl(i), varargin{:});
            end
        end
        function setSquareS_N(obj, n, varargin)
            % Individual bottom block property setting (单独下方方块属性设置)
            set(obj.squareSHdl(n), varargin{:});
        end


        function setChordProp(obj, varargin)
            % Batch chord property setting (批量弦属性设置)
            for i = 1:size(obj.dataMat, 1)
                for j = 1:size(obj.dataMat, 2)
                    if isa(obj.chordMatHdl(i, j), 'matlab.graphics.primitive.Patch')
                        set(obj.chordMatHdl(i, j), varargin{:});
                    end
                end
            end
        end
        function setChordColorBySquareF(obj)
            for i = 1:size(obj.dataMat, 1)
                for j = 1:size(obj.dataMat, 2)
                    tColor = get(obj.squareSHdl(i), 'FaceColor');
                    obj.setChordMN(i,j, 'FaceColor',tColor)
                end
            end
        end
        function setChordMN(obj, m, n, varargin)
            % Individual chord property setting (单独弦属性设置)
            if isa(obj.chordMatHdl(m, n), 'matlab.graphics.primitive.Patch')
                set(obj.chordMatHdl(m, n), varargin{:});
            end
        end
        function setChordColorByMap(obj, cmp)
            % obj.setChordColorByMap(cmp) - Set chord color using colormap (使用颜色映射设置弦颜色)
            tDMatUni = obj.dataMat - min(min(obj.dataMat));
            tDMatUni = tDMatUni ./ max(max(tDMatUni));

            colorFunc = colorFuncFactory(cmp);

            for i = 1:size(obj.dataMat, 1)
                for j = 1:size(obj.dataMat, 2)
                    if isa(obj.chordMatHdl(i, j), 'matlab.graphics.primitive.Patch')
                        set(obj.chordMatHdl(i, j), 'FaceColor', colorFunc(tDMatUni(i, j)));
                    end
                end
            end

            % Color interpolation function (颜色插值函数)
            function colorFunc = colorFuncFactory(colorList)
                x = (0:size(colorList, 1)-1) ./ (size(colorList, 1)-1);
                y1 = colorList(:, 1);
                y2 = colorList(:, 2);
                y3 = colorList(:, 3);
                colorFunc = @(X) [interp1(x, y1, X, 'linear')', ...
                    interp1(x, y2, X, 'linear')', ...
                    interp1(x, y3, X, 'linear')'];
            end
        end

        function setSquareF(obj, varargin)
            % setSquareF(___)       | Set properties for all squares bellow (source)
            % setSquareF(N, ___)    | Set properties for N-th square bellow (source)
            if isnumeric(varargin{1})
                set(obj.squareSHdl(varargin{1}), varargin{2:end});
            else
                for i = 1:size(obj.dataMat, 1)
                    set(obj.squareSHdl(i), varargin{:});
                end
            end
        end
    end
end


% =========================================================================
% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer
% -------------------------------------------------------------------------
% Zhaoxu Liu / slandarer (2026). chordChart (chord diagram | 弦图) 
% (https://www.mathworks.com/matlabcentral/fileexchange/116550-chordchart-chord-diagram), 
% MATLAB Central File Exchange. Retrieved April 14, 2026.
% =========================================================================