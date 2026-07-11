% chordDemo31

% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer
rng(1)
dataMat = rand([4, 7]).*(rand([4, 7]) > .2);
[M, N] = size(dataMat);

CListS = [.80,.24,.14; .95,.77,.35; .43,.68,.56; .19,.71,.80; 0.0,.31,.48];
CListT = [.75,.73,.86; .56,.83,.78; 0.0,.60,.20; 1.0,.49,.02; .78,.77,.95; .59,.24,.36; .98,.51,.45];

CC = chordChart(dataMat, 'GroupSep',0, 'Sep',1/90);
CC.SRadius = [1.05, 1.2];
CC.LRadius = 1.135;
CC.SSqRatio = .2;
CC = CC.draw();

CC.setSquareColorS(CListS)                    % Apply source square colors (应用来源方块颜色)
CC.setSquareColorT(CListT)                    % Apply target square colors (应用目标方块颜色)
CC.setChord('Visible','off')                  % Hide chord ribbons (隐藏弦带)
CC.setFont('Color','w', 'FontWeight','bold')  % Set label font to white, bold (标签字体设为白色加粗)

CC.setSquareS('LineWidth',1, 'EdgeColor','k')
CC.setSubSquareS('LineWidth',1, 'EdgeColor','k')
CC.setSquareT('LineWidth',1, 'EdgeColor','k')
CC.setSubSquareT('LineWidth',1, 'EdgeColor','k')

% Add highlight arrows for each non-zero flow (为每个非零流量添加高亮箭头)
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        if dataMat(i, j) > 0
            tArrow = CC.addHighlightArrow(i, j, CListS(i, :));
            tArrow.Line.LineWidth = 2;
        end
    end
end