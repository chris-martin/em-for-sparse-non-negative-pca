#! /usr/bin/octave -qf

addpath('spasm')
addpath('../matlab')

function Y = normalize(X)
  m = mean(X);
  v = diag(cov(X))' .^ (1/2);
  Y = (X .- repmat(m, size(X, 1), 1)) ./ repmat(v, size(X, 1), 1);
endfunction

function test()
  range = [0 0 50 50]
  K = 4
  stop = 0
  X = dlmread('../face/data', ' ', range);
  X = normalize(X);
  sum(var(X))
  w = spca(X, [], K, inf, stop);
  p = X * w;
  sum(var(p))
  w = normc(rand(size(X, 1), K));
  p = X * w;
  sum(var(p))
endfunction

test()

