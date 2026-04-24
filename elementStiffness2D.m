function ke = elementStiffness2D(x1, y1, x2, y2, E, A)

% ------------------------------------------------------------
% FUNCTION NAME: elementStiffness2D
%
% PURPOSE:
%   Compute the 4x4 stiffness matrix for a 2D truss element
%   in global coordinates.
%
% INPUTS:
%   x1, y1 - coordinates of node 1 (m)
%   x2, y2 - coordinates of node 2 (m)
%   E      - Young's modulus (Pa)
%   A      - cross-sectional area (m^2)
%
% OUTPUTS:
%   ke     - 4x4 element stiffness matrix (N/m)
%
% NOTES:
%   Assumes linear elastic behavior and axial deformation only.
% ------------------------------------------------------------

L = sqrt((x2 - x1)^2 + (y2 - y1)^2); % element length
c = (x2 - x1) / L; % cos(theta)
s = (y2 - y1) / L; % sin(theta)

ke = (A * E / L) * [ c^2,  c*s, -c^2, -c*s;
                     c*s,  s^2, -c*s, -s^2;
                    -c^2, -c*s,  c^2,  c*s;
                    -c*s, -s^2,  c*s,  s^2 ];

end