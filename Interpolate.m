function [y_n] = Interpolate(M,x,use_lpf)
arguments
    M 
    x 
    use_lpf = false
end
% Validate that x is row vector
x = x(:)';
N_samples = length(x);

y_n = cat(1, x, zeros(M - 1, N_samples));
y_n = reshape(y_n, 1, []);

if use_lpf
    % Apply lowpass filter
    N_samples_interp = N_samples * M;
    sampled_sinc = sinc((-N_samples_interp/2:N_samples_interp/2)/(M));
    y_n = conv(y_n, sampled_sinc, 'same');
end

end