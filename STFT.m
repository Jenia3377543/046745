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

    x_delayed = x;
    for jf = 0:M-1
        xj_delayed = Decimate(M, x_delayed);

        hj_filter = basis_vec(jf+1);
        wj = Scalar(hj_filter, xj_delayed);
        
        W(:, ik+1) = Add(W(:, ik+1), wj);
        x_delayed = Delay(x_delayed, 1);
    end
end
end