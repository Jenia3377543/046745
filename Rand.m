function [y] = Rand(N)
arguments
    N 
end
% Sample N samples from uniform distribution
y = rand(N, 1);
end