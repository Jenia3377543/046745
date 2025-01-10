function [W] = STFT(x,M)
arguments
    x {mustBeVector}
    M {mustBeInteger}
end

% M_frames x N_samples
x_windowed = reshape(x, [], M).';

N = size(x_windowed, 2);

% Define discrete frequency domain
f = (0:N-1)/N;

% Get fft basis
fft_basis = Complex(f, N);

% Compute DFT for each window
W = x_windowed * fft_basis;
end