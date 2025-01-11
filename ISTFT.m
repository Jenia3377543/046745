function [y] = ISTFT(W)
arguments
    % N_frames x M_frequencies 
    W (:,:)
end
% Get dimensions
[~, M] = size(W);

% Define discrete frequency domain
f = (0:M-1);
% Get fft basis, M_samples x M_frequencies
fft_basis = Complex(f, M);
% Get inverse fft basis, M_frequencies x M_samples
inverse_fft_basis = (1/M) * Conj(fft_basis).';

% Compute ISTFT
istft = W * inverse_fft_basis;
y = reshape(istft.', [], 1);
end