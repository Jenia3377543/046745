function [y_n, discrete_time_domain] = Rect(a,b,N,opts)
arguments
    a 
    b 
    N 
    opts.discrete_time_domain = (0:N-1)
    opts.NormalizeTD = false
end
NormalizeTD = opts.NormalizeTD;
discrete_time_domain = opts.discrete_time_domain;

if NormalizeTD
    discrete_time_domain = discrete_time_domain / N;
end
y_n = (discrete_time_domain >= a) & (discrete_time_domain < b);
y_n = y_n / sum(y_n);
end