classdef biChordChart < handle
% biChordChart Create and customize bidirectional chord diagrams (有向弦图)
%   BCC = biChordChart(dataMat); creates a bidirectional chord diagram from
%   a square numerical matrix where element (i,j) represents flow from i to j.
%   从方阵数值矩阵创建有向弦图，元素 (i,j) 表示从 i 到 j 的流量。
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
%   + Added 'SSqRatio' property to adjust arc-shaped block ratio at chord ends
%     (可使用 SSqRatio 属性调整弦末端弧形块占比)
%   + Added 'OSqRatio' property to adjust original arc block ratio
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


    properties
        % Axes and configuration (坐标区与配置)
        ax                                                     % Axes handle (坐标区句柄)
        % Name-value pair list (名称-值对参数列表)
        arginList = {'Label','Sep','Arrow','CData','LRadius','LRotate',...
                     'SSqRatio','OSqRatio','Rotation','TickMode'}   
        
        % Data storage (数据存储)
        dataMat                                                % Numerical matrix (数值矩阵)
        Label = {}                                             % Node labels (节点标签)
        
        % Graphics handles - blocks (图形句柄 - 方块)
        squareHdl                                              % Block handles (方块句柄)
        squareFMatHdl                                          % Bottom split blocks (流入拆分方块)
        squareTMatHdl                                          % Top split blocks (流出拆分方块)

        % Graphics handles - text and chords (图形句柄 - 文本与弦)
        nameHdl                                                % Text handles (文本句柄)
        chordMatHdl                                            % Chord handles (弦句柄)
        
        % Tick configuration (刻度配置)
        thetaTickHdl                                           % Theta tick line handles (角度刻度线句柄)
        RTickHdl                                               % Radial tick line handles (径向刻度线句柄)
        TickMode = 'value'                                     % Tick mode: 'value'/'auto'/'linear' (刻度模式)
        thetaTickLabelHdl                                      % Theta tick label handles (角度刻度标签句柄)

        % Data tip configuration (数据提示框配置)
        % {color, srcLabel, tgtLabel, valLabel, format} (颜色、源标签、目标标签、数值标签、格式)
        dataTipFormat = {'k', 'Source:', 'Target:', 'Value:', 'auto'}   
        
        % Angular positions (角度位置) % read only
        thetaSet = []                                          % Angular positions for blocks (方块角度位置)
        meanThetaSet; iMidThetaSet; jMidThetaSet               % Midpoint angles (中点角度)
        rotationSet; thetaFullSet                              % Rotation angles and full theta set (旋转角度与完整角度集)

        % Layout parameters (布局参数)
        Sep                                                    % Gap between chord groups (弦组间隙)
        Arrow                                                  % Arrow mode: 'on'/'off' (箭头模式)
        CData                                                  % Color data (颜色数据)
        Group                                                  % Group assignment for nodes (节点分组)
        GroupSep                                               % Gap between groups (组间间隙)

        % Appearance parameters (外观参数)
        LRadius = 1.28                                         % Label radius (标签半径)
        LRotate = 'off'                                        % Label rotation mode (标签旋转模式)
        SSqRatio = 0                                           % Square ratio at chord ends (弦末端方块比例)
        OSqRatio = 1                                           % Original arc block ratio (原始弧形块比例)
        Rotation = 0                                           % Global rotation angle (全局旋转角度)
        
        % Linear tick parameters (线性刻度参数)
        linearTickSep                                          % Linear tick spacing (线性刻度间隔)
        linearTickCompactDegree = 3.5                          % Linear tick compact degree (线性刻度紧密程度)
        linearMinorTick = 'off'                                % Minor tick mode (次刻度线模式)
    end

    methods
        function obj=biChordChart(varargin)
            obj.Sep=1/10;
            obj.GroupSep = 1/15;
            obj.Arrow='off';
            obj.CData=[127,91,93;187,128,110;197,173,143;59,71,111;104,95,126;76,103,86;112,112,124;
                72,39,24;197,119,106;160,126,88;238,208,146]./255;
            if isa(varargin{1},'matlab.graphics.axis.Axes')
                obj.ax=varargin{1};varargin(1)=[];
            else
                obj.ax=gca;
            end  
            obj.ax.NextPlot='add';
            obj.dataMat=varargin{1};varargin(1)=[];
            obj.Group = ones(1, size(obj.dataMat, 2));
            % 获取其他数据
            for i=1:2:(length(varargin)-1)
                tid=ismember(lower(obj.arginList), lower(varargin{i}));
                if any(tid)
                obj.(obj.arginList{tid})=varargin{i+1};
                end
            end
            % 名称标签预设
            if isempty(obj.Label)||length(obj.Label)<size(obj.dataMat,1)
                obj.Label = compose('C%d', 1:size(obj.dataMat, 1));
            end
            % 调整不合理间隙
            if obj.Sep>1/2
                obj.Sep=1/2;
            end
            if obj.GroupSep>1/2
                obj.GroupSep=1/2;
            end
            % 调整颜色数量
            if size(obj.CData,1)<size(obj.dataMat,1)
                obj.CData=[obj.CData;rand([size(obj.dataMat,1),3]).*.5+ones([size(obj.dataMat,1),3]).*.5];
            end
            % 调整对角线
            for i=1:size(obj.dataMat,1)
                obj.dataMat(i,i)=abs(obj.dataMat(i,i));
            end
            % 调整标签间距
            if obj.LRadius>2||obj.LRadius<1.2
                obj.LRadius=1.28;
            end
            % help biChordChart
        end

        function obj=draw(obj)
            obj.ax.XLim=[-1.38,1.38];
            obj.ax.YLim=[-1.38,1.38];
            obj.ax.XTick=[];
            obj.ax.YTick=[];
            obj.ax.XColor='none';
            obj.ax.YColor='none';
            obj.ax.PlotBoxAspectRatio=[1,1,1];
            % 计算比例
            if length(obj.Group) < size(obj.dataMat, 1)
                obj.Group = ones(1, size(obj.dataMat, 2));
            end
            
            tGroup = groupConsecutive(obj.Group);
            groupNum = max(tGroup) - (obj.Group(end) == obj.Group(1));
            

            numC=size(obj.dataMat,1);
            ratioC1=sum(abs(obj.dataMat),2)./sum(sum(abs(obj.dataMat)));
            ratioC2=sum(abs(obj.dataMat),1)./sum(sum(abs(obj.dataMat)));
            ratioC=(ratioC1'+ratioC2)./2;
            ratioC=[0,ratioC];

            % version 2.0.0 更新部分
            obj.linearTickSep = obj.getTick(sum(sum(obj.dataMat))./(size(obj.dataMat,1)+size(obj.dataMat,2)).*2, obj.linearTickCompactDegree);
            
            if groupNum == 0
                gsepLen = 0;
                sepLen = (2*pi*obj.Sep)./numC;
                baseLen = 2*pi*(1-obj.Sep);
            else
                gsepLen = (2*pi*obj.GroupSep)./groupNum;
                sepLen = (2*pi*obj.Sep*(1 - obj.GroupSep))./numC;
                baseLen = 2*pi*(1 - obj.Sep)*(1 - obj.GroupSep);
            end

            if length(obj.Rotation) < 2
                obj.Rotation = repmat(obj.Rotation, [numC,1]);
            end

            % 绘制方块
            for i=1:numC
                theta1 = sum(ratioC(1:i))*baseLen + (i - 1 + .5)*sepLen + obj.Rotation(i) + (tGroup(i) - 1 + .5)*gsepLen;
                theta2 = sum(ratioC(1:i+1))*baseLen + (i - 1 + .5)*sepLen + obj.Rotation(i) + (tGroup(i) - 1 + .5)*gsepLen;
                diffTheta(i) = theta2 - theta1;
                if abs(obj.Rotation(1) - obj.Rotation(2))>eps
                    theta1=obj.Rotation(i) - diffTheta(i)/2;
                    theta2=obj.Rotation(i) + diffTheta(i)/2;
                end
                theta=linspace(theta1,theta2,100);
                X=cos(theta);Y=sin(theta);
                obj.squareHdl(i)=fill(obj.ax, [(1.15-.1*obj.OSqRatio).*X,1.15.*X(end:-1:1)],[(1.15-.1*obj.OSqRatio).*Y,1.15.*Y(end:-1:1)],...
                    obj.CData(i,:),'EdgeColor','none');
                theta3=mod((theta1+theta2)/2,2*pi);
                obj.meanThetaSet(i)=theta3;
                rotation=theta3/pi*180;
                if rotation>0&&rotation<180
                    obj.nameHdl(i)=text(obj.ax, cos(theta3).*obj.LRadius,sin(theta3).*obj.LRadius,obj.Label{i},'FontSize',14,'FontName','Arial',...
                    'HorizontalAlignment','center','Rotation',-(.5*pi-theta3)./pi.*180,'Tag','BiChordLabel');
                    obj.rotationSet(i)=-(.5*pi-theta3)./pi.*180;
                else
                    obj.nameHdl(i)=text(obj.ax, cos(theta3).*obj.LRadius,sin(theta3).*obj.LRadius,obj.Label{i},'FontSize',14,'FontName','Arial',...
                    'HorizontalAlignment','center','Rotation',-(1.5*pi-theta3)./pi.*180,'Tag','BiChordLabel');
                    obj.rotationSet(i)=-(1.5*pi-theta3)./pi.*180;
                end
                obj.RTickHdl(i)=plot(obj.ax, cos(theta).*1.17,sin(theta).*1.17,'Color',[0,0,0],'LineWidth',.8,'Visible','off');
            end

            for i=1:numC
                for j=1:numC
                    theta_i_1 = sum(ratioC(1:i))*baseLen + (i - 1 + .5)*sepLen + (tGroup(i) - 1 + .5)*gsepLen;
                    theta_i_2 = sum(ratioC(1:i+1))*baseLen + (i - 1 + .5)*sepLen + (tGroup(i) - 1 + .5)*gsepLen;
                    theta_i_3=theta_i_1+(theta_i_2-theta_i_1).*sum(abs(obj.dataMat(:,i)))./(sum(abs(obj.dataMat(:,i)))+sum(abs(obj.dataMat(i,:))));
                    
                    theta_j_1 = sum(ratioC(1:j))*baseLen + (j - 1 + .5)*sepLen + (tGroup(j) - 1 + .5)*gsepLen;
                    theta_j_2 = sum(ratioC(1:j+1))*baseLen + (j - 1 + .5)*sepLen + (tGroup(j) - 1 + .5)*gsepLen;
                    theta_j_3 = theta_j_1+(theta_j_2-theta_j_1).*sum(abs(obj.dataMat(:,j)))./(sum(abs(obj.dataMat(:,j)))+sum(abs(obj.dataMat(j,:))));

                    ratio_i_1=obj.dataMat(i,:);ratio_i_1=[0,ratio_i_1./sum(ratio_i_1)];
                    ratio_j_2=obj.dataMat(:,j)';ratio_j_2=[0,ratio_j_2./sum(ratio_j_2)];
                    if true
                        theta1=theta_i_2+(theta_i_3-theta_i_2).*sum(ratio_i_1(1:j))  + obj.Rotation(i);
                        theta2=theta_i_2+(theta_i_3-theta_i_2).*sum(ratio_i_1(1:j+1))  + obj.Rotation(i);
                        theta3=theta_j_3+(theta_j_1-theta_j_3).*sum(ratio_j_2(1:i))  + obj.Rotation(j);
                        theta4=theta_j_3+(theta_j_1-theta_j_3).*sum(ratio_j_2(1:i+1))  + obj.Rotation(j);
                        if abs(obj.Rotation(1) - obj.Rotation(2))>eps
                            theta1=theta1 - diffTheta(i)/2 - theta_i_1;
                            theta2=theta2 - diffTheta(i)/2 - theta_i_1;
                            theta3=theta3 - diffTheta(j)/2 - theta_j_1;
                            theta4=theta4 - diffTheta(j)/2 - theta_j_1;
                        end


                        tPnt1=[cos(theta1),sin(theta1)];
                        tPnt2=[cos(theta2),sin(theta2)];
                        tPnt3=[cos(theta3),sin(theta3)];
                        tPnt4=[cos(theta4),sin(theta4)];
                        obj.thetaFullSet{i}(j)=theta1;
                        obj.thetaFullSet{i}(j+1)=theta2;
                        obj.thetaFullSet{j}(i+numC)=theta3;
                        obj.thetaFullSet{j}(i+numC+1)=theta4;
                        obj.iMidThetaSet(i, j) = (theta1 + theta2)./2;
                        obj.jMidThetaSet(i, j) = (theta3 + theta4)./2;

                        if strcmp(obj.Arrow,'off')
                            % 计算贝塞尔曲线
                            tLine1=bezierCurve([tPnt1;0,0;tPnt4],200);
                            tLine2=bezierCurve([tPnt2;0,0;tPnt3],200);
                            tline3=[cos(linspace(theta2,theta1,100))',sin(linspace(theta2,theta1,100))'];
                            tline4=[cos(linspace(theta4,theta3,100))',sin(linspace(theta4,theta3,100))'];
                        else
                            % 计算贝塞尔曲线
                            tLine1=bezierCurve([tPnt1;0,0;tPnt4.*.96],200);
                            tLine2=bezierCurve([tPnt2;0,0;tPnt3.*.96],200);
                            tline3=[cos(linspace(theta2,theta1,100))',sin(linspace(theta2,theta1,100))'];
                            tline4=[cos(theta4).*.96,sin(theta4).*.96;
                                cos(theta3/2+theta4/2).*.99,sin(theta3/2+theta4/2).*.99;
                                cos(theta3).*.96,sin(theta3).*.96];
                        end
                        obj.chordMatHdl(i,j)=fill(obj.ax, [tLine1(:,1);tline4(:,1);tLine2(end:-1:1,1);tline3(:,1)],...
                            [tLine1(:,2);tline4(:,2);tLine2(end:-1:1,2);tline3(:,2)],...
                            obj.CData(i,:),'FaceAlpha',.3,'EdgeColor','none', 'UserData',[i,j], 'ButtonDownFcn', @obj.onChordClick);
                        XF=cos(linspace(theta1,theta2,100));YF=sin(linspace(theta1,theta2,100));
                        XT=cos(linspace(theta3,theta4,100));YT=sin(linspace(theta3,theta4,100));
                        obj.squareFMatHdl(i,j)=fill(obj.ax, [1.05.*XF,(1.05+obj.SSqRatio*.1).*XF(end:-1:1)],[1.05.*YF,(1.05+obj.SSqRatio*.1).*YF(end:-1:1)],...
                            obj.CData(j,:),'EdgeColor','none');
                        obj.squareTMatHdl(i,j)=fill(obj.ax, [1.05.*XT,(1.05+obj.SSqRatio*.1).*XT(end:-1:1)],[1.05.*YT,(1.05+obj.SSqRatio*.1).*YT(end:-1:1)],...
                            obj.CData(i,:),'EdgeColor','none');
                    else
                    end
                end
            end
            for i = 1:numC
                tTFS = obj.thetaFullSet{i};
                isNANListF{i} = isnan(tTFS);
                obj.thetaFullSet{i} = tTFS(~isNANListF{i});
            end
            % #############################################################
            % version 2.0.0 更新部分
            % 绘制刻度线
            for i = 1:numC
                [obj.thetaFullSet{i}, uniListF{i}] = unique(obj.thetaFullSet{i}, 'stable');
            end
            switch lower(obj.TickMode)
                case 'value'
                    tickX = [cos([obj.thetaFullSet{:}]).*1.17; cos([obj.thetaFullSet{:}]).*1.19; nan.*[obj.thetaFullSet{:}]];
                    tickY = [sin([obj.thetaFullSet{:}]).*1.17; sin([obj.thetaFullSet{:}]).*1.19; nan.*[obj.thetaFullSet{:}]];
                case 'auto'
                    for i = 1:numC
                        tTFS0{i} = obj.thetaFullSet{i};
                        for k = 1:3
                            tTFS1{i} = obj.thetaFullSet{i};
                            tTFSA = abs(diff(tTFS1{i}));
                            tTFSB = [inf, tTFSA] < mean(tTFSA)/2 | [tTFSA, inf] < mean(tTFSA)/2;
                            if ~isempty(tTFS1{i})
                                tTFS2 = linspace(tTFS1{i}(1), tTFS1{i}(end), length(tTFS1{i}));
                                tTFSC = tTFS1{i}; tTFSC(tTFSB) = tTFS2(tTFSB);
                                tTFSC(tTFSC > tTFS1{i} + pi/30) = tTFS1{i}(tTFSC > tTFS1{i} + pi/30) + pi/30;
                                tTFSC(tTFSC < tTFS1{i} - pi/30) = tTFS1{i}(tTFSC < tTFS1{i} - pi/30) - pi/30;
                                obj.thetaFullSet{i} = sort((2.*tTFS1{i} + tTFSC)./3, 'descend');
                            end
                        end
                    end
                    
                    tickX = [cos([tTFS0{:}]).*1.17; cos([tTFS0{:}]).*(1.17 + 1/3*.02); cos([obj.thetaFullSet{:}]).*(1.17 + 2/3*.02); cos([obj.thetaFullSet{:}]).*1.19; nan.*[obj.thetaFullSet{:}]];
                    tickY = [sin([tTFS0{:}]).*1.17; sin([tTFS0{:}]).*(1.17 + 1/3*.02); sin([obj.thetaFullSet{:}]).*(1.17 + 2/3*.02); sin([obj.thetaFullSet{:}]).*1.19; nan.*[obj.thetaFullSet{:}]];
                case 'linear'
                    for i = 1:numC
                        tTFS = obj.thetaFullSet{i};
                        if ~isempty(tTFS)
                            obj.thetaFullSet{i} = (tTFS(end) - tTFS(1))./(sum(obj.dataMat(i,:)) + sum(obj.dataMat(:,i))).*(0:obj.linearTickSep:(sum(obj.dataMat(i,:)) + sum(obj.dataMat(:,i)))) + tTFS(1);
                            tMTFS{i} = (tTFS(end) - tTFS(1))./(sum(obj.dataMat(i,:)) + sum(obj.dataMat(:,i))).*(0:obj.linearTickSep/5:(sum(obj.dataMat(i,:)) + sum(obj.dataMat(:,i)))) + tTFS(1);

                        else
                            tMTFS{i}=[];
                        end
                    end
                    if strcmp(obj.linearMinorTick, 'on')
                        tickX = [cos([tMTFS{:}]).*1.17, cos([obj.thetaFullSet{:}]).*1.17; cos([tMTFS{:}]).*1.18, cos([obj.thetaFullSet{:}]).*1.19; nan.*[[obj.thetaFullSet{:}],[tMTFS{:}]]];
                        tickY = [sin([tMTFS{:}]).*1.17, sin([obj.thetaFullSet{:}]).*1.17; sin([tMTFS{:}]).*1.18, sin([obj.thetaFullSet{:}]).*1.19; nan.*[[obj.thetaFullSet{:}],[tMTFS{:}]]];
                    else
                        tickX = [cos([obj.thetaFullSet{:}]).*1.17; cos([obj.thetaFullSet{:}]).*1.19; nan.*[obj.thetaFullSet{:}]];
                        tickY = [sin([obj.thetaFullSet{:}]).*1.17; sin([obj.thetaFullSet{:}]).*1.19; nan.*[obj.thetaFullSet{:}]];
                    end
            end
            obj.thetaTickHdl = plot(obj.ax, tickX(:),tickY(:), 'Color',[0,0,0], 'LineWidth',.8, 'Visible','off');
            % #############################################################


            % version 1.1.0 更新部分
            for i=1:numC          
                if strcmpi(obj.TickMode,'linear')
                    cumsumV=0:obj.linearTickSep:(sum(obj.dataMat(i,:)) + sum(obj.dataMat(:,i)));
                else
                    cumsumV=[0,cumsum([obj.dataMat(i,:),obj.dataMat(:,i).'])];
                    cumsumV=cumsumV(~isNANListF{i});
                    cumsumV=cumsumV(uniListF{i});
                end
                for j=1:length(obj.thetaFullSet{i})
                    rotation=mod(obj.thetaFullSet{i}(j)/pi*180,360);
                    if ~isnan(obj.thetaFullSet{i}(j))
                    if rotation>90&&rotation<270
                        rotation=rotation+180;
                        obj.thetaTickLabelHdl(i,j)=text(obj.ax, cos(obj.thetaFullSet{i}(j)).*1.2,sin(obj.thetaFullSet{i}(j)).*1.2,num2str(cumsumV(j)),...
                            'Rotation',rotation,'HorizontalAlignment','right','FontSize',9,'FontName','Arial','Visible','off','UserData',cumsumV(j));
                    else
                        obj.thetaTickLabelHdl(i,j)=text(obj.ax, cos(obj.thetaFullSet{i}(j)).*1.2,sin(obj.thetaFullSet{i}(j)).*1.2,num2str(cumsumV(j)),...
                            'Rotation',rotation,'FontSize',9,'FontName','Arial','Visible','off','UserData',cumsumV(j));
                    end
                    end
                end
            end

            % 贝塞尔函数
            function pnts=bezierCurve(pnts,N)
                t=linspace(0,1,N);
                p=size(pnts,1)-1;
                coe1=factorial(p)./factorial(0:p)./factorial(p:-1:0);
                coe2=((t).^((0:p)')).*((1-t).^((p:-1:0)'));
                pnts=(pnts'*(coe1'.*coe2))';
            end
            function group_id = groupConsecutive(arr)
                if isempty(arr)
                    group_id = [];
                    return;
                end
                group_id = ones(size(arr));
                current_group = 1;
                for ind = 2:length(arr)
                    if arr(ind) ~= arr(ind-1)
                        current_group = current_group + 1;
                    end
                    group_id(ind) = current_group;
                end
            end

            obj.labelRotate(obj.LRotate)
        end
        % -----------------------------------------------------------------
        % 方块属性设置
        function setSquareN(obj,n,varargin)
            set(obj.squareHdl(n),varargin{:});
        end
        % 单独设置每一个弦末端方块
        function setEachSquareT_Prop(obj,m,n,varargin)
            set(obj.squareTMatHdl(m,n),'Visible','on',varargin{:})
        end
        function setEachSquareF_Prop(obj,m,n,varargin)
            set(obj.squareFMatHdl(m,n),'Visible','on',varargin{:})
        end
        % -----------------------------------------------------------------
        % 批量弦属性设置
        function setChordN(obj,n,varargin)
            for i=n
                for j=1:size(obj.dataMat,2)
                    set(obj.chordMatHdl(i,j),varargin{:});
                end
            end
        end
        % -----------------------------------------------------------------
        % 单独弦属性设置
        function setChordMN(obj,m,n,varargin)
            set(obj.chordMatHdl(m,n),varargin{:});
        end
        % -----------------------------------------------------------------
        % 字体设置
        function setFont(obj,varargin)
            for i=1:size(obj.dataMat,1)
                set(obj.nameHdl(i),varargin{:});
            end
        end
        function setFontN(obj,n,varargin)
                set(obj.nameHdl(n),varargin{:});
        end
        function setTickFont(obj,varargin)
            for m=1:length(obj.thetaFullSet)
                for n=1:length(obj.thetaFullSet{m})
                    if obj.thetaTickLabelHdl(m,n)
                        set(obj.thetaTickLabelHdl(m,n),varargin{:})
                    end
                end
            end
        end
        % version 1.1.0 更新部分
        % 标签文字距离设置
        function obj=setLabelRadius(obj,Radius)
            obj.LRadius=Radius;
            for i=1:size(obj.dataMat,1)
                set(obj.nameHdl(i),'Position',[cos(obj.meanThetaSet(i)),sin(obj.meanThetaSet(i))].*obj.LRadius);
            end
        end
        % version 1.1.0 更新部分
        % 标签旋转状态设置
        function labelRotate(obj, Rotate)
            obj.LRotate=Rotate;
            for i=1:size(obj.dataMat,1)
                set(obj.nameHdl(i),'HorizontalAlignment','center','Rotation',obj.rotationSet(i))
            end
            if isequal(obj.LRotate,'on')
            textHdl=findobj(obj.ax,'Tag','BiChordLabel');
            for i=1:length(textHdl)
                if textHdl(i).Rotation<-90
                    textHdl(i).Rotation=textHdl(i).Rotation+180;
                end
                switch true
                    case textHdl(i).Rotation<0&&textHdl(i).Position(2)>0
                        textHdl(i).Rotation=textHdl(i).Rotation+90;
                        textHdl(i).HorizontalAlignment='left';
                    case textHdl(i).Rotation>=0&&textHdl(i).Position(2)>0
                        textHdl(i).Rotation=textHdl(i).Rotation-90;
                        textHdl(i).HorizontalAlignment='right';
                    case textHdl(i).Rotation<0&&textHdl(i).Position(2)<=0
                        textHdl(i).Rotation=textHdl(i).Rotation+90;
                        textHdl(i).HorizontalAlignment='right';
                    case textHdl(i).Rotation>=0&&textHdl(i).Position(2)<=0
                        textHdl(i).Rotation=textHdl(i).Rotation-90;
                        textHdl(i).HorizontalAlignment='left';
                end
            end
            end
        end
        % -----------------------------------------------------------------
        % 刻度开关
        function tickState(obj,state)
            for i=1:size(obj.dataMat,1)
                set(obj.RTickHdl(i),'Visible',state);
            end
            set(obj.thetaTickHdl,'Visible',state);
        end
        % version 1.1.0 更新部分
        function tickLabelState(obj,state)
            for m=1:length(obj.thetaFullSet)
                for n=1:length(obj.thetaFullSet{m})
                    if obj.thetaTickLabelHdl(m,n)
                    if ~(n<length(obj.thetaFullSet{m})&&abs(obj.thetaFullSet{m}(n)-obj.thetaFullSet{m}(n+1))<eps)
                    set(obj.thetaTickLabelHdl(m,n),'Visible',state)
                    end
                    end
                end
            end
        end
        function setTickLabelFormat(obj,func)
            for m=1:length(obj.thetaFullSet)
                for n=1:length(obj.thetaFullSet{m})
                    if obj.thetaTickLabelHdl(m,n)
                    tStr=func(get(obj.thetaTickLabelHdl(m,n),'UserData'));
                    set(obj.thetaTickLabelHdl(m,n),'String',tStr)
                    end
                end
            end
        end
        % -----------------------------------------------------------------
        % 功能函数
        function tXS = getTick(~, Len, N)
            tXS = Len / N;
            tXN = ceil(log(tXS) / log(10));
            tXS = round(round(tXS / 10^(tXN-2)) / 5) * 5 * 10^(tXN-2);
        end
        function tHdl = addHighlightArrow(obj, i, j)
            tPnt1 = [cos(obj.iMidThetaSet(i, j)), sin(obj.iMidThetaSet(i, j))];
            tPnt2 = [cos(obj.jMidThetaSet(i, j)), sin(obj.jMidThetaSet(i, j))];
            tLine = bezierCurve([tPnt1;0,0;tPnt2],200);
            tHdl.Line = plot(obj.ax, tLine(:,1), tLine(:,2), 'LineWidth',1, 'Color',[0,0,0]);

            tPnt3 = [cos(obj.jMidThetaSet(i, j) - pi/100).*.95, sin(obj.jMidThetaSet(i, j) - pi/100).*.95];
            tPnt4 = [cos(obj.jMidThetaSet(i, j) + pi/100).*.95, sin(obj.jMidThetaSet(i, j) + pi/100).*.95];
            tHdl.Arrow = fill(obj.ax, [tPnt2(1), tPnt3(1), tPnt4(1)], [tPnt2(2), tPnt3(2), tPnt4(2)], [0,0,0]);

            function pnts=bezierCurve(pnts,N)
                t=linspace(0,1,N);
                p=size(pnts,1)-1;
                coe1=factorial(p)./factorial(0:p)./factorial(p:-1:0);
                coe2=((t).^((0:p)')).*((1-t).^((p:-1:0)'));
                pnts=(pnts'*(coe1'.*coe2))';
            end
        end
        function onChordClick(obj, src, event)
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
                dataTipTextRow(obj.dataTipFormat{4}, repmat(obj.dataMat(src.UserData(1),src.UserData(2)), ...
                [length(src.XData), 1]), obj.dataTipFormat{5});
            else
                src.EdgeColor = 'none';
                src.LineWidth = 0.5;
            end
            end
        end
    end
% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer
% -------------------------------------------------------------------------
% Zhaoxu Liu / slandarer (2026). biChordChart (bidirectional chord diagram | 有向弦图) 
% (https://www.mathworks.com/matlabcentral/fileexchange/121043-bichordchart-bidirectional-chord-diagram), 
% MATLAB Central File Exchange. Retrieved April 14, 2026.
end
