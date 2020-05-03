function segs = quad_tree(img,num_segs,rgb)
    % image = an M x N x Z image
    % num_segs = number of of final segments, mod(k,3) == 1
    % var_func = segment variance function
    % segs = the segment ranges, variance top bottom left right
    
    num_segs = num_segs - (mod(num_segs,3) - 1); % adjust k if needed
    segs = priority_queue(num_segs); % allocate space for segments
    [M,N,~] = size(img); % get image height and width
    M = uint32(M); N = uint32(N);    
    rng = img_range(uint32(1),N,uint32(1),M);
    var = find_var(img,rng); % find variance of the full image
    seg = node(var,rng);
    segs.enqueue(seg); % add the full image range as a segment
    
    % repeatedly split the image until we get the number of segments we need
    num_splits = (num_segs - 1) / 3;
    for i = 1:num_splits
       % remove element with most variance
       % since we are using a priority queue, this is always the top element
       seg = segs.dequeue();
       
       % split into quadrants
       % calculate variance of each 
       [ne,se,sw,nw] = split(seg.data);
       new_rngs = [ne, se, sw, nw];
       vars = arrayfun(@(rng) find_var(img,rng), new_rngs);    
       
       % insert each into queue
       for i = 1:4
           rng = new_rngs(i);
           var = vars(i);
           seg = node(var,rng);
           segs.enqueue(seg);
       end
    end
end

function result = find_var(I,rng)
    I_rng = I(rng.top:rng.bottom,rng.left:rng.right);
    v = var(I_rng,0,[1 2]);
    v = sum(v);
    result = v * rng.area;
end

function [ne,se,sw,nw] = split(r)
    % todo need ints
    middle = r.left + (r.right - r.left) / 2;
    center = r.top + (r.bottom - r.top) / 2;

    ne = img_range(middle+1,r.right,r.top,center);
    se = img_range(middle+1,r.right,center+1,r.bottom);
    sw = img_range(r.left,middle,center+1,r.bottom);
    nw = img_range(r.left,middle,r.top,center);
end
