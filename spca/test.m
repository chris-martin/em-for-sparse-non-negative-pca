#! /usr/bin/octave -qf

addpath('spasm')

function w = test()
  range = [0 0 10 10]
  K = 4
  stop = 0
  X = dlmread('../face/data', ' ', range);
  w = spca(X, [], K, inf, stop);
endfunction

test()

