function [y_n, discrete_time_domain] = Gauss(u,s,N,opts)
arguments
    u 
    s 
    N
    opts.discrete_time_domain = -N/2:N/2-1;
    opts.NormalizeTD = false
end
discrete_time_domain = opts.discrete_time_domain;
NormalizeTD = opts.NormalizeTD;

if NormalizeTD
    discrete_time_domain = discrete_time_domain / N;
end
y_n = exp(-((discrete_time_domain - u).^2)/s^2);
y_n = y_n / max(y_n);
end