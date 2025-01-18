clc; clear all; close all;
addpath(genpath('.\PlotUtils2'));
%% Tools upgrade
% We have created the Rand, Conj, Threshold, Complex, STFT and ISTFT blocks.
% We implemented STFT\ISTFT as polyphase filters (decimation\interpolation and
% filtering with "DFT" filter, which is defined using Complex block). 
% Since the polyphase filters in this case is scalars so we apply them
% using Scalar block.
% 
% The STFT\ISTFT was divided into multiple steps (smaller blocks):
% 
% * Getting i element from DFT signal for k frequency - polyphase filter for delay i and frequency k
% * STFT_k - computes STFT for frequency k
% 
% so then we call these blocks to fill the STFT\ISTFT matrices.
% The ISTFT was implemented using polyphase filters and Interpolation block
% from HW1. In addition we have defined Circshift which was applied after
% the interpolation in order tp align samples in the time domain for each
% frame. Using this implementation there is no redundant multiplications and its
% memory efficient.
fontSize = 20;

figure;
imshow(imread("blocks2\Rand.png"));
title("Rand block diagram", 'FontSize', fontSize);

figure;
imshow(imread("blocks2\Conj.png"));
title("Conj block diagram", 'FontSize', fontSize);

figure;
imshow(imread("blocks2\Threshold.png"));
title("Threshold block diagram", 'FontSize', fontSize);

figure;
imshow(imread("blocks2\Complex.png"));
title("Complex block diagram", 'FontSize', fontSize);

figure;
imshow(imread("blocks2\Circshift.png"));
title("Circshift block diagram", 'FontSize', fontSize);

figure;
imshow(imread("blocks2\Mag2db.png"));
title("Mag2db block diagram", 'FontSize', fontSize);

figure;
imshow(imread("blocks2\STFT-k.png"));
title("STFT-k block diagram", 'FontSize', fontSize);

figure;
imshow(imread("blocks2\STFT.png"));
title("STFT block diagram", 'FontSize', fontSize);

figure;
imshow(imread("blocks2\ISTFT-k.png"));
title("ISTFT-k block diagram", 'FontSize', fontSize);

figure;
imshow(imread("blocks2\ISTFT.png"));
title("ISTFT block diagram", 'FontSize', fontSize);
%% Section 3
delta_time = 1;
N = 4096;
Fs = N / delta_time;
[noise_n] = WGN(N,0,1);
%% WGN with LPF
% First, lets design IIR LPF, with $Fc=500[Hz]$ and apply it on WGN using
% Filter function from HW1.
Fc = 500;              % Cutoff frequency (Hz)
freq_domain = Fs * (-N/2:N/2-1) / N;
h = designfilt('lowpassiir','FilterOrder',15,'HalfPowerFrequency',Fc/(Fs/2));
[num,den] = tf(h);

% The designed filter:
figure;
freqz(h);

noise_n_lpf = Filter(den, num, noise_n);

% The low-passed WGN (we take high order (15) filter in order to obtain
% sharp filtering).
figure; 
plot(freq_domain, abs(fftshift(fft(noise_n_lpf, N))), '--*');
xlabel('Freq domain[Hz]');
ylabel('|Amplitude|');
title(compose('Low passed WGN, F_c=%.2f[Hz]', Fc));

%% WGN with HPF
% Now, lets design IIR HPF, with the same $Fc=500[Hz]$ and procced the same
% flow as with LPF.

h = designfilt('highpassiir','FilterOrder',15,'HalfPowerFrequency',Fc/(Fs/2));
[num,den] = tf(h);

% The designed HPF:
figure;
freqz(h);

noise_n_hpf = Filter(den, num, noise_n);

% The high-passed WGN (similarly to LPF we take 15 order in order to obtain
% sharp filtering).
figure; 
plot(freq_domain, abs(fftshift(fft(noise_n_hpf, N))), '--*');
xlabel('Freq domain[Hz]');
ylabel('|Amplitude|');
title(compose('High passed WGN, F_c=%.2f[Hz]', Fc));

%% Known 5 frequencies
% We define 5 sinusoidal signal using Sine func
% from HW1 at [16, 32, 48, 64, 80] [Hz].
f1_5 = (16:16:90)';
[y_n_f1_f5, discrete_time_domain] = Sine(f1_5,N,0);

figure;
plot(discrete_time_domain(1:256), y_n_f1_f5(1:256, :));
legend(compose("%.2f [Hz]", f1_5));
title('5 known frequencies in time domain');
ylabel('Amplitude');
xlabel('Time domain[sec]');
%% Random 5 frequencies
% We sample 5 random frequencies using Rand block, scale them to [0, 30]
% Offset to [30, 60] using Add block from HW1
% And create sinusoidal signal using Sine block.
f1_5_rand = Rand(5);
f1_5_rand = Scalar(30, f1_5_rand);
f1_5_rand = Add(30, f1_5_rand);
[y_n_f1_f5_rand, discrete_time_domain] = Sine(f1_5_rand,N,0);

