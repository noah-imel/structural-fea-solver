function K = assembleGlobalK(Ke, elementDOFs, numNodes)

% ------------------------------------------------------------
% FUNCTION NAME: assembleGlobalK
%
% PURPOSE:
%   Assemble the global stiffness matrix from element matrices.
%
% INPUTS:
%   Ke           - element stiffness matrices (4x4xnumElements)
%   elementDOFs  - mapping of element DOFs (numElements x 4)
%   numNodes     - total number of nodes
%
% OUTPUTS:
%   K            - global stiffness matrix (2*numNodes x 2*numNodes)
% ------------------------------------------------------------

K = zeros(2 * numNodes, 2 * numNodes);

numElements = size(elementDOFs, 1);

for e = 1:numElements
    dofs = elementDOFs(e, :); % global DOFs for element e
    K(dofs, dofs) = K(dofs, dofs) + Ke(:, :, e);
end

end