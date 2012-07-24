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
function a, v, t = test(c, X)
  c
  if c == 0;
    t = 0;
    v = 0;
  else
    t = cputime;
    w = spca(X, [], 1, inf, -c);
    t = cputime - t
    v = variance(w, X)
  end
  a = [ v t ];
endfunction

% N : number of samples
% D : dimension of sample data

function data = face()
  N = 6977;
  D = 361;
  data = dlmread('../data/face/data', ' ', [0 0 (N-1) (D-1)]);
endfunction

function data = gene()
  N = 72;
  D = 12582;
  data = dlmread('../data/gene/data', ' ', [0 0 (D-1) (N-1)])';
endfunction

data = gene();
data = normalize(data);
step = 50;
x = 0:step:400;
q = arrayfun(@(c) test(c, data), x, 'UniformOutput', false);
r = reshape([q{:}], 2, size(x, 2));
y = r(1,1:size(0:step:150, 2))
t = r(2,:)
scatter(0:step:150, y, 10, [0 0 1], 's')
print('/tmp/a.png', '-dpng', '-S500,500')
clf()
scatter(x, t, 10, [1 0 0], 's')
print('/tmp/b.png', '-dpng', '-S500,500')
