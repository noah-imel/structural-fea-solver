function [delta_e, N_e, sigma_e] = postProcess(U, nodes, elements, elementDOFs, E, A)

% ----------------------------
% POST-PROCESSING
% ----------------------------
% Compute element deformation, force, and stress
[delta_e, N_e, sigma_e] = computeElementResults(U, nodes, elements, elementDOFs, E, A);

end