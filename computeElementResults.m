function [delta_e, N_e, sigma_e] = computeElementResults(U, nodes, elements, elementDOFs, E, A)

% ------------------------------------------------------------
% FUNCTION NAME: computeElementResults
%
% PURPOSE:
%   Compute axial deformation, force, and stress in each element.
%
% INPUTS:
%   U            - global displacement vector
%   nodes        - node coordinate matrix
%   elements     - element connectivity matrix
%   elementDOFs  - DOF mapping for each element
%   E            - Young's modulus (Pa)
%   A            - cross-sectional area (m^2)
%
% OUTPUTS:
%   delta_e      - axial deformation of each element
%   N_e          - axial force in each element (N)
%   sigma_e      - axial stress in each element (Pa)
% ------------------------------------------------------------

numElements = size(elements, 1);

% Store element results
delta_e = zeros(numElements, 1);
N_e = zeros(numElements, 1);
sigma_e = zeros(numElements, 1);

for e = 1:numElements
    n1 = elements(e, 1);
    n2 = elements(e, 2);

    x1 = nodes(n1, 1);
    y1 = nodes(n1, 2);
    x2 = nodes(n2, 1);
    y2 = nodes(n2, 2);

    L = sqrt((x2 - x1)^2 + (y2 - y1)^2);
    c = (x2 - x1) / L;
    s = (y2 - y1) / L;

    dofs = elementDOFs(e, :);
    Ue = U(dofs); % extract element displacement vector

    delta_e(e) = [-c, -s, c, s] * Ue;
    N_e(e) = (A * E / L) * delta_e(e);
    sigma_e(e) = N_e(e) / A; % Calculate stress in each element
end
end