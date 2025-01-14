clc; clear all; close all;
%% Tools upgrade
% We have created the Rand, Conj, Threshold, Complex, STFT and ISTFT blocks.
% Also we have defined DFT basis block that uses Complex block in order to
% define DFT projection matrix which can then used in STFT and ISTFT.

blocks2 = struct2table(dir("blocks2"));
blocks2 = blocks2(~ismember(blocks2.name, {'.', '..'}), :);
block_names = split(blocks2.name, '.'); block_names = block_names(:, 1);
blocks2_path = fullfile(blocks2.folder, blocks2.name);
for i = 1:size(blocks2_path, 1)
    figure;
    imshow(imread(blocks2_path{i, :}));
    title(compose("%s block diagram", string(block_names(i, :))))
end
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
% Define 5 known frequencies and create sinusoidal signal using Sine func
% from HW1.
f1_5 = (10:10:50)';
[y_n_f1_f5, discrete_time_domain] = Sine(f1_5,N,0);

figure;
plot(discrete_time_domain, y_n_f1_f5);
title('5 known frequencies in time domain');
ylabel('Amplitude');
xlabel('Time domain[sec]');
%% Random 5 frequencies
% Sample 5 random frequencies using Rand block, scale them to [0, 50]
% Offset to [50, 100] using Add block from HW1
% And create sinusoidal signal using Sine block.
f1_5_rand = Rand(5);
f1_5_rand = Scalar(50, f1_5_rand);
f1_5_rand = Add(50, f1_5_rand);
[y_n_f1_f5_rand, discrete_time_domain] = Sine(f1_5_rand,N,0);

figure;
plot(discrete_time_domain, y_n_f1_f5_rand);
title('5 random frequencies in time domain');
ylabel('Amplitude');
xlabel('Time domain[sec]');
%% Signal games
% Signal Example 1 - Filtering in frequency domain
% Filtering out WGN noise using threshold block in frequency domain.
% 
% Let's take a look at signals with known frequency. We have choose the
% frequencies s.t. they fall directly on discrete frequency bins, so there
% is no energy spread in frequency domain and we can find the expected
% energy at each frequency bin. As we have seen in class, the energy in
% frequency domain of pure sine\cosine equals to M/2 on each delta, so in order to filter out
% WGN lets choose th=$M/3$. As we can see, we have filtered out the noise.
% In the STFT we can see some noise in high frequncies and 4 deltas at
% +-10[Hz] and +-50[Hz] as expected.

M = 2048;
freq_domain = Fs * (-M/2:M/2-1)/M;
figure;
imshow(imread('blocks2\HW2-Example1.png'));
title('Example 1 block diagram');

figure;
imshow(imread('blocks2\Energy.png'));
title('Energy block diagram');

figure;
imshow(imread('blocks2\HW2-Example1b.png'));
title('Filtering proccess block diagram');

x_n1 = Scalar(1.5, y_n_f1_f5(:, 1)) + Scalar(2, y_n_f1_f5(:, 5)) + noise_n';
W = STFT(x_n1, M);

[energy] = Energy(W);
Wf = Threshold(energy, M/3);
xnr = ISTFT(Wf);

figure;
nexttile;
sgtitle({'Example #1', 'Filtering in frequency domain'})
plot(discrete_time_domain, x_n1);
title('Example #1, Signal in time domain');
xlabel('Time domain [sec]');
ylabel('Amplitude');

nexttile;
imagesc(abs(fftshift(W)));

ticks_indices = 10:10:2048;

xticks(ticks_indices);
xticklabels(compose("%.2f", freq_domain(ticks_indices)));
xlim(M/2 + 64 * [-1 1]);

title('STFT');
xlabel('Frequncy domain [Hz]');
ylabel('Window index');
colorbar;

nexttile;
plot(discrete_time_domain, real(xnr));
title('Filtered signal');
xlabel('Time domain [sec]');
ylabel('Amplitude');

nexttile;
imagesc(abs(fftshift(Wf)));
ticks_indices = 10:10:2048;

xticks(ticks_indices);
xticklabels(compose("%.2f", freq_domain(ticks_indices)));
xlim(M/2 + 64 * [-1 1]);

title('STFT after denoising');
xlabel('Frequncy domain [Hz]');
ylabel('Window index');
colorbar;

%% Signal Example 2 - Filtering in time domain
% Filtering out WGN noise in time domain using FIR filter.
% The most simple LPF is moving average. We define the LPF coeeficients as
% ones(1,10)/10, and apply as FIR filter using Filter function from HW1.
% As we can see, there is some smooth in reconstructed signal, much less
% distortion but signal is still noisy.

figure;
imshow(imread('blocks2\HW2-Example2a.png'));
title('Example 2 block diagram');


figure;
imshow(imread('blocks2\HW2-Example2b.png'));
title('Filtering proccess block diagram');

x_n_2 = Scalar(3, y_n_f1_f5(:, 2)) + Scalar(2, y_n_f1_f5(:, 4)) + noise_n';
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
imagesc(abs(fftshift(W_x_2)));

ticks_indices = 10:10:2048;

xticks(ticks_indices);
xticklabels(compose("%.2f", freq_domain(ticks_indices)));
xlim(M/2 + 64 * [-1 1]);

title('STFT');
xlabel('Frequncy domain [Hz]');
ylabel('Window index');
colorbar;

nexttile;
imagesc(abs(fftshift(W_y_2)));

ticks_indices = 10:10:2048;

xticks(ticks_indices);
xticklabels(compose("%.2f", freq_domain(ticks_indices)));
xlim(M/2 + 64 * [-1 1]);

title('STFT after time domain filtering (FIR)');
xlabel('Frequncy domain [Hz]');
ylabel('Window index');
colorbar;
%% Signal Example 3 - Filtering in frequency and time domain
