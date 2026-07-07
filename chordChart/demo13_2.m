%% Highlight arrow only

dataMat = [2 0 1 2 5 1 2;
           3 5 1 4 2 0 1;
           4 0 5 5 2 4 3];

CC = chordChart(dataMat, 'GroupSep',0);
CC.SRadius = [1.05, 1.2];
CC.LRadius = 1.135;
CC.SSqRatio = .2;
CC = CC.draw();

% Define colors for from and to blocks (定义来源(行)和目标(列)方块颜色)
CListS = [.93,.60,.62; .55,.80,.99; .95,.82,.18];
CListT = [.75,.73,.86; .56,.83,.78; 0.0,.60,.20; 1.0,.49,.02; .78,.77,.95; .59,.24,.36; .98,.51,.45];

CC.setSquareColorS(CListS)                    % Apply source square colors (应用来源方块颜色)
CC.setSquareColorT(CListT)                    % Apply target square colors (应用目标方块颜色)
CC.setChord('Visible','off')                  % Hide chord ribbons (隐藏弦带)
CC.setFont('Color','w', 'FontWeight','bold')  % Set label font to white, bold (标签字体设为白色加粗)

% Add highlight arrows for each non-zero flow (为每个非零流量添加高亮箭头)
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        if dataMat(i, j) > 0
            tArrow = CC.addHighlightArrow(i, j, CListS(i, :));
            tArrow.Line.LineWidth = 2;
        end
    end
end