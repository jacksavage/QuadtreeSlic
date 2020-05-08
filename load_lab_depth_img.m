function [I,RGB] = load_lab_depth_img(name,view)
    % load the rgb color image and depth pfm file from disk
    if nargin < 2
        [RGB,D] = load_color_depth_pair;
    else
        [RGB,D] = load_color_depth_pair(name,view);
    end
    
    % convert color from rgb to lab 
    lab_color = rgb2lab(RGB);
    L = lab_color(:,:,1); a = lab_color(:,:,2); b = lab_color(:,:,3);
    
    % normalize depth based on range seen in image
    D = (D - min(D(:))) ./ range(D(:));

    % combine normalized lab color and normalized depth frames
    I = L; I(:,:,2) = a; I(:,:,3) = b; I(:,:,4) = D;
end
