%add color space tranfer lib to path
addpath(genpath('E:\3rd_party_libs\mm_libs\color_space'));

img = imread('res/1.jpg');
[rows, cols, chans] = size(img);
%  get feature map
img_lab = rgb2lab(img);
ftmap = buildFtmap(img_lab, true);

% build weight matrix and edit
W = sparse(rows, cols);
W(20:30, 20:30) = 1/100;
edit = sparse(rows, cols);
edit(logical(W)) = 0.6;

% do edit propagation
edit_prop = instantprop(ftmap, edit, W);