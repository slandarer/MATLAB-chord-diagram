% chordDemo32

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

CList = [235,222,187; 80,148,147; 111,157,206; 224,145,139]./255;
D = [0,1,0,1,0,0,0,0,0,1,0,0,1,1,1,0,0,0,1,1,1,0,0,1,0,0,0,1,0,1,0,1,0,0,1,0,1,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0;   % Class 1
     0,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,1,1,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1;   % Class 2
     1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,1,0,1,1,0,0,0,1,1,0,1,1,1,1,1,0,0;   % Class 3
     0,0,0,0,0,0,1,1,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0];  % Class 4
sName = {'Trait A', 'Trait B', 'Trait C', 'Trait D'};
tName = compose('Id-%d', sort(randi([10000, 99999], [1, 55])));

[tind, ~] = find(D);
[M, N] = size(D);
% Build extended adjacency matrix : 4-by-55 -> 59-by-59
dataMat = zeros(M + N);
dataMat(1:M, (M + 1):end) = D;
group = [ones(1, M), ones(1, N).*2];

BCC = biChordChart(dataMat, 'Label',[sName, tName], 'GroupSep',1/12, ...
    'Rotation', -pi/24, 'SRadius',[1.04, 1.08], 'LRadius',1.12);
BCC.Group = group;
BCC.CData = [CList; CList(tind, :)];
BCC.draw()

BCC.setChord('FaceAlpha',.45)
BCC.labelRotate('on')
set(BCC.labelHdl((M + 1):end), 'FontSize',12)
