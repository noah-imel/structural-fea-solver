% ============================================================
% 2D Truss Finite Element Solver (MATLAB)
%
% This script:
% - Defines truss geometry (nodes + elements)
% - Builds element stiffness matrices
% - Assembles global stiffness matrix
% - Applies loads and boundary conditions
% - Solves for nodal displacements
% - Computes element forces and stresses
% - Plots deformed shape
% ============================================================

% --- Problem Definition ---
[nodes, elements, E, A] = defineProblem();

% --- System Assembly ---
[K, Fglobal, fixedDOF, elementDOFs] = buildSystem(nodes, elements, E, A);

% --- Solve ---
[U, freeDOF] = solveTruss(K, Fglobal, fixedDOF);

% --- Post-Processing ---
[delta_e, N_e, sigma_e] = postProcess(U, nodes, elements, elementDOFs, E, A);

% --- Design Evaluation ---
[FS, FS_min, idx_min] = computeSafetyFactor(sigma_e);

% --- Reactions (Validation) ---
[R, Rx, Ry] = computeReactions(K, U, Fglobal, fixedDOF, nodes);

% --- Visualization ---
plotTruss(nodes, elements, U, elementDOFs, sigma_e, FS, idx_min);

% --- Output ---
printResults(U, delta_e, N_e, sigma_e, FS, FS_min, idx_min, Rx, Ry, Fglobal, nodes);