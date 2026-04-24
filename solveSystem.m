function Uf = solveSystem(Kff, Ff)

% ------------------------------------------------------------
% FUNCTION NAME: solveSystem
%
% PURPOSE:
%   Solve the reduced linear system Kff * Uf = Ff.
%
% INPUTS:
%   Kff - reduced stiffness matrix
%   Ff  - reduced force vector
%
% OUTPUTS:
%   Uf  - displacements at free DOFs
% ------------------------------------------------------------

Uf = Kff \ Ff;

end