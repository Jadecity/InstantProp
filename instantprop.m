function [ edited ] = instantprop( ftmap, edit, W )
%INSTANTPROP do instant propagation according to "Instant Propagation of Sparse Edits on Images and Videos"
%   input:
%       ftmap: feature map of size M-by-N, where M is dimension of feature
%       edit : strength of edit operator, size M-by-N, M, N are row num and
%              column num respectively
%       W    : weight of each edit pixel, size M-by-N, M, N are row num and
%              column num respectively
%   output:
%       edited: propagated edit, size M-by-N, M, N are row num and
%              column num respectively, go to [Yong Li 2010] for more details
%   status: test passed
edited = zeros(size(edit));

edit = edit(:);
W = W(:);
eleidx = find(W ~= 0);
%set percentage of C/G to 20%
alpha = 0.2;
C = datasample(eleidx, ceil(alpha*numel(eleidx)) );
%build rbf
F = zeros(numel(eleidx), numel(C));
fJ = ftmap(:, C);
cnt = 1;
for idx = eleidx'
    fi = ftmap(:, idx);
    pw = bsxfun(@minus, fJ,  fi);
    pwnorm = sum(pw.^2, 1);
    F(cnt, :) = exp(-pwnorm);
    cnt = cnt + 1;
end
%build G
G = edit(eleidx);

%solve problem with non-negtive least square
a = lsqnonneg(F, G);

%set edit value to each pixel
for idx = 1:size(ftmap, 2)
    fi = ftmap(:, idx);
    pw = bsxfun(@minus, fJ,  fi);
    pwnorm = sum(pw.^2, 1);
    edited(idx) = exp(-pwnorm)*a;
end

end
