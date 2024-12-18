function [y_n] = Decimate(D,x)
% Apply low pass filter
N_samples = length(x);
sampled_sinc = sinc((-N_samples/2:N_samples/2)/(D))/D;
x_low_passed = conv(x, sampled_sinc, 'same');

y_n = x_low_passed(1:D:end);
end