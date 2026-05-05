%% Pi digit connectivity visualization (digits 1-1000)

% First 1000 digits of pi after decimal point
piStr = ['1415926535897932384626433832795028841971693993751058209749445923078', ...
    '1640628620899862803482534211706798214808651328230664709384460955058', ...
    '1723175359408128481117450284102701938521105559644622948954930381964', ...
    '4288109756659334461284756482337867831652712019091456485669234603486', ...
    '1045432664821339360726024914127372458700660631558817488152092096282', ...
    '9254091715364367892590360011330530548820466521384146951941511609433', ...
    '0572703657595919530921861173819326117931051185480744623799627495673', ...
    '5188575272489122793818301194912983367336244065664308602139494639522', ...
    '4737190702179860943702770539217176293176752384674818467669405132000', ...
    '5681271452635608277857713427577896091736371787214684409012249534301', ...
    '4654958537105079227968925892354201995611212902196086403441815981362', ...
    '9774771309960518707211349999998372978049951059731732816096318595024', ...
    '4594553469083026425223082533446850352619311881710100031378387528865', ...
    '8753320838142061717766914730359825349042875546873115956286388235378', ...
    '75937519577818577805321712268066130019278766111959092164201999'];

% Convert digit characters to group indices (1-10)
% Subtract 47 to map ASCII '0' (48) to group 1
Group = abs(piStr(1:1000)) - 47;

% Build adjacency matrix: connect each digit to its next neighbor (off-diagonal)
Data = diag(ones(1, 999), -1);

% Sort nodes by group for grouped layout
[Group, ind] = sort(Group);
Data = Data(ind, ind);              % Reorder adjacency matrix
Data = Data + Data.' + eye(1000);   % Make symmetric and add self-loops

% Define group (digit) names and custom colors
groupName = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};
colorList = [239, 65, 75; 230, 115, 48; 229, 158, 57; 232, 136, 85; 239, 199, 97;
             144, 180, 116; 78, 166, 136; 81, 140, 136; 90, 118, 142; 43, 121, 159] ./ 255;

% Create figure with black background
figure()
set(gca, 'Color', [0, 0, 0])

% Initialize circular network chart
CNPI = circNetChart(Data);

% Node and edge appearance (uniform sizes)
CNPI.NodeSizeLim   = [0.01, 0.01];
CNPI.EdgeWidthLim  = [0.005, 0.005];

% Group layout configuration
CNPI.Group              = Group;
CNPI.GroupSep           = 1/8;              % Gap between groups (1/8 of full circle)
CNPI.GroupName          = groupName;
CNPI.GroupLabelRadius   = 1.05;

% RenderingMethod : interp
CNPI.NodeColor         = colorList(Group, :);  
CNPI.RenderingMethod   = 'interp';            

% Edge curvature (full Bezier curve)
CNPI.Curvature = 1;

% Render the chart
CNPI = CNPI.draw();

% Hide individual node labels
CNPI.setLabel('Visible', 'off')

% Style group labels (digit labels around the circle)
CNPI.setGroupLabel('FontSize', 25, 'FontName', 'Monospaced', ...
                   'FontWeight', 'bold', 'Color', 'w')