[rgb_color, depth] = load_color_depth_pair;

% convert color from rgb to lab 
% normalize from 0 to 1 based on range of possible lab values
lab_color = rgb2lab(rgb_color);
L = lab_color(:,:,1); a = lab_color(:,:,2); b = lab_color(:,:,3);
L = L / 100; a = (a + 127) / 256; b = (b + 127) / 256;
clear lab_color;

% normalize depth based on range seen in image
depth = (depth - min(depth(:))) ./ range(depth(:));

% combine normalized lab color and normalized depth frames
image = L; image(:,:,2) = a; image(:,:,3) = b; image(:,:,4) = depth;
clear L a b depth;

% find quad tree ranges
k = 700;
qt_segs = quad_tree(image,k,rgb_color); 
k = length(qt_segs.nodes);

% overlay segment quadtree segment labels
L = zeros(size(rgb_color));
for i = 1:k
    r = qt_segs.nodes(i).data; 
    rgb_seg = rgb_color(r.top:r.bottom,r.left:r.right,:);
    
    % replace each quadtree seg with the mean of the pixels in it
    mean_color = reshape(mean(rgb_seg,[1 2]),1,3);
    L(r.top:r.bottom,r.left:r.right,1) = mean_color(1); 
    L(r.top:r.bottom,r.left:r.right,2) = mean_color(2);
    L(r.top:r.bottom,r.left:r.right,3) = mean_color(3);
end

% B = labeloverlay(rgb_color,L); 
figure; imshow(rgb_color);
figure; imshow(uint8(L));
