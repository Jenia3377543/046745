function y = Circshift(x,j)
arguments
    x (:, 1)
    j {mustBeInteger}
end
N = length(x);

ind = 0:N-1;
y = x(mod(ind - j,N) + 1);

end