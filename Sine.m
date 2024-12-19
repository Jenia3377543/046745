function [y_n, discrete_time_domain] = Sine(f,N,ph,discrete_time_domain)
arguments
    f 
    N 
    ph 
    discrete_time_domain = (0:N-1) / N
end
y_n = sin(2*pi*f*discrete_time_domain + ph);
end