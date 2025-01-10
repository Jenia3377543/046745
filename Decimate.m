function [y_n] = Decimate(D,x,use_lpf)
arguments
    D 
    x 
    use_lpf = false
end

% Apply low pass filter
N_samples = length(x);
if use_lpf
    sampled_sinc = sinc((-N_samples/2:N_samples/2)/(D))/D;
    x_low_passed = conv(x, sampled_sinc, 'same');
    w_n = x_low_passed;
else
    w_n = x;
end

y_n = w_n(1:D:end);
end