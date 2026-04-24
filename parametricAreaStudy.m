function parametricAreaStudy()

A_values = linspace(1e-4, 1e-2, 20);   % vary area
FS_min_values = zeros(size(A_values));

[nodes, elements, E, ~] = defineProblem();

% ----------------------------
% RUN STUDY
% ----------------------------
for i = 1:length(A_values)
    A = A_values(i);

    [K, Fglobal, fixedDOF, elementDOFs] = buildSystem(nodes, elements, E, A);
    [U, ~] = solveTruss(K, Fglobal, fixedDOF);
    [~, ~, sigma_e] = postProcess(U, nodes, elements, elementDOFs, E, A);
    [~, FS_min, ~] = computeSafetyFactor(sigma_e);

    FS_min_values(i) = FS_min;
end

% ----------------------------
% DESIGN TARGET
% ----------------------------
targetFS = 1;

idx = find(FS_min_values >= targetFS, 1);

if ~isempty(idx)
    A_required = A_values(idx);
    fprintf('Required Area for FS >= %.1f: %.4e m^2\n', targetFS, A_required);
    fprintf('Area increase required: %.2fx original\n', A_required / A_values(1));
else
    disp('No safe design found in tested range.');
end

% ----------------------------
% SLOPE (INSIGHT)
% ----------------------------
p = polyfit(A_values, FS_min_values, 1);
fprintf('FS increases by %.2e per unit area\n', p(1));

% ----------------------------
% PLOT
% ----------------------------
figure
hold on

plot(A_values, FS_min_values, 'o-', 'LineWidth', 2)

xlabel('Cross-sectional Area (m^2)')
ylabel('Minimum Safety Factor')
title('Safety Factor vs Cross-sectional Area')

grid on
box on

% Failure threshold
yline(targetFS, '--r', 'FS = 1 (Failure Limit)');

% Highlight required point
if ~isempty(idx)
    plot(A_required, FS_min_values(idx), 'ro', 'MarkerSize', 8, 'LineWidth', 2)

    text(A_required, FS_min_values(idx), sprintf('  A = %.2e', A_required), 'Color', 'r');
end

text(A_required, FS_min_values(idx), sprintf('  A = %.2e', A_required), 'Color', 'r');

legend('FS vs Area', 'FS = 1 Threshold', 'Required Design Point', 'Location', 'northwest')

hold off
end

