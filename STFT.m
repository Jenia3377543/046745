function [W] = STFT(x,M)
arguments
    x {mustBeVector}
    M {mustBeInteger}
end

% M x N_frames
x_windowed = reshape(x, M, []);

% Define discrete frequency domain
f = (0:M-1);

% Get fft basis, M_samples x M_frequencies
fft_basis = Complex(f, M);

% Compute DFT for each window
W = x_windowed.' * fft_basis;
end