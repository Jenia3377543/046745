function PlotRect(y_n, legend_str, time_domain)
arguments
    y_n
    legend_str
    time_domain = (0:length(y_n)-1)/length(y_n)
end
N = length(y_n);
freq_domain = pi * (-N/2:N/2-1) / N;
fft_y_n = fftshift(fft(y_n));

figure;
nexttile;
stem(time_domain, y_n);
ylim([0 1.1*max(y_n)]);
xlim([-5, N]);
xlabel('Time domain [sec]');
ylabel('Amplitude');

nexttile;
plot(freq_domain, abs(fft_y_n), '--*');
xticks([-pi/2, 0, pi/2]);
xticklabels(["-\pi/2", "0", "\pi/2"]);
xlabel('\omega[rad/sec]');
ylabel('|FFT{Rect}|');
sgtitle({compose("Rect example %s", legend_str), "Time domain vs Frequency Domain"});
end

