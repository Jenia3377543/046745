addpath(genpath('PlotUtils'))
%% Sine examples
% Lets show 3 basic examples using SINE function:
% 
% * $y_n1 = sin(2\pi 5t)$
% * $y_n2 = sin(2\pi 5t + \pi)$
% * $y_n3 = y_n1 + y_n3$
% 
% The second signal is delayed by $\pi$ so we consider to get cosine instead.
% The third one, is the sum of sine and cosine with the same frequency, so
% we consider to get ZEROS:

N = 65;
[y_n1, dtd1] = Sine(5,N,0);
[y_n2, dtd2] = Sine(5,N,pi);
y_n3 = y_n1 + y_n2;
dtd3 = dtd1;

figure(1); hold all;
plot(dtd1, y_n1, 'DisplayName', 'Y_1[n]');
plot(dtd2, y_n2, 'DisplayName', 'Y_2[n]');
plot(dtd3, y_n3, 'DisplayName', 'Y_3[n]');
title('3 Examples for Sine function');
xlabel('Time domain [sec]');
ylabel('Amplitude');
legend;
%% WGN examples
% Let's generate 3 different levels of noise:
% 
% * $y_1[n] = WGN(N,0,1)$ - White gaussian noise
% * $y_2[n] = WGN(N,0,2)$ - White gaussian noise with increased variance
% * $y_3[n] = WGN(N,1,2)$ - White gaussian noise with increased variance
% and DC offset
% 
% The samples at different times are uncorrelated, so we expect to observe a random signal. 
% Additionally, when examining the empirical probability density function (PDF), 
% we expect to obtain a normal distribution with the parameters above:


N = 1000;
edges = -10:0.25:10;
[y_n1] = WGN(N,0,1);
[y_n2] = WGN(N,0,2);
[y_n3] = WGN(N,1,2);

time_domain = (0:N-1);
PlotWGN(y_n1, 'Y_1[n]', 0, 1, time_domain);
PlotWGN(y_n2, 'Y_2[n]', 0, 2, time_domain);
PlotWGN(y_n3, 'Y_3[n]', 1, 2, time_domain);
%% Rect examples
% Let's consider 3 examples for Rect function:
% Let N = 100;
% * $y_1[n] = Rect(0,25,N)$ - window function between 0 and 25 with 100
% samples
% * $y_2[n] = Rect(0,25,3*N)$ - same as $y_1[n]$ but also padded with
% additional 200 zeros at the end
% * $y_3[n] = Rect(0,75,N)$ - same as $y_1[n]$ but more time coverage - 0
% to 75 with 100 samples
% 
% The DFT of $y_1[n]$ is SINC, when the signal is padded with zeros at the
% end the resolution in frequency domain improved ($y_2[n]$).
% And finally, when the window width increase the SINC width in frequency
% domain decrease approaching to $\delta(\omega)$.
% Lets show it:

N = 100;
[y_n1, dtd1] = Rect(0,25,N);
[y_n2, dtd2] = Rect(0,25,3*N);
[y_n3, dtd3] = Rect(0,75,N);

PlotRect(y_n1, "Y_1[n]", dtd1)
PlotRect(y_n2, "Y_2[n]", dtd2)
PlotRect(y_n3, "Y_3[n]", dtd3)
%% Gauss examples
% Let's consider 3 examples for Gauss function:
% Let N = 100;
% 
% * $y_1[n] = Gauss(0,25,N)$ - $N(0,25^2)$, 100 samples
% * $y_2[n] = Gauss(0,100,2*N)$ - $N(0,100^2)$, 100 samples
% * $y_3[n] = Gauss(0,0.1,N)$ - $N(0,0.1^2)$, 100 samples
% 
% The gaussian can be used as a window function. It's smoother then rect window. 
% One can see, that when:
% 
% * $\sigma^2 \to \infty$ - it tends to be like infinite rect window\DC so the spectrum is $delta(\omega)$
% * $\sigma^2 \to 0$, it tends to be $\delta(t)$ so the spectrum is flat. 
% * $\sigma^2 <\infty$, it can interpretated as smooth window with nice properties.


N = 100;
[y_n1, dtd1] = Gauss(0,25,N);
[y_n2, dtd2] = Gauss(0,100,N);
[y_n3, dtd3] = Gauss(0,0.1,N);

