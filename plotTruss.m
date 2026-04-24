function plotTruss(nodes, elements, U, elementDOFs, sigma_e, FS, idx_min)

% ------------------------------------------------------------
% FUNCTION NAME: plotTruss
%
% PURPOSE:
%   Plot original and deformed truss geometry.
%
% INPUTS:
%   nodes        - node coordinates
%   elements     - connectivity
%   U            - displacement vector
%   elementDOFs  - DOF mapping
%   scale        - deformation scale factor
%
% OUTPUTS:
%   (none)
% ------------------------------------------------------------

% Extract Coordinates
coords = nodes(:, 1:2);

% Scale factor for visualization
Lchar = max(max(coords) - min(coords));  % characteristic length

if max(abs(U)) ~= 0
    scale = 0.1 * Lchar / max(abs(U));
else 
    scale = 1;
end

sigma_max = max(abs(sigma_e));
if sigma_max == 0
    sigma_max = 1;
end

cmap = parula(256);

figure
hold on
grid on
set(gca, 'GridAlpha', 0.2)
axis equal


h_orig = plot(nan, nan, 'Color', [0.6 0.6 0.6], 'LineWidth', 1);
h_def  = plot(nan, nan, 'r-', 'LineWidth', 2);
h_n1   = plot(nan, nan, 'ko', 'MarkerFaceColor','k');
h_n2   = plot(nan, nan, 'ro', 'MarkerFaceColor','r');
h_fail = plot(nan, nan, 'm-', 'LineWidth', 3);
h_crit = plot(nan, nan, 'c-', 'LineWidth', 5);

for e = 1:size(elements, 1)
    n1 = elements(e, 1);
    n2 = elements(e, 2);

    % --- Original coordinates ---
    x_orig = [coords(n1,1), coords(n2,1)];
    y_orig = [coords(n1,2), coords(n2,2)];

    % --- Element DOFs ---
    dofs = elementDOFs(e, :);
    Ue = U(dofs);

    % --- Deformed coordinates ---
    x_def = [coords(n1,1) + scale * Ue(1), coords(n2,1) + scale * Ue(3)];
    y_def = [coords(n1,2) + scale * Ue(2), coords(n2,2) + scale * Ue(4)];

    % --- Plot original (light gray) ---
    plot(x_orig, y_orig, 'Color', [0.6 0.6 0.6], 'LineWidth', 1);

    % --- Stress coloring ---
    s_norm = sigma_e(e) / sigma_max;

    idx = round((s_norm + 1)/2 * 255) + 1;
    idx = max(1, min(256, idx));

    color = cmap(idx, :);

    % --- Plot deformed with stress color ---
    plot(x_def, y_def, 'Color', color, 'LineWidth', 2);
end


% Plot original nodes
   plot(coords(:, 1), coords(:, 2), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6);

   % Compute deformed node positions
   Ux = U(1:2:end);
   Uy = U(2:2:end);

   deformedNodes = coords + scale * [Ux, Uy];

   % Plot deformed nodes
   plot(deformedNodes(:, 1), deformedNodes(:, 2), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 6);

  % Add node labels (original nodes)
  offset = 0.02 * max(coords(:));  % small shift so text doesn't overlap node

  for i = 1:size(coords, 1)
    text(coords(i,1) + offset, coords(i,2) + offset, sprintf(' %d', i), 'FontSize', 10, 'Color', 'w', 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
  end

% Plot displacement vectors (arrows)
L = max(max(coords) - min(coords));   % characteristic length

if max(abs(U)) ~= 0
arrowScale = 0.1 * L / max(abs(U));   % consistent scaling
else
    arrowScale = 1;
end

quiver(coords(:,1), coords(:,2), arrowScale*Ux, arrowScale*Uy, 0, 'r', 'LineWidth', 1.5, 'MaxHeadSize', 1);

% Colorbar
colormap(cmap);
sigma_plot = 0.7 * sigma_max;
caxis([-sigma_plot sigma_plot]);
cb = colorbar;
ylabel(cb, 'Stress (Pa)');

% Failure Highlights
if e == idx_min
    plot(x_def, y_def, 'c-', 'LineWidth', 5); % most critical
elseif FS(e) < 1
    plot(x_def, y_def, 'm-', 'LineWidth', 4); % failure
else
    plot(x_def, y_def, 'Color', color, 'LineWidth', 2);
end

title({'Truss Deformation with Stress Distribution', 'Color = Stress | Magenta = Failure (FS < 1)'});
legend([h_orig, h_def, h_fail, h_crit, h_n1, h_n2], {'Original Elements', 'Deformed (Stress Field)', 'Failure (FS < 1)', 'Critical Element (Min FS)', 'Original Nodes', 'Deformed Nodes'}, 'Location','eastoutside','box','off');
xlabel('X Position');
ylabel('Y Position');
hold off;

end