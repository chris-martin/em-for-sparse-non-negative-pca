#! /usr/bin/octave -qf

addpath('spasm')
addpath('../matlab')

function Y = normalize(X)
  m = mean(X);
  v = diag(cov(X))' .^ (1/2);
  Y = (X .- repmat(m, size(X, 1), 1)) \
      ./ repmat(v, size(X, 1), 1);
endfunction

function p = project(A, v)
  p = A * inv(A' * A) * A' * v;
endfunction

function v = variance(w, X)
  v = sum(var(project(w, X')'));
endfunction

function test()
  N = 150 % number of samples
  D = 361 % dimension of sample data
  K = 1 % number of principle components
  c = 150 % cardinality (nonzero variables)
  range = [0 0 (N - 1) (D - 1)];
  X = dlmread('../face/data', ' ', range);
  X = normalize(X);
  variance(spca(X, [], K, inf, -c), X)
  variance(normc(rand(D, K)), X)
endfunction

test()
