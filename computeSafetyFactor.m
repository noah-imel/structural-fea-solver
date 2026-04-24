function [FS, FS_min, idx_min] = computeSafetyFactor(sigma_e)

% Safety Factor of structural steel
sigma_yield = 250e6; % Example yield strength for structural steel
FS = zeros(size(sigma_e));
tol = 1e-12 * max(abs(sigma_e));
mask = abs(sigma_e) > tol;

FS(mask) = sigma_yield ./ abs(sigma_e(mask));
FS(~mask) = Inf;

[FS_min, idx_min] = min(FS);

end