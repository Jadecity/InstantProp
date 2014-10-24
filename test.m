%add color space tranfer lib to path
addpath(genpath('/nfs/hlv/workspace/ColorEn/optprop'));

img = imread('res/1.jpg');
[rows, cols, chans] = size(img);
%  get feature map
img_lab = rgb2lab(img);
K = 5;
sfmap = softseg(img_lab, K);

