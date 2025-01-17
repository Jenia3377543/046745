function [y] = Threshold(x,th)
arguments
    x 
    th 
end
y = x >= th;
end