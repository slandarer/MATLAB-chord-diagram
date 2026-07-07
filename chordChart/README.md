# 封面图 (Cover)

![输入图片说明](gallery/cover6.png)

![输入图片说明](gallery/cover5.png)

___

# 使用教程(User Guide)
## 1 数据格式 (Data Format)

数据要求为全部数值大于等于0的数值矩阵，或者`table`数组，或者数值矩阵+行列名元胞数组，首先举个数值矩阵的例子：

The data input must be a numeric matrix where all values ​​are greater than or equal to 0, 
a `table` array, or a numeric matrix with cell arrays for row and column names also works. 

First, let's look at an example using a numeric matrix:

### 数值矩阵 (numeric matrix)
```matlab
dataMat = randi([0, 5], [5, 4]); 

CC = chordChart(dataMat);
CC = CC.draw();
```

![输入图片说明](gallery/0.png)

由于没对各个对象命名，因此会自动命名为`Rn`和`Cn`
Since the individual objects were not explicitly named, they will be automatically named `Rn` and `Cn`.
### 数值矩阵+行列名元胞数组(numeric matrix with cell arrays for row and column names)
这是最推荐的一种格式：
```matlab
dataMat = [2 0 1 2 5 1 2;
           3 5 1 4 2 0 1;
           4 0 5 5 2 4 3];
colName = {'G1','G2','G3','G4','G5','G6','G7'};
rowName = {'S1','S2','S3'};

CC = chordChart(dataMat, 'RowName',rowName, 'ColName',colName);
CC = CC.draw();
```

![输入图片说明](gallery/1.png)

`RowName`要和矩阵的行相同大小\
`ColName`要和矩阵的列相同大小\
对于本列子来说第2行第3列数值是1，就说明有一份能量从`S1`流向`G3`，也就在这俩之间需要画单位宽度的弦。

`RowName` must be of the same size as the rows of the matrix.\
`ColName` must be of the same size as the columns of the matrix.\
In this specific example, the value at the second row and third column is 1; 
this indicates that a unit of energy flows from `S1` to `G3`, 
implying that a chord of unit width must be drawn between these two entities.

### table 数组
需要使用如下格式的table数组：\
You need to use a table array in the following format:
```matlab
% ans =
% 
%   3×7 table
% 
%           G1    G2    G3    G4    G5    G6    G7
%           __    __    __    __    __    __    __
% 
%     S1    2     0     1     2     5     1     2 
%     S2    3     5     1     4     2     0     1 
%     S3    4     0     5     5     2     4     3 
```
当然，如果各个行没有命名的话依旧会自动命名的。
___
## 2 修饰弦(Set properties for chords)
### 弦的批量修饰(Batch modification of chords)
弦的批量修饰可以使用`setChord(___)`函数，一切Patch对象所具有的属性均可以被修饰，举个例子(修饰一下弦的颜色，边缘颜色，边缘线形状等)：\
Batch modification of chords can be performed using the `setChord(___)` function; any property possessed by a Patch object can be modified. For example (modifying the chord color, edge color, edge line shape, etc.):
```matlab
CC.setChord('EdgeColor',[.3,.3,.3], 'LineStyle','--',...
    'LineWidth',.1, 'FaceColor',[.3,.3,.3])
```
![输入图片说明](gallery/2.png)

### 弦的单独修饰(Individual modification of chords)
弦的单独修饰可以使用`setChord(m, n, __)`函数，其中 m,n 值是和原始数值矩阵的行列完全对应的,举个例子(把`S2`流向`G4`的弦颜色更改为红色)：\
Individual chords can be styled using the `setChord(m, n, __)` function, where the values ​​of `m` and `n` correspond exactly to the rows and columns of the original numerical matrix. For example (to change the color of the chord flowing from `S2` to `G4` to red):
```matlab
CC.setChord(2,4, 'FaceColor',[1,0,0])
```
![输入图片说明](gallery/3.png)

### 弦的颜色映射(colormap)
```matlab
colormap(copper(100))
```
![输入图片说明](gallery/5.png)
___

## 3 圆弧状方块修饰(Arc-shaped Block Decoration)
### 圆弧状方块批量修饰(Batch Modification of Rounded Square Blocks)
使用
+ setSquareT(___)
+ setSquareS(___)



