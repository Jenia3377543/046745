function [y_n] = WGN(N,u,s)
y_n = u + s*randn(N,1);
end