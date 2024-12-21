clc; clear all; close all;
addpath(genpath('PlotUtils'))
%% Part 2
%% Example 1
% As an input signal we take:
% 
% * $y_[n]=sin(2\pi\cdot5n/N) + 5*sin(2\pi\cdot10n/N)$
%
% The interpolation added points that are placed on the original signal,
% there is no distortion or artifacts because the signal is smooth.
figure;
imshow(imread('blocks\Example1.png'));
title('Example 1 - block diagram');

N = 100;
[x_n1, dtd1] = Sine(5, N, 0);
[x_n2, dtd2] = Sine(10, N, 0);

x_n = x_n1 + 5*x_n2;
M = 5;

x_n_interpolated = Interpolate(M, x_n);

figure; nexttile;
plot(dtd1, x_n, '--*', 'DisplayName', 'x[n]');
xlabel('Time [sec]');
ylabel('Amplitude');
title('Example 2');
legend;

N_samples = length(x_n_interpolated);
nexttile;
plot((0:N_samples-1)/N_samples, x_n_interpolated, '--*', 'DisplayName', 'Interpolated x[n]');
xlabel('Time [sec]');
ylabel('Amplitude');
title('Example 2');
legend;
%% Mean and variance
% The mean of the signal is zero (because its integral over 2 sines over 5 and 10 period)
% 
% And the variance is:
% $1/N\sum^N (sin_1 + 5sin_2)^2 = 1/N\sum^N sin_1^2+25sin_2^2+2sin_1 * 5sin_2 = 0.5 + 25*0.5 + 0 = 13$

x_n_mean = mean(x_n)
x_n_var = var(x_n)
%% Example 2
% As an input signal we will take the signal from previous example and add additive noise to it:
% 
% * $y_[n]=sin(2\pi\cdot5n/N) + 5*sin(2\pi\cdot10n/N) + WGN(1, 1)$
% 
% Additionaly we apply decimation with LPF, as we see it slightly improve
% distortion because some of the high frequencies filtered out (that was
% part of WGN).
%
figure;
imshow(imread('blocks\Example2.png'));
title('Example 2 - block diagram');

N = 1000;
[x_n1, dtd1] = Sine(5, N, 0);
[x_n2, dtd2] = Sine(10, N, 0);

noise = WGN(N, 1, 1);

x_n = x_n1 + 5*x_n2 + noise;
M = 3;

x_n_interpolated = Decimate(M, x_n);

figure; nexttile;
plot(dtd1, x_n, '--*', 'DisplayName', 'x[n]');
xlabel('Time [sec]');
ylabel('Amplitude');
title('Example 2');
legend;

N_samples = length(x_n_interpolated);
nexttile;
plot((0:N_samples-1)/N_samples, x_n_interpolated, '--*', 'DisplayName', 'Decimated x[n]');
xlabel('Time [sec]');
ylabel('Amplitude');
title('Example 2');
legend;
%% Mean and variance
% The mean of the signal is equal to the mean of noise (because its integral over 2 sines over 5 and 10 period is zeros)
% 
% And the variance is:
% $1/N\sum^N (sin_1 + 5sin_2 -\mu)^2 = 1/N\sum^N sin_1^2+25sin_2^2+2sin_1 * 5sin_2 = 0.5 + 25*0.5 + 0 = 13$

x_n_mean = mean(x_n)
x_n_var = var(x_n)
%% Example 3
% Now we will simulate Transmitter-Reciever chain.
% As an input signal we take:
% 
% * $y_1[n]=sin(2\pi\cdot5n/N)$
% 
% We modulate it using the carrier:
% 
% * $y_c[n]=sin(2\pi\cdot150n/N+pi)$
% 
% And then, demodulate it using the same carrier.
%
% We suppose that the baseband signal was sampled at low frequency so we
% interpolate it in order to apply "digital" modulation using prod function from previous section.
% Afterwards, we decimate the recieved signal.

figure;
imshow(imread('blocks\TX.png'));
title('TX block diagram');

