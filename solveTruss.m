function [U, freeDOF] = solveTruss(K, Fglobal, fixedDOF)

[Kff, Ff, freeDOF] = applyBCs(K, Fglobal, fixedDOF);

% ----------------------------
% SOLVE SYSTEM
% ----------------------------
% Solve for Kff * Uf = Ff
Uf = solveSystem(Kff, Ff);

% Reconstruct full displacement vector including constrained DOFs
U = zeros(size(Fglobal));
U(freeDOF) = Uf;
end