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
% Signal Example 1
% Filter the signal using threshold block in frequency domain
% 
% Let's take a look at signals with known frequency. We have choose the
% frequencies s.t. they fall directly on discrete frequency bins, so there
% is no energy spread in frequency domain and we can find the expected
% energy at each frequency bin.
% 
% We will consider 
% Drawbacks - must approximate the frequency exactly.
M = 2048;
freq_domain = Fs * (-M/2:M/2-1)/M;
figure;
imshow(imread('blocks2\HW2-Example1.png'));
title('Example 1 block diagram');

x_n1 = y_n_f1_f5(:, 1) + 1 * y_n_f1_f5(:, 3) + 0 * y_n_f1_f5(:, 5) + noise_n';
W = STFT(x_n1, M);
Wf = Threshold(abs(W), M/3);
figure;
plot(freq_domain, abs(fftshift(W(1, :))));

xnr= ISTFT(Wf);
figure; 
plot(real(xnr));

% imagesc(abs(fftshift(W, 2)));
% Signal Example 2

% Signal Example 3