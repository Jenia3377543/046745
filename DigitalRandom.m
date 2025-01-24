function [x] = DigitalRandom(N, threshold)
arguments
    N 
    threshold = 0.5
end
x_random = Rand(N);
x = Threshold(x_random, threshold);
end