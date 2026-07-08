% chordDemo18

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

% Reproduced from: 
% Merchant, A.T., King, S.H., Nguyen, E. et al. 
% Semantic design of functional de novo genes from a genomic language model. 
% Nature 649, 749–758 (2026). https://doi.org/10.1038/s41586-025-09749-7

rng(7)
labels = {'AAA lid','E-set','Calycin','Ubiquitin','RNase H','PDDEXK','Cupin', ...
    'Phage barrel','Dim A-B barrel','Peptidase CA','RING','Peptidase MA', ...
    '\beta-Propeller','HTH','Thioredoxin','GHD','OB','PKinase','An \beta-ribbon', ...
    'KH','SH3','TPR','GT-B','GT-A',{'ATP-';'grasp'},{'AB';'hydrolase'},{'TIM';'barrel'}, ...
    'Hybrid','Acetyltrans',{'Actin';'ATPase'},{'NADP';'Rossmann'},{'P-loop';'NTPase'}};
colors = [ 27, 16, 27; 107,200,173;  70,104,120;   4, 86, 92; 100,185,180;  96,100,172;
    51,128,130; 118,184,184;  85,173,170; 146,138,171; 161,204,203;  86,175,133;
    12,  3,  6; 185,183,204; 105,184,174; 105,201,173;  44, 88, 92; 102,183,184;
    0,122,124;  64, 72,132; 129,207,174;  67,132,122; 113,169,172; 101,184,167;
    165,204,218;   6, 73, 87; 102,185,178;  60, 49, 99;  78,127,140; 178,211,216;
    109,195,168; 196,241,223]./255;

data = (rand(32) > .96).*rand(32);
data(sub2ind([32,32], randi(32,1,32), 1:32)) = rand([32, 1])*5;
data([1,25,26,27,28,30,31,32],:) = data([1,25,26,27,28,30,31,32],:).*[15;3;18;15;3;3;5;5];
data(:,27) = data(:,27).*3;

figure()
tt = linspace(0, 2*pi, 100); R1 = 1.08; R2 = 1.2;
fill([cos(tt).*R1, cos(tt(end:-1:1)).*R2], [sin(tt).*R1, sin(tt(end:-1:1)).*R2], ...
    [229,229,229]./255, 'EdgeColor','none')

BCC = biChordChart(data, 'Sep',0);
BCC.LRadius = 1.07;
BCC.SRadius = [1, 1.05];
BCC.Label = labels;
BCC.CData = colors;
BCC.draw()

BCC.labelRotate('on')
BCC.setSquare('EdgeColor','k', 'LineWidth',1)
BCC.setChord('FaceAlpha', .5)