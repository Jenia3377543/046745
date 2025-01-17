function [y_n] = Delay(x_n, delay)
y_n = x_n(1+delay:end);
end

