function [z,b] = MuxRandom(x,y)
arguments
    x 
    y 
end
x_rand = Rand(1);
b = Threshold(x_rand, 0.5);

z = Scalar(b, x) + Scalar(Add(1, Scalar(b, -1)), y);
end