function [y] = ISTFT(W)
arguments
    W (:,:)
end
% Get dimensions
[M, N] = size(W);

% Define discrete frequency domain
f = (0:N-1)/N;
% Get fft basis
fft_basis = Complex(f, N);
% Get inverse fft basis
inverse_fft_basis = (1/N) * Conj(fft_basis).';

% Compute ISTFT
istft = W * inverse_fft_basis;
y = reshape(istft.', [], 1);
end