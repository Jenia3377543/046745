function [y_n] = Sine(f,N,ph)
discrete_time_domain = 0:N-1;
y_n = sin(2*pi*f*discrete_time_domain/N + ph);
end