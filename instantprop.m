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
%F = zeros(numel(eleidx), numel(C));
fJ = ftmap(:, C);



display('least square');
tic

    %before vectorization
    %     cnt = 1;
    %     for idx = eleidx'
    %         fi = ftmap(:, idx);
    %         pw = bsxfun(@minus, fJ,  fi);
    %         pwnorm = sum(pw.^2, 1);
    %         F(cnt, :) = exp(-pwnorm);
    %         cnt = cnt + 1;
    %     end

%after vectorization
fI = ftmap(:, eleidx);
fJ2 = repmat(fJ, [1,1,numel(eleidx)]);
fI2 = repmat(reshape(fI, [size(fI, 1), 1, size(fI, 2)]), [1,numel(C), 1]);
pw = fJ2 - fI2;
pwnorm = squeeze(sum(pw.^2, 1));
F = exp(-pwnorm');
toc

%build G
G = edit(eleidx);
%solve problem with non-negtive least square
a = lsqnonneg(F, G);

%set edit value to each pixel
display('propagation');
tic
    %before vectorization
    %     for idx = 1:size(ftmap, 2)
    %         fi = ftmap(:, idx);
    %         pw = bsxfun(@minus, fJ,  fi);
    %         pwnorm = sum(pw.^2, 1);
    %         edited(idx) = exp(-pwnorm)*a;
    %     end
%after vectorization
fI_all = reshape(ftmap, [size(ftmap, 1), 1, size(ftmap, 2)]);
%repmat version
% fJ2_all = repmat(fJ, [1,1,size(ftmap, 2)]);
% fI2_all = repmat(fI_all, [1,numel(C), 1]);
%indexing version
fJ2_all = fJ(:,:,ones(1, size(ftmap, 2)));
fI2_all = fI_all(:, ones(1, numel(C)), :);
pw_all = fJ2_all - fI2_all;
%pw_all = fJ(:,:,ones(1, size(ftmap, 2))) - fI_all(:, ones(1, numel(C)), :);
pwnorm = squeeze(sum(pw_all.^2, 1));
res = exp(-pwnorm')*a;
edited = reshape(res, size(edited));
toc

end
