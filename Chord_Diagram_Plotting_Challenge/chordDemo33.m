% chordDemo33

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

D = randi([0, 2], [5, 30]);
sName = {{'Peptide antigen';'assembly with';'MHC protein complex'}, ...
    {'Cell killing'}, {'Antigen processing';'and presentation';'of peptide antigen';'via MHC class II'}, ...
    {'Regulation of';'T cell antivation'},{'Regulation of';'leukocyte';'cell-cell adhesion'}};
tName = compose('Id-%d', sort(randi([10000, 99999], [1, 30])));
CList = [172,182,94; 154,173,215; 158,211,193; 247,209,170; 69,164,179]./255;


[M, N] = size(D);
dataMat = zeros(M + N);
dataMat(1:M, (M + 1):end) = D;
group = [ones(1, M), ones(1, N).*2];


BCC = biChordChart(dataMat, 'Label',[sName, tName], 'GroupSep',1/6, 'Sep',1/5, ...
    'Rotation', 2*pi/3, 'SRadius',[1.04, 1.08], 'LRadius',1.12);
BCC.Group = group;
BCC.CData = CList;
BCC.draw()

BCC.labelRotate('on')
BCC.setChord('FaceAlpha',.5)



