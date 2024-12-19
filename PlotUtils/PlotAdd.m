function PlotAdd(y_n,time_domain,legend_str)
arguments
    y_n
    time_domain
    legend_str
end

figure;
nexttile;
plot(time_domain, y_n, 'DisplayName', legend_str);
xlabel('Time domain [sec]');
ylabel('Amplitude');
legend;

N = length(y_n);
fft_y_n = fftshift(fft(y_n));
freq_domain = pi * (-N/2:N/2-1)/N;

nexttile;
plot(freq_domain, abs(fft_y_n), 'DisplayName', 'FFT{Y[N]}');
xlabel('\omega[rad/sec]');
ylabel('|FFT|');

xticks([-pi/2, 0, pi/2]);
xticklabels(["-\pi/2", "0", "\pi/2"]);
legend;
sgtitle({"Add example with additive noise", legend_str, "Time domain vs Frequency Domain"});

end

