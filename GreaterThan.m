function [z] = GreaterThan(x,y)
arguments
    x 
    y 
end
vals_diff = Add(x, Prod(-1, y));
x_gt = Threshold(vals_diff, 0);
y_gt = Add(1, Prod(-1, x_gt));

z = Add(Prod(x_gt, x), Prod(y_gt, y));
end