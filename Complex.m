function [y] = Complex(f,N)
arguments
    f (1, :)
    N {mustBeInteger}
end
[sine_n, ~] = Sine(f,N,0);
[cosine_n, ~] = Sine(f,N,pi/2);
y = Add(cosine_n, Scalar(1j, sine_n));
end