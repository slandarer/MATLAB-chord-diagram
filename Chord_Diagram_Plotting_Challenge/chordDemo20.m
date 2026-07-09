% chordDemo20

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

rng(6)
dataMat = rand(25).*(1 - eye(25)).*(rand(25) < .2).*3;
dataMat(:, 1) = dataMat(:, 1).*2;
dataMat([2:9, 19], :) = dataMat([2:9, 19], :).*5;
dataMat(20, 1) = 120; dataMat(17, 2) = 25; 

nameList = {'WHR','TNF-R1','UC','T2D','T1D','TG','Smoking','RA','Neuroticism', ...
    'Depression','Lupus',"Crohn's",'Insomnia','CAD','Alcohol','Hypertension','IL-6RA',...
    'Asthma','Education','BMI','Hypothyroid','TC','LDL','HR','HDL'};
CList = [.27,0.0,.33; .28,.07,.39; .28,.12,.44; .28,.17,.48; .27,.23,.51;
         .25,.27,.53; .23,.32,.55; .21,.37,.55; .19,.41,.56; .17,.45,.56;
         .16,.49,.56; .14,.53,.56; .13,.57,.55; .12,.60,.54; .13,.64,.53;
         .16,.68,.50; .21,.72,.47; .28,.75,.43; .36,.79,.39; .46,.82,.33;
         .56,.84,.27; .67,.86,.20; .78,.88,.13; .89,.89,.10; .99,.91,.14];

BCC = biChordChart(dataMat, 'CData',CList, 'Label',nameList, 'LRadius',1.2);
BCC.draw()
BCC.labelRotate('on')
BCC.setChord('FaceAlpha',.5)
