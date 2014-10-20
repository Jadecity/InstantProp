function [ seg ] = softseg( img, K )
%SOFTSEG segment image to K probability map
%   input :
%       img: image in lab color space, M-by-N-by-3
%       K  : number of soft segmentations
%   output:
%       seg: a cell array with #K elements, each element is a probability
%       map of size  M-by-N

%init output and build feature map
seg = cell(1, K);
[rows, cols, chans] = size(img);
ftmap = buildFtmap(img, true);

%sample K patches randomly
psize = [ceil(rows/K), ceil(cols/K)];
randrows = datasample(1:(rows-psize(1)), K);
randcols = datasample(1:(cols-psize(2)), K);
%do edit propagation for each patch
edits = zeros(rows, cols, K);
step = 0.1;
alpha = 0.3^2;
for k=1:K
    % build weight matrix and edit
    r = randrows(k):randrows(k)+psize(1)-1;
    c = randcols(k):randcols(k)+psize(2)-1;
    W = zeros(rows, cols);
    W(r,c) = 1/(psize(1)*psize(2));
    edit = zeros(rows, cols);
    edit(logical(W)) = 0.3+step*(k-1);
    
    % do edit propagation
    edit_prop = instantprop(ftmap, edit, W);
    %convert propagation result to probability map
    edits(:,:,k) = exp((edit_prop-0.3+step*(k-1)).^2/alpha);
end

total = sum(edits, 3);
for k=1:K
    seg{k} = edits(:,:,k)./total;
end

end

