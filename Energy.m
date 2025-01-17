function [energy] = Energy(x_n)
energy = sqrt(Prod(x_n, Conj(x_n)));
end