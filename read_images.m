%% load data
clear; clc;
[pixels, M, N] = load_pixels('Data\Shopvac-perfect', 0);

%% display data
frame = @(col) reshape(col,M,N);
tri_frame = @(cols) arrayfun(@(i) frame(cols(:,i)),1:3,'UniformOutput',false);

rgb = tri_frame(pixels.rgb);
lab = tri_frame(pixels.lab);
hsv = tri_frame(pixels.hsv);

I = [rgb, lab, hsv, frame(pixels.d)];
meta = cellfun(@img_meta, I, 'UniformOutput', false);
threshold = @(i,n,a) i > (a * meta{n}(3) + meta{n}(2));
t = {'r','g','b','L','a','b','h','s','v','d'};
f = {
    @(i,n) imshow(i,[]);
    @(i,n) histogram(i);
    @(i,n) imshow(threshold(i,n,0.2));
    @(i,n) imshow(threshold(i,n,0.4));
    @(i,n) imshow(threshold(i,n,0.6));
    @(i,n) imshow(threshold(i,n,0.8));
};

img_multiview(I,t,f);

% imshow(reshape(pixels.rgb(:,1), M, N));
% imagesc(frame(pixels.d));
% colorbar;

%% functions
function result = img_meta(I)
    i_max = max(I(:));
    i_min = min(I(:));
    i_range = i_max - i_min;
    result = [i_max, i_min, i_range];
end

function img_multiview(I, t, f)
    figure;
    
    N = length(I);
    M = length(f); 
    
    for n = 1:N
        for m = 1:M
            ind = sub2ind([N,M],n,m);
            subtightplot(M,N,ind);
            
            ff = f{m};
            ff(I{n},n);          
            
            if m == 1; title(t{n}); end
        end
    end
end

% load the depth and color data (in multiple colorspaces)
function [pixels, M, N] = load_pixels(data_dir, i)
    % read the depth and rgb image files
    path = @(fname) fullfile(data_dir, sprintf(fname, i));
    [disp, depth_scale] = parsePfm(path('disp%d.pfm')); 
    disp = fliplr(imrotate(disp, 180));
    disp = disp(:);
    rgb = imread(path('im%d.png'));
    rgb = double(rgb) / 255;

    % get the pixel coordinates
    [M, N, ~] = size(rgb);
    index = (1:M*N)';
    [x, y] = ind2sub([M,N], index); 
    xy = [x y];

    % split up the rgb frames
    rgb = reshape(rgb, M*N, 3);
    
    % convert rgb to other colorspaces
    lab = rgb2lab(rgb);
    hsv = rgb2hsv(rgb);
    
    % combine each feature
    pixels = table(index, xy, rgb, lab, hsv, disp);
end
