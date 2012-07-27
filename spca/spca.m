#! /usr/bin/octave -qf

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
function a, v, t = test(c, X, renormalize)
  c
  if c == 0;
    t = 0;
    v = 0;
  else
    t = cputime;
    addpath('spasm')
    w = spca(X, [], 1, inf, -c);
    rmpath('spasm')
    if renormalize;
      w2 = [];
      for i = 1:size(w, 1);
        if w(i) ~= 0;
          w2 = [w2; i];
        end
      end
      X = X(:,w2');
      w = princomp(X)(:, 1);
    end
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

data = face();
data = normalize(data);
step = 1;
x1 = 0:step:150;
x2 = 0:step:150;
q = arrayfun(@(c) test(c, data, 1), x2, 'UniformOutput', false);
r = reshape([q{:}], 2, size(x2, 2));
y = r(1,1:size(x1, 2))
t = r(2,:)
csvwrite('/tmp/a.csv', [x1' y'])
scatter(x1, y, 10, [0 0 1], 's')
print('/tmp/a.png', '-dpng', '-S500,500')
%clf()
%scatter(x2, t, 10, [1 0 0], 's')
%print('/tmp/b.png', '-dpng', '-S500,500')
