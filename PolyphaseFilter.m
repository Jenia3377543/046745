function [h_i] = PolyphaseFilter(h, i, M)
h_delayed = Delay(h, i);
h_i = Decimate(M, h_delayed);
end