figure;
plot(discrete_time_domain(1:256), y_n_f1_f5_rand(1:256, :));
legend(compose("%.2f [Hz]", f1_5_rand));
title('5 random frequencies in time domain');
ylabel('Amplitude');
xlabel('Time domain[sec]');
%% Signal games
%% Signal Example 1 - Filtering in the Frequency Domain
% Filtering white Gaussian noise (WGN) using a threshold block in the frequency domain.
% Let’s consider signals with known frequencies chosen such that they align directly with 
% discrete frequency bins. This ensures no energy spreading in the frequency domain, allowing 
% us to easily identify the expected energy at each frequency bin. As discussed in class, 
% the energy in the frequency domain for a pure sine or cosine wave is equal to M/2
% M/2 at each delta. To filter out WGN, we set the threshold th = M/2.
% As demonstrated, the noise is effectively filtered out. The STFT reveals four deltas 
% at ±16 Hz and ±80 Hz as expected, with no remaining noise, since it has been completely removed. 
% This approach is effective because the frequencies align perfectly with the DFT bins, 
% making it straightforward to determine the filtering threshold. 
% However, if the frequencies did not align directly with the bins, 
% identifying an appropriate threshold would be more challenging.

M = 512;
freq_domain = Fs * (-M/2:M/2-1)/M;
ticks_indices = 1:8:M;

figure;
imshow(imread('example2\HW2-Example1a.png'));
title('Example #1 block diagram', 'FontSize', fontSize);

figure;
imshow(imread('blocks2\Energy.png'));
title('Energy block diagram', 'FontSize', fontSize);

figure;
imshow(imread('example2\HW2-Example1b.png'));
title('Filtering proccess block diagram', 'FontSize', fontSize);

