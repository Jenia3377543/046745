function [x] = NaturalRandom(N)
arguments
    N
end
a = Rand(5);
a = Scalar(4, a);
a = Add(a, -2);

f = Rand(5);
f = Scalar(100, f);
f = Add(f, -50);

[y_n, discrete_time_domain] = Sine(f,N);
x = x
end