function [Kff, Ff, freeDOF] = applyBCs(K, Fglobal, fixedDOF)

% ------------------------------------------------------------
% FUNCTION NAME: applyBCs
%
% PURPOSE:
%   Apply boundary conditions by reducing the system to free DOFs.
%
% INPUTS:
%   K        - global stiffness matrix
%   Fglobal  - global force vector
%   fixedDOF - constrained DOF indices
%
% OUTPUTS:
%   Kff      - reduced stiffness matrix
%   Ff       - reduced force vector
%   freeDOF  - indices of free DOFs
% ------------------------------------------------------------

% Determine free DOFs
allDOF = 1:length(Fglobal);
freeDOF = setdiff(allDOF, fixedDOF);

% Reduce System
Kff = K(freeDOF, freeDOF);
Ff = Fglobal(freeDOF);

end