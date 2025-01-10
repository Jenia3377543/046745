
N = 512;

discrete_time_domain = (0:N-1)/N;
x = sin(2 * pi * 5 * discrete_time_domain) + sin(2 * pi * 55 * discrete_time_domain);

figure; 
plot(discrete_time_domain, x, '--*');
%%
M = 2;
Nfft = length(x)/M;

[W] = STFT(x, M);
W = fftshift(W, 2);

freq_domain = N * (-Nfft/2:Nfft/2-1)/Nfft;
figure;
imagesc(abs(W));
xticks(0:Nfft-1);
xticklabels(compose("%f", freq_domain));

figure;
plot(freq_domain, abs(W));
%% Section 3
% clc; clear all; close all;
delta_time = 1;
N = 4096;
Fs = N / delta_time;
[noise_n] = WGN(N,0,1);

% WGN with LPF
Fc = 500;              % Cutoff frequency (Hz)
freq_domain = Fs * (-N/2:N/2-1) / N;
h = designfilt('lowpassiir','FilterOrder',15,'HalfPowerFrequency',Fc/(Fs/2));
[num,den] = tf(h);

figure;
freqz(h);

noise_n_lpf = Filter(den, num, noise_n);

figure; 
plot(freq_domain, abs(fftshift(fft(noise_n_lpf, N))), '--*');
xlabel('Freq domain[Hz]');
ylabel('|Amplitude|');
title(compose('Low passed WGN, F_c=%.2f[Hz]', Fc));

% WGN with HPF
h = designfilt('highpassiir','FilterOrder',15,'HalfPowerFrequency',Fc/(Fs/2));
[num,den] = tf(h);

figure;
freqz(h);

noise_n_hpf = Filter(den, num, noise_n);

figure; 
plot(freq_domain, abs(fftshift(fft(noise_n_hpf, N))), '--*');
xlabel('Freq domain[Hz]');
ylabel('|Amplitude|');
title(compose('High passed WGN, F_c=%.2f[Hz]', Fc));
% Known 5 frequencies

% Random 5 frequencies
