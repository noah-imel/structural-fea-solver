function [R, Rx, Ry] = computeReactions(K, U, Fglobal, fixedDOF, nodes)

% ----------------------------
% REACTION FORCES
% ----------------------------
R = K * U - Fglobal;

numNodes = size(nodes,1);
Rx = zeros(numNodes,1);
Ry = zeros(numNodes,1);

for i = 1:length(fixedDOF)
    dof = fixedDOF(i);
    node = ceil(dof / 2);

    if mod(dof,2) == 1
        Rx(node) = R(dof);   % x-direction
    else
        Ry(node) = R(dof);   % y-direction
    end
end
end