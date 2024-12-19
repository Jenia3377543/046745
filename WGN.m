function [y_n] = WGN(N,u,s)
y_n = u + s*randn(1,N);
end