x = 1:20;
an = [-1.888 1];
bn = [1 2 1 6];
[y_n] = Filter(an,bn,x);

y_n_2 = filter(bn, an, x);
%% Interpolation example
[y_n] = Interpolate(2,x);
%% Decimation example
N = 100;
discreate_time_domain = 0:N-1;
[x1] = Sine(3,N,0);
[x2] = Sine(10,N,0);
x = x1 + x2;
D = 2;
[y_n] = Decimate(D, x);

figure(999); clf; hold all;
plot(discreate_time_domain, x, '-*', 'DisplayName', 'X[n]');
plot(discreate_time_domain(1:D:end), y_n, '--*r', 'DisplayName', 'Decimated X[n]')
legend;
%% 
S = load('laughter.mat');
