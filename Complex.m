function [y] = Complex(f,N)
arguments
    f (1, :)
    N {mustBeInteger}
end
discrete_time_domain = (0:N-1)';
y = exp(1j*2*pi*f.*discrete_time_domain);
end