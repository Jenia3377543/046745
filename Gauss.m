function [y_n] = Gauss(u,s,N)
discrete_time_domain = 0:N-1;
y_n = exp(-((discrete_time_domain - u).^2)/s^2);
y_n = y_n / sum(y_n);
end