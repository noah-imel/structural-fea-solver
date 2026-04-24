function [K, Fglobal, fixedDOF, elementDOFs] = buildSystem(nodes, elements, E, A)

% Basic Counts
numElements = size(elements, 1);
numNodes = size(nodes, 1);

% ----------------------------
% DEGREE OF FREEDOM (DOF) MAPPING
% ----------------------------
% Each node has 2 DOFs:
% DOF = [u1x, u1y, u2x, u2y, ...]
% Map each element to its 4 DOFs
elementDOFs = getElementDOFs(elements);



% ----------------------------
% ELEMENT STIFFNESS MATRIX
% ----------------------------
% Compute stiffness matrix for each element
Ke = zeros(4, 4, numElements);

for e = 1:numElements
    n1 = elements(e, 1);
    n2 = elements(e, 2);

    x1 = nodes(n1, 1);
    y1 = nodes(n1, 2);
    x2 = nodes(n2, 1);
    y2 = nodes(n2, 2);

   Ke(:, :, e) = elementStiffness2D(x1, y1, x2, y2, E, A);
end

% ----------------------------
% GLOBAL STIFFNESS ASSEMBLY
% ----------------------------
% Assemble all element matrices into global K
K = assembleGlobalK(Ke, elementDOFs, numNodes);

% ----------------------------
% LOADS AND BOUNDARY CONDITIONS
% ----------------------------
totalDOF = 2 * numNodes;

Fglobal = zeros(totalDOF, 1);
fixedDOF = [];

for i = 1:numNodes
    % Apply nodal forces
    Fglobal(2*i-1) = nodes(i, 3); % Fx
    Fglobal(2*i)   = nodes(i, 4); % Fy

    % Apply boundary conditions
    if nodes(i, 5) == 1
        fixedDOF(end+1) = 2*i-1;
    end
    if nodes(i, 6) == 1
        fixedDOF(end+1) = 2*i;
    end
end
end