分别修饰上方方块和下方方块，一切Patch对象所具有的属性均可以被修饰，举个例子，上方方块批量修饰(改为黑色)：\
S means source, which is the block belows, and T means target, wich is the blocks above. For example, batch-modifying the blocks above (changing them to black):

```matlab
CC.setSquareT('FaceColor',[0,0,0])
```

![输入图片说明](gallery/6.png)
### 圆弧状方块单独修饰(Individual Modification of Rounded Square Blocks)
使用
+ setSquareT(n, ___)
+ setSquareS(n, ___)

分别修饰上方方块和下方方块，举个例子，上方第二个方块单独修饰(改为红色)：\
Set the n-th block. For example, the second block from the top is modified individually (changed to red):

```matlab
CC.setSquareT(2,'FaceColor',[.8,0,0])
```
![输入图片说明](gallery/7.png)
___

## 4 字体调整(Set font)
使用`setFont`函数对字体进行调整，所有text对象具有的属性均可以修饰，举个例子(更改文本的字号、字体和颜色)：Use the `setFont` function to adjust the font; any property possessed by a text object can be modified. For example (changing the text size, font, and color):
```matlab
CC.setFont('FontSize',30, 'FontName','Cambria', 'Color',[0,0,.8])
```
![输入图片说明](gallery/8.png)
___
## 5 显示和隐藏刻度(Show and Hide tick marks)
```matlab
CC.tickState('on')
% CC.tickState('off')
```

![输入图片说明](gallery/cover1.png)

___
## 6 间隙(Sep)
假如矩阵较大则绘图会比例失调：If the matrix is ​​large-scale, the plot will be disproportionate.
```matlab
dataMat = randi([0, 1], [20, 10]); 
CC = chordChart(dataMat);
CC = CC.draw();
```
![输入图片说明](gallery/9.png)
通过`Sep`属性可调整绘图间隙，例如设置为特别小的1/120：
The plotting gap can be adjusted using the `Sep` attribute—for example, by setting it to a particularly small value of 1/120:
```matlab
dataMat = randi([0, 1], [20, 10]); 
% use Sep to decrease space (separation)
% 使用 sep 减小空隙
CC = chordChart(dataMat, 'Sep',1/120);
CC = CC.draw();
```
![输入图片说明](gallery/10.png)
___
## 7 刻度标签(Tick labels)
通过：

+ setLabelRadius 调整类标签半径
+ tickLabelState 调整刻度标签开关
+ setTickFont 调整刻度标签字体

By using:

+ `setLabelRadius` to adjust the radius of class labels
+ `tickLabelState` to toggle tick labels on/off
+ `setTickFont` to adjust the tick label font

```matlab
dataMat = [2 0 1 2 5 1 2;
           3 5 1 4 2 0 1;
           4 0 5 5 2 4 3];
colName = {'G1','G2','G3','G4','G5','G6','G7'};
rowName = {'S1','S2','S3'};

CC = chordChart(dataMat, 'RowName',rowName, 'ColName',colName);
CC = CC.draw();
CC.setFont('FontSize',17, 'FontName','Cambria')

% 显示刻度和数值
% Displays scales and numeric values
CC.tickState('on')
CC.tickLabelState('on')

CC.setTickFont('Color',[0,0,.8], 'FontName','Cambria')

% 调节标签半径
% Adjustable Label radius
CC.setLabelRadius(1.3);


% figure()
% dataMat = [2 0 1 2 5 1 2;
%            3 5 1 4 2 0 1;
%            4 0 5 5 2 4 3];
% dataMat = dataMat + rand(3, 7);
% dataMat(dataMat < 1) = 0;
% 
% CC = chordChart(dataMat, 'RowName',rowName, 'ColName',colName);
% CC = CC.draw();
% CC.setFont('FontSize',17, 'FontName','Cambria')
% 
% % 显示刻度和数值
% % Displays scales and numeric values
% CC.tickState('on')
% CC.tickLabelState('on')
% 
% % 调节标签半径
% % Adjustable Label radius
% CC.setLabelRadius(1.4);
```
![输入图片说明](gallery/12.png)
![输入图片说明](gallery/cover6.png)