x_n1 = Add(Add(Scalar(1.5, y_n_f1_f5(:, 1)), Scalar(2, y_n_f1_f5(:, 5))), noise_n');
W = STFT(x_n1, M);

[energy] = Energy(W);
Wf = Prod(W, Threshold(energy, M/2));
xnr = ISTFT(Wf);

figure;
nexttile;
sgtitle({'Example #1', 'Filtering in frequency domain'});
plot(discrete_time_domain, x_n1);
title('Example #1, Signal in time domain');
xlabel('Time domain [sec]');
ylabel('Amplitude');

nexttile;
imagesc(Mag2db(abs(fftshift(W))));

xticks(ticks_indices);
xticklabels(compose("%.2f", freq_domain(ticks_indices)));
xlim(M/2 + 64 * [-1 1]);

title('STFT');
xlabel('Frequncy domain [Hz]');
ylabel('Window index');
colorbar2();

nexttile;
plot(discrete_time_domain, real(xnr));
title('Filtered signal');
xlabel('Time domain [sec]');
ylabel('Amplitude');

nexttile;
imagesc(Mag2db(abs(fftshift(Wf))));

xticks(ticks_indices);
xticklabels(compose("%.2f", freq_domain(ticks_indices)));
xlim(M/2 + 64 * [-1 1]);

title('STFT after denoising');
xlabel('Frequncy domain [Hz]');
ylabel('Window index');
colorbar2();

%% Signal Example 2 - Filtering in time domain
% The simplest low-pass filter is a moving average filter. 
% Here, we define the LPF coefficients as ones(1,10)/10 and apply it as an FIR filter 
% using the Filter function from HW1. The intuition behind this approach is that averaging 
% consecutive samples results in values that are closer to the mean, reducing the impact of 
% extreme values. This smooths out rapid changes in the signal.
% As observed, the reconstructed signal becomes smoother, with significantly less distortion, 
% although some noise remains. In the STFT, we notice reduced 
% energy at higher frequencies, indicating that parts of the WGN have been effectively filtered out.
% As expected, both the original and filtered signals display four distinct delta components 
% at ±32 Hz and ±64 Hz. This approach works well because the signal-to-noise ratio
% is relatively high, meaning there is meaningful information in closely spaced samples in the 
% time domain.

ticks_indices = 1:8:M;

figure;
imshow(imread('example2\HW2-Example2a.png'));
title('Example #2 block diagram', 'FontSize', fontSize);


figure;
imshow(imread('example2\HW2-Example2b.png'));
title('Filtering proccess block diagram', 'FontSize', fontSize);

x_n_2 = Add(Add(Scalar(3, y_n_f1_f5(:, 2)), Scalar(2, y_n_f1_f5(:, 4))), noise_n_hpf(1:N)');
LPF = ones(1, 10) / 10;
y_n_2 = Filter(1, LPF, x_n_2); y_n_2 = buffer(y_n_2, N);

W_x_2 = STFT(x_n_2, M);
W_y_2 = STFT(y_n_2, M);


figure;
nexttile;
sgtitle({'Example #2', 'Filtering in time domain'});
plot(x_n_2, 'DisplayName', 'X_2[n]');
title('X[n] in time domain');
xlabel('Time domain [sec]');
ylabel('Amplitude');

nexttile;
plot(y_n_2, 'DisplayName', 'Y_2[n]');
title('Filtered X[n] in time domain');
xlabel('Time domain [sec]');
ylabel('Amplitude');

nexttile;
imagesc(Mag2db(abs(fftshift(W_x_2))));

xticks(ticks_indices);
xticklabels(compose("%.2f", freq_domain(ticks_indices)));
xlim(M/2 + 64 * [-1 1]);

title('STFT');
xlabel('Frequncy domain [Hz]');
ylabel('Window index');
colorbar2();

nexttile;
imagesc(Mag2db(abs(fftshift(W_y_2))));

xticks(ticks_indices);
xticklabels(compose("%.2f", freq_domain(ticks_indices)));
xlim(M/2 + 64 * [-1 1]);

title('STFT after time domain filtering (FIR)');
xlabel('Frequncy domain [Hz]');
ylabel('Window index');
colorbar2();
%% Signal Example 3 - Filtering in frequency and time domain
% In this example, we will filter a signal composed of an amplified high-pass filtered 
% white Gaussian noise combined with two random sinusoidal signals, amplified 
% by factors of 3 and 2. The noise power is comparable to the power of the 
% sinusoidal signals, making it challenging to filter out the noise as in the previous example. 
% To extract the desired signal, we first apply a LPF in the time domain. 
% This reduces the high-frequency noise while minimally affecting the data signal. 
% Next, the signal is passed through a thresholding block to completely eliminate the remaining 
% noise.

figure;
imshow(imread('example2\HW2-Example3a.png'));
title('Example #3 block diagram', 'FontSize', fontSize);

figure;
imshow(imread('example2\HW2-Example3b.png'));
title('Filtering proccess block diagram', 'FontSize', fontSize);

M = 512;
freq_domain = Fs * (-M/2:M/2-1)/M;
ticks_indices = 1:8:M;
x_n_3_clean = Add(Scalar(3, y_n_f1_f5_rand(:, 2)), Scalar(2, y_n_f1_f5_rand(:, 4)));
x_n_3 = Add(x_n_3_clean, 35 * noise_n_hpf(1:N)');
y_n_3_time_filtered = Filter(1, LPF, x_n_3); y_n_3_time_filtered = buffer(y_n_3_time_filtered, N);

STFT_y_3 = STFT(x_n_3, M);

STFT_y_3_filtered = STFT(y_n_3_time_filtered, M);

[energy3] = Energy(STFT_y_3_filtered);
Wf3 = Prod(STFT_y_3_filtered, Threshold(energy3, M/2));
y_n_3_time_filtered_TF_domain = ISTFT(Wf3);
%%
figure('Position', [0 0 900 600]);
nexttile;
sgtitle({'Example #3', 'Filtering in time and frequency domain'});
plot(x_n_3_clean);
title('Clean signal');
xlabel('Time domain[samples]');
ylabel('Amplitude');

nexttile;
plot(x_n_3);
title('Input signal');
xlabel('Time domain[samples]');
ylabel('Amplitude');

nexttile;
imagesc(Mag2db(fftshift(abs(STFT_y_3))));
title('STFT - Input signal');
xlabel('Freq domain[Hz]');
ylabel('Time domain');

xticks(ticks_indices);
xticklabels(compose("%.2f", freq_domain(ticks_indices)));
xlim(M/2 + 128 * [-1 1]);
colorbar2();

nexttile;
imagesc(Mag2db(fftshift(abs(STFT_y_3_filtered))));
title({'STFT', 'Filtering in time domain'});
xlabel('Freq domain[Hz]');
ylabel('Time domain');
xticks(ticks_indices);
xticklabels(compose("%.2f", freq_domain(ticks_indices)));
xlim(M/2 + 64 * [-1 1]);
colorbar2();

nexttile;
imagesc(Mag2db(fftshift(abs(Wf3))));
title({'STFT', 'Filtering in time and frequency domain'});
xlabel('Freq domain[Hz]');
ylabel('Time domain');
xticks(ticks_indices);
xticklabels(compose("%.2f", freq_domain(ticks_indices)));
xlim(M/2 + 64 * [-1 1]);
colorbar2();

nexttile;
plot(real(y_n_3_time_filtered_TF_domain));
title('Filtered signal in time domain');
xlabel('Time domain[samples]');
ylabel('Amplitude');