function [energy] = Energy(x_n)
energy = Prod(x_n, Conj(x_n));
end