# 绘制效果(Cover)

![](gallery/cover6.png)

![](gallery/demo10.png)

![](gallery/demo16.png)


___
# 详细教程(User Guide)
## 1 数据格式 (Data format)
数据应准备全是非负数值的方形矩阵，矩阵第 i 行第 j 列表示由节点 i 流向节点 j ，第 j 行第 i 列表示由节点 j 流向节点 i，也就是说矩阵是非对称的，可以同时统计两个节点互相的数据流动,这里构造个随机数矩阵：

The data should be prepared as a square matrix consisting entirely of non-negative values. The element at the i-th row and j-th column of the matrix represents the flow from node i to node j, while the element at the j-th row and i-th column represents the flow from node j to node i. In other words, the matrix is ​​asymmetric, allowing for the simultaneous tracking of data flows in both directions between any two nodes. Here, we construct a random matrix for this purpose:
```matlab
dataMat = randi([0, 8], [6, 6]);

BCC = biChordChart(dataMat);
BCC = BCC.draw(); 
```
![](gallery/1.png)

### 方向箭头(Directional arrow)
这部分本来应该放在弦修饰部分，但是为了方便信息展示提前到这里:

This section is normally placed under chord decoration, but is moved here for better illustration.

两侧都是弧形仅仅靠颜色不容易区分流入还是流出，因此可在创建对象时将 `Arrow` 属性设置为 `'on'` ：

Since both ends are curved, it is difficult to distinguish between inflow and outflow based solely on color; therefore, you can set the `Arrow` property to `'on'` when creating the object:
```matlab
dataMat = randi([0, 8], [6, 6]);

BCC = biChordChart(dataMat, 'Arrow','on');
BCC = BCC.draw(); 
```
![](gallery/2.png)

### 数值矩阵+元胞数组标签 (Numeric matrix with cell arrays for labels)
```
dataMat = randi([0,8], [6,6]);
nameList = {'AAA','BBB','CCC','DDD','EEE','FFF'};

BCC = biChordChart(dataMat, 'Arrow','on', 'Label',nameList);
BCC = BCC.draw();
```
![](gallery/1_2.png)
___
## 2 颜色的设置(Set color)

可在 `obj.draw()` 绘图之前设置 `CData` 属性修改颜色，例如：

You can modify the color by setting the `CData` property before calling `obj.draw()`, for example:
```matlab
dataMat = randi([0, 8], [6, 6]);

ColorList = [127,91,93;153,66,83;95,127,95;9,14,10;78,70,83;0,0,0]./255;
BCC = biChordChart(dataMat, 'Arrow','on', 'CData',ColorList);
BCC = BCC.draw();
```
![](gallery/5.png)
```matlab
dataMat = randi([0, 8], [6, 6]);

BCC = biChordChart(dataMat, 'Arrow','on', 'CData',bone(9));
BCC = BCC.draw();
```
![](gallery/6.png)

值得一提的是如果 `CData` 设置为空集，则会随机生成颜色：

It is worth noting that if `CData` is set to an empty set, colors will be generated randomly.
```matlab
dataMat = randi([0,8],[6,6]);

BCC = biChordChart(dataMat, 'Arrow','on', 'CData',[]);
BCC = BCC.draw();
```

![](gallery/7.png)

![](gallery/8.png)
___
## 3 方块修饰 (Square decoration)
### 方块批量修饰 (Batch modification of squares)
使用 `obj.setSquare(___)` 函数进行修饰，一切 Patch 对象所具有的属性均可以被修饰，举个例子：全部方块添加黑色边缘：

The `obj.setSquare(___)` function can be used to modify the appearance of squares. Any property valid for a Patch object is applicable. For instance, to add a black edge to all squares:
```matlab
BCC.setSquare('EdgeColor','k', 'LineWidth',10)
```
![](gallery/15.png)

使用`obj.setSquare(n, ___)`函数单独对方块 n 进行修饰：

Use the `obj.setSquare(n, ___)` function to modify square n individually:
```matlab
BCC.setSquare(1, 'EdgeColor',[0,0,.8])
% BCC.setSquare([1, 3], 'EdgeColor',[0,0,.8])
```
![](gallery/15_2.png)
使用`obj.setSquareColor(___)`函数可以仅设置方块颜色而不修改弦颜色：

Use `obj.setSquareColor(___)` to set only the square colors without affecting the chord colors.
```matlab
BCC.setSquareColor(lines(6))
```
![](gallery/15_3.png)
使用 `obj.setSquareCData(___)` 函数可以设置方块 CData：