PlotGauss(y_n1, "Y_1[n]",  0, 25, dtd1);
PlotGauss(y_n2, "Y_2[n]",  0, 100, dtd2);
PlotGauss(y_n3, "Y_3[n]",  0, 0.1, dtd3);
%% Prod examples
% Let's consider 3 examples for Prod function:
% Let N = 64; $X[n] = sin(2\pi\cdot 5n/N)$ - 1 [sec] of the sine.
% 
% * $y_1[n] = X[n]*Rect(0,0.5,N)$ - X[n] multiplied by rect window (between
% 0 and 0.5[sec])
% * $y_2[n] = X[n]*Gauss(0,0.2,N)$ - X[n] multiplied by Gauss window
% ($\mu=0,\sigma=0.2$)
% * $y_3[n] = X[n]*Triangle$ - X[n] multiplied by triangle window
% 
% Windows can be used to reduce artifacts that occured due to fact that the signal is finite.
% We will consider the 3 windows: Rect, Gauss and Triangle.
% As we have seen (044198):
% 
% * Rect response is Dirichlet func in frequency domain.
% * Gauss is smoother than rect, so we expect to get lower sidelobs.
% * Triangle is Dirichlet squared, so lobes should be lower comparing to rect.

N = 128;

w_rect = Rect(0,0.5,N,'NormalizeTD',true);
w_gauss = Gauss(0,0.2,N,'NormalizeTD',true);
w_triang = ifft(fft(w_rect).^2);
freq_domain = pi * (-N/2:N/2-1) / N;

[y_n, dtd] = Sine(20, N, 0);
figure(3); clf
nexttile; hold all;
plot(dtd, w_rect, '--*', 'DisplayName', 'Rect');
plot(dtd, w_gauss, '--*', 'DisplayName', 'Gauss');
plot(dtd, w_triang, '--*', 'DisplayName', 'Triangular');
ylabel('Window Amplitude');

yyaxis right;
ylabel('Sine Amplitude');
plot(dtd, y_n, '--*', 'DisplayName', 'Sine');
legend;

nexttile; hold all;
plot(freq_domain, abs(fftshift(fft(y_n .* w_rect))), '--*', 'DisplayName', 'X[n]\cdot Rect[n]');
plot(freq_domain, abs(fftshift(fft(y_n .* w_gauss))), '--*', 'DisplayName', 'X[n]\cdot Gauss[n]');
plot(freq_domain, abs(fftshift(fft(y_n .* w_triang))), '--*', 'DisplayName', 'X[n]\cdot Triang[n]');
ylim([0, 0.15]);
xlim([-pi/2 pi/2]);
legend;

xticks([-pi/2, 0, pi/2]);
xticklabels(["-\pi/2", "0", "\pi/2"]);
xlabel('\omega[rad/sec]');
ylabel('|FFT{Sine*Window}|');
sgtitle({"Prod example", "Windows comparison"});
%% Add examples
% Let's consider 3 examples for Add function:
% Let N = 64; $X[n] = sin(2\pi\cdot 5n/N)$ - 1 [sec] of the sine.
% Noises we used few sections above:
%
% * $n_1 = WGN(N,0,0.1)$
% * $n_2 = WGN(N,1,0.1)$
% * $n_2 = WGN(N,0,1)$
% 
% Let's consider:
% 
% * $y_1[n] = X[n] + n_1[n]$ - X[n] with low power noise
% * $y_2[n] = X[n] + n_2[n]$ - X[n] with low power noise with "DC" ($\mu \neq 0$)
% * $y_3[n] = X[n] + n_3[n]$ - X[n] with high power noise
% 
% We expect that:
% 
% * $y_1[n] \approx X[n]$ because the SNR is good enough
% * $y_2[n] \approx y_1[n]$ but there will be DC frequency
% * Finally, $y_3[n]$ will look differently than $X[n]$ because the SNR is
% bad, but in frequency domain we are able to see the deltas. Intuitively, that's because DFT does integration over time.
% Let's compute add operations:
N = 64;
[y_n, dtd] = Sine(5,N,0);
[n1] = WGN(N,0,0.1);
[n2] = WGN(N,1,0.1);
[n3] = WGN(N,0,1);

y_n1 = Add(y_n, n1);
y_n2 = Add(y_n, n2);
y_n3 = Add(y_n, n3);

