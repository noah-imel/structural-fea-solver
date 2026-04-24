function printResults(U, delta_e, N_e, sigma_e, FS, FS_min, idx_min, Rx, Ry, Fglobal, nodes)

% ==============================
% SYSTEM CHECK
% ==============================
disp(' ')
disp('==============================')
disp('        SYSTEM CHECK')
disp('==============================')

Fx = sum(Fglobal(1:2:end));
Fy = sum(Fglobal(2:2:end));

Fx_balance = Fx + sum(Rx);
Fy_balance = Fy + sum(Ry);

fprintf('Equilibrium (Fx): %.6e\n', Fx_balance);
fprintf('Equilibrium (Fy): %.6e\n', Fy_balance);

if abs(Fx_balance) < 1e-6 && abs(Fy_balance) < 1e-6
    disp('Status: Equilibrium satisfied')
else
    disp('WARNING: Equilibrium NOT satisfied')
end

% ==============================
% DESIGN SUMMARY
% ==============================
disp(' ')
disp('==============================')
disp('        DESIGN SUMMARY')
disp('==============================')

fprintf('Max Stress: %.3e Pa\n', max(abs(sigma_e)));
fprintf('Min Safety Factor: %.3f\n', FS_min);
fprintf('Critical Element: %d\n', idx_min);

fprintf('Critical Element Stress: %.3e Pa\n', sigma_e(idx_min));
fprintf('Critical Element Force: %.3e N\n', N_e(idx_min));

Umax = max(abs(U));
fprintf('Maximum Displacement: %.3e m\n', Umax);

if FS_min > 1
    disp('STATUS: STRUCTURE IS SAFE')
else
    disp('STATUS: STRUCTURE FAILS')
end

% ==============================
% REACTION FORCES
% ==============================
disp(' ')
disp('==============================')
disp('        REACTION FORCES')
disp('==============================')

numNodes = length(Rx);
for i = 1:numNodes
    if abs(Rx(i)) > 0 || abs(Ry(i)) > 0
        fprintf('Node %d: Rx = %.3f, Ry = %.3f\n', i, Rx(i), Ry(i));
    end
end

% ==============================
% ELEMENT TABLE
% ==============================
disp(' ')
disp('==============================')
disp('     ELEMENT RESULTS TABLE')
disp('==============================')

elemID = (1:length(N_e))';

% Tension / Compression classification
type = strings(size(N_e));
type(N_e > 0) = "Tension";
type(N_e < 0) = "Compression";
type(N_e == 0) = "Zero";

% Critical + failure flags
isCritical = false(size(N_e));
isCritical(idx_min) = true;

failure = FS < 1;

T_elements = table(elemID, delta_e, N_e, sigma_e, FS, type, isCritical, failure, 'VariableNames', {'Element', 'Delta_m', 'AxialForce_N', 'Stress_Pa', 'FS', 'Type', 'Critical', 'Failure'});

% Sort by FS (worst first)
T_elements = sortrows(T_elements, 'FS');

disp(T_elements)

% ==============================
% NODE TABLE
% ==============================
disp(' ')
disp('==============================')
disp('       NODE RESULTS TABLE')
disp('==============================')

numNodes = size(nodes,1);
nodeID = (1:numNodes)';

Ux = U(1:2:end);
Uy = U(2:2:end);

fixedX = nodes(:,5);
fixedY = nodes(:,6);

T_nodes = table(nodeID, Ux, Uy, Rx, Ry, fixedX, fixedY, 'VariableNames', {'Node', 'Ux_m', 'Uy_m', 'Rx_N', 'Ry_N', 'FixX', 'FixY'});

disp(T_nodes)

% ==============================
% OPTIONAL EXPORT
% ==============================
% writetable(T_elements, 'element_results.csv');
% writetable(T_nodes, 'node_results.csv');

end