Use `obj.setSquareCData(___)` to set the CData for squares:
```matlab
BCC.setSquareCData(dataMat(:, 1))
colorbar
```
![](gallery/15_4.png)
___
## 4 修饰弦 (Set properties for chords)
### 弦的批量修饰 (Batch modification of chords)
弦的批量修饰可以使用`obj.setChord(___)`函数，一切 Patch 对象所具有的属性均可以被修饰，举个例子(修饰一下弦的颜色，边缘颜色，边缘线形状等)：

Batch modification of chords can be performed using the `obj.setChord(___)` function; any property possessed by a Patch object can be modified. For example (modifying the chord color, edge color, edge line shape, etc.):
```matlab
BCC.setChord('EdgeColor','k','LineWidth',1)
```
![](gallery/15_5.png)

## 修饰以某一节点为源的弦 (Modify chords from a specific source)
Use `obj.setChord(m, [], ___)`
```matlab
BCC.setChord(2,[], 'EdgeColor','k','LineWidth',2)
```
![](gallery/15_9.png)
### 弦的单独修饰 (Individual modification of chords)
弦的单独修饰可以使用`obj.setChord(m, n, __)`函数:

Individual chords can be styled using the `obj.setChord(m, n, __)` function.
```matlab
BCC.setChord(2,3, 'EdgeColor','k','LineWidth',2)
```
![](gallery/15_6.png)

### 使用布尔矩阵设置弦属性 (Use bool matrix to set chord properties)
```matlab
BCC.setChord(dataMat == 8, 'EdgeColor',[0,0,.8], 'LineWidth',2)
```
![](gallery/15_7.png)

### 弦的颜色映射 (colormap)
需要使用`obj.setChordCData(dataMat)`函数将弦的颜色与数值关联:

The `obj.setChordCData(dataMat)` function is required to associate the chord colors with the numerical values.
```matlab
BCC.setChordCData(dataMat)

colormap(flipud(summer))
colorbar
```
![](gallery/15_8.png)

### 为弦设置颜色的简洁方法 (A concise way to assign colors to chord)
+ obj.setChordColorBySquareT()
+ obj.setChordColorBySquareS()
```matlab
dataMat = randi([0,8], [6,6]);
BCC = biChordChart(dataMat, 'Arrow','on');
BCC = BCC.draw();
BCC.setSquareColor(lines(6))
```
```matlab
BCC.setChordColorBySquareS()
```
![](gallery/16.png)
```matlab
BCC.setChordColorBySquareT()
```
![](gallery/16_2.png)
### 高亮箭头 (Highlight arrow)
```matlab
BCC.addHighlightArrow(2, 3)
BCC.addHighlightArrow(2, 1)
BCC.addHighlightArrow(4, 4, [0,0,.8])
```
![](gallery/17.png)
___
## 5 标签 (Labels)
### 字体调整 (Set font)
使用`obj.setFont`函数对字体进行调整，所有text对象具有的属性均可以修饰，举个例子(更改文本的字号、字体和颜色)：

Use the `obj.setFont` function to adjust the font; any property possessed by a text object can be modified. For example (changing the text size, font, and color):
```matlab
BCC.setFont('FontSize',30, 'FontName','Cambria', 'Color',[0,0,.8])
```
![](gallery/18.png)
### 标签旋转 (Label rotate) 
使用函数 `obj.labelRotate` 旋转标签：

Use function `obj.labelRotate` to roatate labels:
```matlab
dataMat = randi([0,8], [6,6]);
nameList = {'bidirectional','chord','diagram','made-by','slandarer','MATLAB'};
BCC = biChordChart(dataMat, 'Arrow','on', 'Label',nameList);
BCC = BCC.draw();
```
```matlab
BCC.labelRotate('off')
```
![](gallery/18_1.png)
```matlab
BCC.labelRotate('on')
```
![](gallery/18_2.png)
```matlab
BCC.labelRotate('none')
```
![](gallery/18_3.png)

___
## 6 刻度及刻度标签 (Tick line and tick labels)

### 显示和隐藏刻度 (Show and Hide tick line)
通过 `obj.tickState` 函数设置显示或者隐藏刻度：

Use the `tickState` function to show or hide ticks:
```matlab
BCC.tickState('on')
% BCC.tickState('off')
```
![](gallery/19.png)

### 刻度标签 (Tick labels)
通过：

+ obj.setLabelRadius 调整节点标签半径
+ obj.tickLabelState 调整刻度标签开关
+ obj.setTickFont 调整刻度标签字体

By using:

+ `obj.setLabelRadius` to adjust the radius of node labels
+ `obj.tickLabelState` to toggle tick labels 'on'/'off'
+ `obj.setTickFont` to adjust the tick label font

