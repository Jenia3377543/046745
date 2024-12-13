function [y_n] = Filter(an,bn,x)
p = length(an);
bn = bn / an(1);
an = an / an(1);

if isscalar(an)
    y_n = conv(x, bn, 'valid');
    return;
end
w_n = conv(x, bn, 'full');

N = length(x);

w_n = cat(2, w_n, zeros(1, 2 * N - length(w_n)));
y_n = zeros(1, 2 * N);

y_n(1) = w_n(1);
for j = 2:length(y_n)

    y_n(j) = (-an(2:min(j,p))) * flip(y_n(max(1,j+1-p):j-1))' + w_n(j);
end
end