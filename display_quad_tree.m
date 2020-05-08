function I = display_quad_tree(RGB,qt_segs,mean_fill,show_borders,show_seeds)
    if nargin < 3; mean_fill = true; end
    if nargin < 4; show_borders = true; end
    if nargin < 5; show_seeds = true; end
        
    I = RGB;
    
    if show_seeds
        [M,N,~] = size(I);
        mask = false(M,N);
    end
    
    % step through each node in the queue
    for i = 1:length(qt_segs)
        % get the range data from the node
        r = qt_segs(i);
        
        % if desired, replace each segment with its mean RGB color
        if mean_fill
            % crop the 
            seg = I(r.top:r.bottom,r.left:r.right,:);
            mean_rgb = uint8(reshape(mean(seg,[1 2]),1,3));
            
            % replace each quadtree seg with the mean of the pixels in it
            I(r.top:r.bottom,r.left:r.right,1) = mean_rgb(1);
            I(r.top:r.bottom,r.left:r.right,2) = mean_rgb(2);
            I(r.top:r.bottom,r.left:r.right,3) = mean_rgb(3);
        end
        
        % add border to outside pixels
        if show_borders
            I(r.top:r.bottom,r.left,:) = 0;
            I(r.top:r.bottom,r.right,:) = 0;
            I(r.top,r.left:r.right,:) = 0;
            I(r.bottom,r.left:r.right,:) = 0;
        end

        % build a mask for pixels
        if show_seeds
            mask(r.middle,r.center) = true;
        end
    end

    if show_seeds
        % expand each pixel
        se = strel('disk',1);
        mask = imdilate(mask,se);
        color = [255 0 0];
        
        R = I(:,:,1); G = I(:,:,2); B = I(:,:,3);
        R(mask) = color(1);
        G(mask) = color(2);
        B(mask) = color(3);
        I(:,:,1) = R; I(:,:,2) = G; I(:,:,3) = B;
    end
    
    if nargout == 0; imshow(I); end
end
