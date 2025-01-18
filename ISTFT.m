function [y] = ISTFT(W)
arguments
    % N_frames x M_frequencies 
    W (:,:)
end
[~, M] = size(W);

y = zeros(numel(W), 1);

for ik = 0:M-1
    basis_vec = Complex(ik, M)/M;

    for jf = 0:M-1
        w_k = W(:, jf+1);
       
        hj_filter = PolyphaseFilter(basis_vec, jf, M);
        y_decimated = Filter(1, hj_filter, w_k);

        y_interpolated = Interpolate(M, y_decimated)';
        y = Add(y, Circshift(y_interpolated, ik));
    end
end
end