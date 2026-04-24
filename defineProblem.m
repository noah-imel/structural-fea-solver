function [nodes, elements, E, A] = defineProblem()

% [x (cord)(m), y (cord) (m), force (x) (N), force (y) (N), fixedDOF (x), fixedDOF (y)]
% Structure must be sufficiently constrained to prevent rigid body motion
nodes = [0, 0, 0, 0, 1, 1;
         20, 10, 200000, -200000, 0, 0;
         10, 0, 0, 0, 0, 0;
         10, 10, 0, 0, 0, 1;
         ];

%elements = [node# node#, etc];
elements = [1 3; 1 4; 3 4; 3 2; 4 2];

% Example material properties
E = 200e9; 
A = 5e-3;

end