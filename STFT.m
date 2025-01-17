function [W] = STFT(x,M)
arguments
    x {mustBeVector}
    M {mustBeInteger}
end
N_samples = length(x);
N         = round(N_samples/M);
W         = zeros(N, M);

for ik = 0:M-1
    basis_vec = Conj(Complex(ik, M));
    for jf = 0:M-1
        x_delayed = Delay(x, jf);
        xj_delayed = Decimate(M, x_delayed);

        hj_filter = PolyphaseFilter(basis_vec, jf, M);
        wj = Filter(1, hj_filter, xj_delayed);
        
        W(:, ik+1) = Add(W(:, ik+1), wj);
    end
end
end