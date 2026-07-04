%% Highlight arrow only

dataMat = [2 0 1 2 5 1 2;
    3 5 1 4 2 0 1;
    4 0 5 5 2 4 3];

CC = chordChart(dataMat, 'GroupSep',0);
CC.SRadius = [1.05, 1.2];
CC.LRadius = 1.125;
CC.TRadius = 1.03;
CC = CC.draw();

% Define colors for from and to blocks (定义来源(行)和目标(列)方块颜色)
CListS = [.93,.60,.62; .55,.80,.99; .95,.82,.18];
CListT = [.11,.10,.23; .21,.08,.13; .38,.52,.53; .47,.70,.67; .67,.83,.78; .62,.50,.45; .23,.20,.29];

CC.setSquareColorS(CListS)                    % Apply from block colors (应用来源方块颜色)
CC.setSquareColorT(CListT)                    % Apply to block colors (应用目标方块颜色)
CC.setChord('Visible','off')                  % Hide chord ribbons (隐藏弦带)
CC.setFont('Color','w', 'FontWeight','bold')  % Set label font to white, bold (标签字体设为白色加粗)
CC.tickState('on')                            % Enable tick marks (启用刻度)

% Add highlight arrows for each non-zero flow (为每个非零流量添加高亮箭头)
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        if dataMat(i, j) > 0
            tArrow = CC.addHighlightArrow(i, j);
            tArrow.Line.Color = CListS(i, :);       % Arrow line color (箭头线颜色)
            tArrow.Line.LineWidth = 2;              % Arrow line width (箭头线宽)
            tArrow.Arrow.FaceColor = CListS(i, :);  % Arrow head fill color (箭头填充色)
            tArrow.Arrow.EdgeColor = CListS(i, :);  % Arrow head edge color (箭头边缘色)
        end
    end
end