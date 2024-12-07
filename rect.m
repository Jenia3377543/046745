function [y_n] = rect(a,b,N)
discrete_time_domain = 0:N-1;

y_n = (discrete_time_domain >= a) & (discrete_time_domain < b);
y_n = y_n / sum(y_n);
end