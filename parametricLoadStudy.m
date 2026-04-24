function parametricLoadStudy()

F_scales = linspace(0.1, 5, 20);
FS_min_values = zeros(size(F_scales));

[nodes_base, elements, E, A] = defineProblem();

% ----------------------------
% RUN STUDY
% ----------------------------
for i = 1:length(F_scales)
    scale = F_scales(i);

    nodes = nodes_base;

    nodes(2,3) = scale * nodes_base(2,3);
    nodes(2,4) = scale * nodes_base(2,4);

    [K, Fglobal, fixedDOF, elementDOFs] = buildSystem(nodes, elements, E, A);
    [U, ~] = solveTruss(K, Fglobal, fixedDOF);
    [~, ~, sigma_e] = postProcess(U, nodes, elements, elementDOFs, E, A);
    [~, FS_min, ~] = computeSafetyFactor(sigma_e);

    FS_min_values(i) = FS_min;
end

% ----------------------------
% FIND FAILURE POINT
% ----------------------------
targetFS = 1;

idx = find(FS_min_values <= targetFS, 1);

if ~isempty(idx) && idx > 1
    % Linear interpolation
    x1 = F_scales(idx-1);
    x2 = F_scales(idx);

    y1 = FS_min_values(idx-1);
    y2 = FS_min_values(idx);

    F_critical = x1 + (targetFS - y1) * (x2 - x1) / (y2 - y1);

    fprintf('Maximum safe load factor (interpolated): %.3f\n', F_critical);

    % Actual load magnitude
    F_original = norm([nodes_base(2,3), nodes_base(2,4)]);
    F_max_actual = F_critical * F_original;

    fprintf('Original load magnitude: %.2f N\n', F_original);
    fprintf('Maximum allowable load: %.2f N\n', F_max_actual);

elseif isempty(idx)
    disp('Structure remains safe over tested load range.');
else
    disp('Failure occurs at very low load (check setup).');
end

% ----------------------------
% PLOT
% ----------------------------
figure
hold on

plot(F_scales, FS_min_values, 'o-', 'LineWidth', 2)

xlabel('Load Scaling Factor')
ylabel('Minimum Safety Factor')
title('Safety Factor vs Load Magnitude')

grid on
box on

yline(targetFS, '--r', 'FS = 1 (Failure Limit)');

if exist('F_critical','var')
    plot(F_critical, targetFS, 'ro', 'MarkerSize', 8, 'LineWidth', 2)

    text(F_critical, targetFS, sprintf('  F_{max} = %.3f', F_critical), 'Color', 'r', 'VerticalAlignment', 'bottom');
end

legend('FS vs Load', 'FS = 1 Threshold', 'Failure Point', 'Location', 'northeast')

hold off

end

% Result: Structure fails when load exceeds ~2.21x original magnitude
