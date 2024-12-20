addpath(genpath('PlotUtils'))
%% 
M = 5;
N = 100;
[x_n, dtd] = Sine(5,N,WGN(N, 0, pi/25));

y_n = Interpolate(M, x_n);
interpolated_domain = (0:N*M-1)/(N*M);

figure(999); clf; hold all; 
plot(dtd, x_n, '--*', 'DisplayName', 'x[n]');
plot(interpolated_domain, y_n, '--*', 'DisplayName', 'Interpolated x[n]');
legend;

figure(998); clf; hold all;
plot(Filter(1, [1, -1], x_n), '--*')