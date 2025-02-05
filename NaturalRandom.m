function [x, x_15] = NaturalRandom(N, m_mu, sigma_m, s_mu, sigma_s)
arguments
    N
    % Parameters for gaussian center
    m_mu    = 512
    sigma_m = 2048

    % Parameter for gaussian scale
    s_mu    = 128
    sigma_s = 64
end
% Sample random sines amplitudes
a = Rand(5);
a = Scalar(4, a);
a = Add(a, -2);

% Sample random sines frequencies
f = Rand(5);
f = Scalar(100, f);
f = Add(f, 50);

% Define base sine signals
[s_n1, ~] = Sine(f(1),N);
y_n1 = Scalar(a(1), s_n1.');

[s_n2, ~] = Sine(f(2),N);
y_n2 = Scalar(a(2), s_n2.');

[s_n3, ~] = Sine(f(3),N);
y_n3 = Scalar(a(3), s_n3.');

[s_n4, ~] = Sine(f(4),N);
y_n4 = Scalar(a(4), s_n4.');

[s_n5, ~] = Sine(f(5),N);
y_n5 = Scalar(a(5), s_n5.');

% Sample gaussians parameters
m = Rand(5);
m = Scalar(m, sigma_m);
m = Add(m, m_mu);

s = Rand(5);
s = Scalar(s, sigma_s);
s = Add(s, s_mu);

discrete_time_domain = 0:N-1;

[g_n1, ~] = Gauss(m(1),s(1),N,'discrete_time_domain', discrete_time_domain);
[g_n2, ~] = Gauss(m(2),s(2),N,'discrete_time_domain', discrete_time_domain);
[g_n3, ~] = Gauss(m(3),s(3),N,'discrete_time_domain', discrete_time_domain);
[g_n4, ~] = Gauss(m(4),s(4),N,'discrete_time_domain', discrete_time_domain);
[g_n5, ~] = Gauss(m(5),s(5),N,'discrete_time_domain', discrete_time_domain);

x_n1 = Prod(y_n1, g_n1);
x_n2 = Prod(y_n2, g_n2);
x_n3 = Prod(y_n3, g_n3);
x_n4 = Prod(y_n4, g_n4);
x_n5 = Prod(y_n5, g_n5);

x = Add(x_n1, x_n2);
x = Add(x, x_n3);
x = Add(x, x_n4);
x = Add(x, x_n5);

x_15 = cat(1, x_n1, x_n2, x_n3, x_n4, x_n5);
end