___
## 8 刻度标签格式自定义(Custom tick label formatting)
需要一个输入数值输出字符串的匿名函数，通过setTickLabelFormat函数可设置格式，比如科学计数法：
An anonymous function is required that takes a numerical input and outputs a string; the format—such as scientific notation—can be configured using the `setTickLabelFormat` function.

```matlab
dataMat = [2 0 1 2 5 1 2;
           3 5 1 4 2 0 1;
           4 0 5 5 2 4 3];
dataMat = dataMat+rand(3,7);
dataMat(dataMat < 1) = 0;
dataMat = dataMat.*1000;

CC = chordChart(dataMat);
CC = CC.draw();
CC.setFont('FontSize',17, 'FontName','Cambria')

% 显示刻度和数值
% Displays scales and numeric values
CC.tickState('on')
CC.tickLabelState('on')

% 调节标签半径
% Adjustable Label radius
CC.setLabelRadius(1.4);

% 调整数值字符串格式
% Adjust numeric string format
CC.setTickLabelFormat(@(x)sprintf('%0.1e',x))

```
![输入图片说明](gallery/cover7.png)

___
## 9 弦末端弧形块单独上色(The blocks at the ends of the chords painted separately.)
```matlab
dataMat = randi([1, 15], [7, 22]); dataMat(dataMat < 11) = 0;
dataMat(1, sum(dataMat,1) == 0) = 15;
colName = {'A2M', 'FGA', 'FGB', 'FGG', 'F11', 'KLKB1', 'SERPINE1', 'VWF',...
           'THBD', 'TFPI', 'PLAT', 'SERPINA5', 'SERPIND1', 'F2', 'PLG', 'F12',...
           'SERPINC1', 'SERPINA1', 'PROS1', 'SERPINF2', 'F13A1', 'PROC'};
rowName = {'Lung', 'Spleen', 'Liver', 'Heart',...
           'Renal cortex', 'Renal medulla', 'Thyroid'};

figure('Units','normalized', 'Position',[.02, .05, .6, .85])
CC = chordChart(dataMat, 'RowName',rowName, 'ColName',colName, 'Sep',1/80, 'LRadius',1.21, 'SSqRatio',1);
CC = CC.draw();
CC.labelRotate('on')

% Modify the color of the blocks below (修改下方方块颜色)
CListS = [128,108,171; 222,208,161; 180,196,229; 209,150,146; 175,201,166;
          134,156,118; 175,175,173]./255;
CC.setSquareColorS(CListS)
% Modify chord color (修改弦颜色)
CC.setChordColorBySquareS()

Regulated = (rand([7, 22]) < .8) + 1; % Upregulated:1 | Downregulated:2
% Set individual end blocks for each chord (单独设置每一个弦末端方块)
% Use obj.setSubSquareS | set Subordinate Square (Source)
% or  obj.setSubSquareT | set Subordinate Square (Target)
CC.setSubSquareT(Regulated == 1, 'FaceColor',[173, 70, 65]./255)
CC.setSubSquareT(Regulated == 2, 'FaceColor',[ 79,135,136]./255)

% Draw legend (绘制图例)
H1 = fill([0,1,0] + 100, [1,0,1] + 100, [173, 70, 65]./255, 'EdgeColor','none');
H2 = fill([0,1,0] + 100, [1,0,1] + 100, [ 79,135,136]./255, 'EdgeColor','none');
lgdHdl = legend([H1, H2], {'Upregulated','Downregulated'}, 'AutoUpdate','off', ...
    'Location','best', 'Box','off', 'FontSize',13);
lgdHdl.ItemTokenSize = [12,12];
```
![输入图片说明](gallery/S0092-8674(21)00004-0%20P8.png)

___
# Check out the various demos for more detailed usage instructions.
# star me please!

MATLAB弦图绘制能画成这样属实不易，如果有用请留个`star`叭~

未经允许本代码请勿作商业用途，引用的话可以引用我file exchange上的链接，可使用如下格式：

Zhaoxu Liu (2022). chord chart 弦图 (https://www.mathworks.com/matlabcentral/fileexchange/116550-chord-chart), MATLAB Central File Exchange. 检索来源 2022/8/21.