```matlab
dataMat = [5 1 0 2;
           0 7 6 3;
           1 3 4 1;
           7 6 8 8];
BCC = biChordChart(dataMat, 'Arrow','on');
BCC = BCC.draw();

% 修改字体，字号及颜色(Set font for labels)
BCC.setFont('FontName','Cambria','FontSize',17)

% 调节标签半径
% Adjustable Label radius
BCC.setLabelRadius(1.3);

% 显示刻度和数值
% Displays scales and numeric values
BCC.tickState('on')
BCC.tickLabelState('on')

BCC.setTickFont('FontName','Cambria', 'Color',[0,0,.6])


figure()
dataMat = [5.213 1.231 0.000 2.835;
           0.000 7.674 6.565 3.085;
           1.534 3.676 4.467 1.654;
           7.647 6.111 8.772 8.561];
BCC=biChordChart(dataMat,'Arrow','on');
BCC=BCC.draw();

% 修改字体，字号及颜色(Set font for labels)
BCC.setFont('FontName','Cambria', 'FontSize',17)

% 调节标签半径
% Adjustable Label radius
BCC.setLabelRadius(1.4);

% 显示刻度和数值
% Displays scales and numeric values
BCC.tickState('on')
BCC.tickLabelState('on')
```
![](gallery/cover4.png)
![](gallery/cover5.png)

### 刻度标签格式自定义(Custom tick label formatting)
需要一个输入数值输出字符串的匿名函数，通过setTickLabelFormat函数可设置格式，比如科学计数法：\
An anonymous function is required that takes a numerical input and outputs a string; the format can be configured using the `setTickLabelFormat` function—for instance, using scientific notation.
```matlab
dataMat = [5.213 1.231 0.000 2.835;
           0.000 7.674 6.565 3.085;
           1.534 3.676 4.467 1.654;
           7.647 6.111 8.772 8.561].*1e15;
BCC = biChordChart(dataMat, 'Arrow','on');
BCC = BCC.draw();

% 修改字体，字号及颜色
BCC.setFont('FontName','Cambria', 'FontSize',17)

% 调节标签半径
% Adjustable Label radius
BCC.setLabelRadius(1.4);

% 显示刻度和数值
% Displays scales and numeric values
BCC.tickState('on')
BCC.tickLabelState('on')


% 调整数值字符串格式
% Adjust numeric string format
BCC.setTickLabelFormat(@(x)sprintf('%0.1e',x))
```
![](gallery/cover7.png)
___
## 7 布局 (Layout)
### 间隙 (Sep)

通过`Sep`属性可调整绘图间隙：

The plotting gap can be adjusted using the `Sep` attribute:
```matlab
dataMat = randi([0, 8],[ 6, 6]);

BCC = biChordChart(dataMat, 'Arrow','on', 'Sep',0);
BCC = BCC.draw(); 
```
Sep = 0
![](gallery/3.png)

Sep = 1/2

![](gallery/3_2.png)

### 分组及组间间隙 (Group and GroupSep)
```matlab
dataMat = randi([0, 8], [6, 6]);

% Create bichord diagram object (创建双向弦图对象)
BCC = biChordChart(dataMat, 'Arrow','on', 'Sep',1/20);

% Grouping nodes by number
BCC.GroupSep = 1/2;
BCC.Group = [1,1,2,2,3,1];

% Start drawing (开始绘图)
BCC=BCC.draw();
```
GroupSep = 1/10
![](gallery/11.png)
GroupSep = 1/2
![](gallery/11_2.png)
### 整体旋转 (Global roatation)
```
BCC.Rotation = pi/4;
```
![](gallery/12.png)

