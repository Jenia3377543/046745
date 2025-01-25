function [z] = GreaterThan(x,y)
arguments
    x 
    y 
end
vals_diff = Add(x, Scalar(-1, y));
x_gt = Threshold(vals_diff, 0);
y_gt = Add(1, Scalar(-1, x_gt));

z = Add(Scalar(x_gt, x), Scalar(y_gt, y));
end