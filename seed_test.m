k = 200;
[I,RGB] = load_lab_depth_img;
centroids = quad_tree_seeds(I,k);

 % allocate space for labels and best distances
[M,N,~] = size(I);
L = ones(M,N,'uint32') * -1;
D = inf(M,N);

% iteratively move centroids
n = 10; % max iterations
m = 100;
for i = 1:n
    % for each centroid
    for j = 1:length(centroids)
        C = centroids(j);
        
        m1 = double(C.middle); n1 = double(C.center);
        a1 = double(C.area); w = C.width; h = C.height;
        p1 = I(m1,n1,:);
        
        % define search region
        left = max(1, n1 - w);
        right = min(N, n1 + w);
        top = max(1, m1 - h);
        bottom = min(M, m1 + h);
        
        % for each pixel in the centroid's search region
        for m2 = top:bottom
            for n2 = left:right
                % find distance between this pixel and the centroid
                p2 = I(m2,n2,:);
                di = sum((p2 - p1) .^ 2);
                ds = (double(m2) - m1) ^ 2 + (double(n2) - n1) ^ 2;
                d = sqrt(di + ds / a1 * m); % todo how to normalized ds
                
                % if this distance is between than the best we've seen
                if d < D(m2,n2)
                    % update this pixel's best distance and label
                    D(m2,n2) = d;
                    L(m2,n2) = j;
                end
            end
        end
    end    
    
    % todo update the centroid locations
    
end

imshow(label2rgb(L));
