function [x] = DigitalRandom(N, threshold)
arguments
    N 
    threshold = 0.5
end
x_random = Rand(N); 
x_random = x_random.';
x = Threshold(x_random, threshold);
end