PlotAdd(y_n1, dtd, 'WGN(0,0.1)');
PlotAdd(y_n2, dtd, 'WGN(1,0.1)');
PlotAdd(y_n3, dtd, 'WGN(0,1)');
%% Scalar examples - Rotated 16QAM
% Let's consider 3 examples for Scalar function.
% 
% We will define set of compose numbers with 2 energy levels and phases
% $n\pi/4$ (16QAM symbols).
% 
% By multiplying these numbers by a scalar, we can observe interesting phenomenas.
% We will multiply by:
% 
% * $a$ (Real scalar) - we expect that the energy of each symbol will
% increase by a.
% * $exp(j\pi/4)$ - all of the symbols will be rotated by $\pi/4$
% * Add additive complex noise - the symbols will be normally distributed
% around the expected QAMs locations.
% Let's apply Scalar multiplications:

d = (0:15)';
s = qammod(d,16);
scatterplot(s);

s_amplified = Scalar(s,5);
scatterplot(s_amplified);
title('Amplified by 5')

s_rotated = Scalar(s, exp(1j*pi/4));
scatterplot(s_rotated);
title('Rotated by \pi/4')

noise = WGN(160,0,0.2)' + Scalar(WGN(160,0,0.2), 1j)';
noise = reshape(noise, 16, 10);
s_noised = s + noise;
s_noised = s_noised(:);
scatterplot(s_noised);
title('Additive complex noise')
%% Filter examples
% Let's consider 3 examples for Filter function:
% 
% * $a_n=1$, $b_n = [1, -1] * c$  - Derivative filter
% * $a_n=1$, $b_n = ones(1,M)$    - Matched filter
% * $a_n=1$, $b_n = \bar{\alpha}$ - Lowpass filter
% 
% With derivative filter we will use $X(t) = sin(2\pi\cdot 5t)$ as an input
% signal. We expect to get cosine.
% 
% With Matched filter we will use delayed Rect as an input signal and Rect as
% a pattern. We expect to get triangle as a matched signal results (convolution of rects), when
% the maximum will be placed at the begining of the delayed rect on input
% signal.
% 
% With Lowpass filter we wiil use $X(t) = sin(2\pi\cdot 35t) + sin(2\pi\cdot
% 200t)$ as an input signal. We will design FIR lowpass filter, with
% $F_{cutoff}=50[Hz]$. We expect to get only the $sin(2\pi\cdot 35t)$ as
% result.
% Let's apply filters:
N = 100;
[x_n, dtd] = Sine(5,N,0);
DERIVATIVE_FILTER = [1, -1] * N / (2*pi*5);

y_n = Filter(1, DERIVATIVE_FILTER, x_n);

figure; hold all;
plot(dtd, x_n, '--*', 'DisplayName', 'Sine');
plot(dtd(1:end-1), y_n, '--*', 'DisplayName', 'Derivative');
legend;
title(compose('Filter example - %s', 'Derivative'));

% Matched filter
N = 100;
MATCHED_FILTER = ones(1, 25);
[x_n2, dtd2] = Rect(50,75,N);
y_n2 = Filter(1, MATCHED_FILTER, x_n2);

figure; hold all;
plot(dtd2, x_n2, '--*', 'DisplayName', 'Input Signal');
plot(MATCHED_FILTER, '--*', 'DisplayName', 'Desired Pattern');
plot(y_n2, '--*', 'DisplayName', 'Matched Signal');
legend;
title(compose('Filter example - %s', 'Matched filter'));

% Low pass filter
% Design normalized low-pass filter
Fs = 500;             % Sampling frequency (Hz)
Fc = 50;              % Cutoff frequency (Hz)
N = 16;                % Filter order (number of taps)
window = hamming(N+1); % Hamming window
h = fir1(N, Fc/(Fs/2), 'low', window); % FIR filter coefficients

x_n = Sine(35,Fs,0) + Sine(200,Fs,0);
y_n = Filter(1, h, x_n);

figure;
nexttile;
plot((0:Fs-1)/Fs, x_n);
xlabel('Time [sec]');
ylabel('Amplitude');
title('X(t) = sin(2\pi\cdot 5t) + sin(2\pi\cdot 200t)');

nexttile;
plot(-Fs/2:Fs/2-1, abs(fftshift(fft(x_n))));
xlabel('Frequency [Hz]');
ylabel('|Amplitude|');
title('X(t) in frequency domain');

N_samples = length(y_n);
freq_domain = Fs * (-N_samples/2:N_samples/2-1) / N_samples;
nexttile;
plot(freq_domain, abs(fftshift(fft(y_n))));
xlabel('Frequency [Hz]');
ylabel('|Amplitude|');
title({'Low passed X(t) in frequency domain', 'F_{cutoff}=50[Hz]'});
%% Interpolate examples

%% Decimate examples

