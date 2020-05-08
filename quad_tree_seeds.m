function seeds = quad_tree_seeds(I,k)
    qt_segs = quad_tree(I,k);
    seeds(1:(qt_segs.tail - 1),1) = img_range();
    for i = 1:(qt_segs.tail - 1)
        seeds(i) = qt_segs.nodes(i).data;
    end
end
