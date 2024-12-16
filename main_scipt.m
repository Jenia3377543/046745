N = 60;

time_domain = linspace(0,1,N);

x = sin(2*pi*5*time_domain);
M = 200;
interp_time_domain = linspace(0,1,M*N);
x_interp = Interpolate(M, x);

figure(999);

nexttile; hold all;
plot(time_domain, x, '*', "DisplayName", "Base signal");

% nexttile;
plot(interp_time_domain, x_interp, "or", "DisplayName", "Jenia");
plot(interp_time_domain, interp(x, M), "xb", "DisplayName", "Built-in")
legend;