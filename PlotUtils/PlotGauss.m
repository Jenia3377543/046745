function PlotGauss(y_n, legend_str, mu, sigma, time_domain)
arguments
    y_n
    legend_str
    mu
    sigma
    time_domain = (0:length(y_n)-1)/length(y_n)
end
N = length(y_n);
freq_domain = pi * (-N/2:N/2-1) / N;
fft_y_n = fftshift(fft(y_n));

figure;
nexttile;
plot(time_domain, y_n, '--*', 'DisplayName', compose("\\mu=%.0f, \\sigma=%.2f", mu, sigma));
ylim([0 1.1*max(y_n)]);
xlabel('Time domain [sec]');
ylabel('Amplitude');
legend;

nexttile;
plot(freq_domain, abs(fft_y_n), '--*');
xticks([-pi/2, 0, pi/2]);
xticklabels(["-\pi/2", "0", "\pi/2"]);
xlabel('\omega[rad/sec]');
ylabel('|FFT{Gauss}|');
sgtitle({compose("Gauss example %s", legend_str), "Time domain vs Frequency Domain"});
end

