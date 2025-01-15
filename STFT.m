function [W] = STFT(x,M)
arguments
    x {mustBeVector}
    M {mustBeInteger}
end
N_samples = length(x);
N         = round(N_samples/M);
W         = zeros(N, M);

SHIFT = @(x) buffer(Filter(1, [1 0], x), N_samples);
for ik = 0:M-1
    basis_vec = Complex(ik, M);
    tmp = x;
    for in = 1:M-1
        x_decimated = Decimate(M, tmp);
        curr_prod = Scalar(basis_vec(in), x_decimated);
        W(:, ik+1) = Add(W(:, ik+1), curr_prod);
        tmp = SHIFT(tmp');
    end
end
% % M x N_frames
% x_windowed = reshape(x, M, []);
% 
% % Define discrete frequency domain
% f = (0:M-1);
% 
% % Get fft basis, M_samples x M_frequencies
% fft_basis = Complex(f, M);
% 
% % Compute DFT for each window
% W = x_windowed.' * fft_basis;
end