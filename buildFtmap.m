function [ ftmap ] = buildFtmap( img, donorm, theta_c, theta_p)
%BUILDFTMAP build a feature map given an image
%   feature vector is f=(ci/theta_c, pi/theta_p)
%   where ci is color in Lab space, pi is position x, y, they are weighted
%   by parameters theta_c and theta_p
%   input:
%       img: image in matrix form in lab color space
%   output:
%       ftmap: feature map of size M-by-N, where M is dimension of feature
%       vector, N is number of pixels
%   status: function test passed
switch nargin
    case 1
        donorm = false;
        theta_c = 0.2;
        theta_p = 1.0;
    case 2
        theta_c = 0.2;
        theta_p = 1.0;
    case 3
        theta_p = 1.0;
end
%extract color
[rows, cols, chans] = size(img);
ftmap = zeros(5, rows*cols);
ftmap(1:chans,:) = reshape(img, [rows*cols chans])'/theta_c;


%extract position
idx = 1:rows*cols;
[I, J] = ind2sub([rows, cols], idx);
ftmap(4:5, :) = cat(1, I, J)/theta_p;

%normalize
if (donorm)
    ftmap(1, :) = ftmap(1,:)/100;
    ftmap(2:3, :) = (ftmap(2:3, :) + 100)./200;
    ftmap(4,:) = ftmap(4,:)/rows;
    ftmap(5,:) = ftmap(5,:)/cols;
end

end