figure;
imshow(imread('blocks\RX.png'));
title('RX block diagram');

M = 10;
D = 10;

N_baseband = 64;
N_passband = 640;

[x_n_baseband, dtd] = Sine(5,N_baseband,0);
[x_carrier, dtd] = Sine(150,N_passband,pi);

x_n_baseband_interpolated = Interpolate(M, x_n_baseband);

x_n_modulated = Prod(x_n_baseband_interpolated, x_carrier);
x_n = x_n_modulated + WGN(N_passband, 0, 1);
% Demodulator
x_n_demodulated = Prod(x_n, x_carrier);
freq_domain = (-N_passband/2:N_passband/2-1);

x_n_baseband_decimated = Decimate(D, x_n_demodulated);
N_samples_decimated = length(x_n_baseband_decimated);
freq_domain_decimated = (-N_samples_decimated/2:N_samples_decimated/2-1);
%% Baseband signal
% The signal in baseband composed of 2 deltas at $+-5[Hz]$.
% The signal has finite BW so the interpolation "added" points on the sine
% and there is no distortion\artifacts (because the signal is smooth and with finite BW).

figure;
plot(freq_domain_decimated, abs(fftshift(fft(x_n_baseband))), '--*');
xlabel('Frequency[Hz]');
ylabel('Amplitude');
title('Signal (Baseband)');

figure;
title('x[n] vs Interpolated x[n]');
nexttile;
plot(x_n_baseband, '--*', 'DisplayName', 'x[n]');
xlabel('Time[samples]'); ylabel('Amplitude');
legend;

nexttile;
plot(x_n_baseband_interpolated, '--*', 'DisplayName', 'x[n] interpolated');
xlabel('Time[samples]'); ylabel('Amplitude');
legend;
%% Modulated signal
% The modulated signal, composed of 4 deltas at $+-145[Hz]$ and $+-155[Hz]$
% because of multiplication between the baseband signal and carrier at
% $150[Hz]$. Also additive noise were added, so "flat" spectrum in addition
% to the sine.

figure;
plot(freq_domain, abs(fftshift(fft(x_n_modulated))), '--*');
xlabel('Frequency[Hz]');
ylabel('Amplitude');
title('Modulated signal (Passband)');

%% Demodulated signal
% After the demodulation, we get 6 deltas $+-5[Hz]$ and $+-305[Hz]$,
% $+-295[Hz]$, because of the carrier that created "images" to the desired
% baseband signal.

figure;
plot(freq_domain, abs(fftshift(fft(x_n_demodulated))), '--*');
xlabel('Frequency[Hz]');
ylabel('Amplitude');
title('Demodulated signal (Baseband)');

%% Decimated signal
% The desired signal placed around $+-5[Hz]$ so we can decimate the sample
% rate by 10. The decimation function contains LPF so the "images" were
% filtered out. Also, we can see that the signal is noised (thats because
% of the WGN noise). The signal we get after decimation is smoothed and
% that because of LPF that filter out some of high frequencies (fast
% uncorrelated changes is due to WGN noise).


figure;
plot(freq_domain_decimated, abs(fftshift(fft(x_n_baseband_decimated))), '--*');
xlabel('Frequency[Hz]');
ylabel('Amplitude');
title('Decimated signal (Baseband)');

figure;
title('x[n] vs Decimated x[n]');
nexttile;
plot(x_n_demodulated, '--*', 'DisplayName', 'x[n]');
xlabel('Time[samples]'); ylabel('Amplitude');
legend;

nexttile;
plot(x_n_baseband_decimated, '--*', 'DisplayName', 'x[n] interpolated');
xlabel('Time[samples]'); ylabel('Amplitude');
legend;

%% Mean and Variance
% The mean of the signal is zero (integral over sine over 5 period)
% The variance is 0.5 (known result because it's mean of squared sine)

x_n_mean = mean(x_n_baseband)
x_n_var  = var(x_n_baseband)
