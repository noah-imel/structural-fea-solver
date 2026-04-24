function elementDOFs = getElementDOFs(elements)
% getElementDOFs
% Maps each element to its global DOFs
%
% Input:
%   elements : [numElements x 2] node connectivity
%
% Output:
%   elementDOFs : [numElements x 4] DOF indices

numElements = size(elements, 1);

elementDOFs = zeros(numElements, 4);

for e = 1:numElements
    n1 = elements(e, 1);
    n2 = elements(e, 2);

    elementDOFs(e, :) = [2 * n1 - 1, 2 * n1, 2 * n2 - 1, 2 * n2];
end
end