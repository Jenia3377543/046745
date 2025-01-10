function [y] = Threshold(x,th)
arguments
    x 
    th 
end
y = x;
y(y < th) = 0;
end