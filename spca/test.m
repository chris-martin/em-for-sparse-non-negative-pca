#! /usr/bin/octave -qf

addpath('spasm')
addpath('../matlab')

% Normalizes the columns of the data matrix
% to have mean and variance 1.
function Y = normalize(X)
  m = mean(X);
  v = diag(cov(X))' .^ (1/2);
  Y = (X .- repmat(m, size(X, 1), 1)) \
      ./ repmat(v, size(X, 1), 1);
endfunction

% The projection of v onto the subspace spanned
% by the columns of A.
function p = project(A, v)
  p = A * inv(A' * A) * A' * v;
endfunction

% The variance of the data X projected onto the
% principal component subspace w.
function v = variance(w, X)
  v = sum(var(project(w, X')'));
endfunction

% c : cardinality (nonzero variables)
% X : normalized data matrix
% v : variance of data after dimension reduction
function v = test(c, X)
  c
  if c == 0; v = 0; return; end
  v = variance(spca(X, [], 1, inf, -c), X)
endfunction

N = 6977; % number of samples
D = 361; % dimension of sample data
range = [0 0 (N - 1) (D - 1)];
data = dlmread('../face/data', ' ', range);
data = normalize(data);
x = 0:15:150;
y = arrayfun(@(c) test(c, data), x);
scatter(x, y, 10, [0 0 1], 's')
print('/tmp/a.png', '-dpng', '-S500,500')