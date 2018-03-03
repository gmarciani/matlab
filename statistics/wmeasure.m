function W = wmeasure(X)
% WMEASURE Compute the W-measure for a vector:
% w(i)=(x(i)-x(i-1))/(x(i-1))
% X: the original vector.
% W: the vector of W-values.
n = size(X, 1);
W = zeros(n, 1);
for i = 2:n
    W(i) = (X(i)-X(i-1))/X(i-1);
end
end