### 方块、刻度、标签半径与方块占比 (Square, tick, label radius | square ratio)
```matlab
dataMat = randi([1, 5], [3, 3]);

% Create bichord diagram object (创建双向弦图对象)
BCC=biChordChart(dataMat,'Arrow','on', 'Sep',1/3.5);
BCC.CData = lines(3);

% See radius&ratio.png for details
BCC.OSqRatio = .4;         % BCC.OriSquareRatio = .4; 
BCC.SSqRatio = .4;         % BCC.SubSquareRatio = .4;
BCC.SRadius = [1.1, 1.4];  % BCC.SquareRadius = [1.1, 1.4];
BCC.TRadius = 1.5;         % BCC.TickRadius = 1.5;
BCC.LRadius = 1.7;         % BCC.LabelRadius = 1.7;

% Start drawing (开始绘图)
BCC=BCC.draw();

% Show ticks and tick labels (添加刻度)
BCC.tickState('on')
BCC.tickLabelState('on')


set(gca,'XLim',[-1.8,1.8], 'YLim',[-1.8,1.8])
```
![](radius&ratio.png)
___
## 8 常用示例 (Common examples)
### 一个炫酷的例子 (A colorful demo)
```matlab
dataMat = rand([9, 9]); dataMat(dataMat > .7) = 0;
dataMat(eye(9) == 1) = (rand([1,9]) + .2).*3;

CList = [.85,.23,.24; .96,.39,.18; .98,.63,.22; .99,.80,.26; .70,.76,.21; 
    .24,.74,.71; .27,.65,.84; .09,.37,.80; .64,.40,.84];

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Arrow','on', 'CData',CList, 'TickMode','linear');
BCC.LinearMinorTick = 'on';
BCC = BCC.draw();

BCC.tickState('on')
BCC.tickLabelState('on')
BCC.setFont('FontName','Cambria', 'FontSize',17)
BCC.setChord('FaceAlpha',.7)
```
![](gallery/demo10.png)
### 另一个炫酷的例子 (A colorful demo 2)
```matlab
rng(2)
dataMat = rand([12, 12]);
dataMat(dataMat < .85) = 0;
dataMat(7,:) = 1.*(rand(1, 12) + .1);
dataMat(11,:) = .6.*(rand(1, 12) + .1);
dataMat(12,:) = [2.*(rand(1 ,10) + .1), 0, 0];

CList = [repmat([49,49,49],[10,1]); 235,28,34; 19,146,241]./255;

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Arrow','off', 'CData',CList);
BCC = BCC.draw();

BCC.tickState('on')
BCC.setFont('FontName','Cambria', 'FontSize',17)
BCC.setChord('FaceAlpha',.78, 'EdgeColor',[0,0,0])
BCC.setSquare('EdgeColor',[0,0,0], 'LineWidth',2)
```
![](gallery/demo10_2.png)

### 弦面配色及边缘配色快速设置 (Efficiently configure the FaceColor and EdgeColor of chords)
```matlab
dataMat = randi([10,10000], [10,10]);
dataMat(6:10,:) = 0;
dataMat(:,1:5) = 0;

NameList = {'BOC', 'ICBC', 'ABC', 'BOCM', 'CCB', ...
    'yama', 'nikoto', 'saki', 'koto', 'kawa'};
CList = [.63,.75,.88; .67,.84,.75; .85,.78,.88; 1.0,.92,.93; .92,.63,.64; 
    .57,.67,.75; 1.0,.65,.44; .72,.73,.40; .65,.57,.58; .92,.94,.96];

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Arrow','on', 'CData',CList, 'Label',NameList);
BCC = BCC.draw();

% Modify squares and chords color (修改方块颜色及弦颜色)
BCC.setSquare('LineWidth',1)
BCC.setSquareColor(CList, CList./1.5)
BCC.setChord('FaceAlpha',.85, 'LineWidth',.8)
BCC.setChordColorBySquareS()

BCC.tickState('on')
BCC.setFont('FontName','Cambria', 'FontSize',17)
```
![](gallery/demo2_3.png)
### 高亮以某节点为源的弦 (Highlight chords originating from a specific node)
```matlab
dataMat = rand([15, 15]);
dataMat(dataMat > .2) = 0;
CList = [ 67,115,181; 173,136, 76; 156, 66, 43;  25, 88,124; 136,142,151; 
    37, 63,100; 175,164,115;  32,121,169; 143, 92, 82;  22, 83,168; 
    167,154,118;  70, 87,114; 166,139,138; 156,106, 43;  94,116,151]./255;

figure('Units','normalized', 'Position',[.02,.05,.6,.85])
BCC = biChordChart(dataMat, 'Arrow','on', 'CData',CList);
BCC = BCC.draw();

BCC.tickState('on')
BCC.setFont('FontName','Cambria', 'FontSize',17, 'Color',[0,0,0])

% Modify chord color (修改弦颜色)
BCC.setChord('FaceColor',[ 54, 69, 92]./255 ,'FaceAlpha',.07)
% Highlight chords originating from a specific node (高亮以某节点为源的弦)
[~, N] = max(sum(dataMat > 0, 2));
BCC.setChord(N, [], 'FaceColor',CList(N,:), 'FaceAlpha',.6)
```
![](gallery/demo12.png)
![](gallery/demo12_1.png)
___
## Check out the various demos for more detailed usage instructions.
# star me please!

非常短的代码就能绘制出效果不错的图！！

MATLAB弦图绘制能画成这样属实不易，如果有用请留个star叭~

未经允许本代码请勿作商业用途，引用的话可以引用我file exchange上的链接，可使用如下格式：

Zhaoxu Liu (2024). Digraph chord chart 有向弦图 (https://www.mathworks.com/matlabcentral/fileexchange/121043-digraph-chord-chart), MATLAB Central File Exchange. 检索来源 2024/3/31.