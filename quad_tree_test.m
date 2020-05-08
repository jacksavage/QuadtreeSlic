[I,RGB] = load_lab_depth_img;

% find quad tree ranges
k = 100;
qt_segs = quad_tree(I,k);
segs(1:qt_segs.tail-1) = img_range();
for i = 1:length(segs)
    segs(i) = qt_segs.nodes(i).data;
end

display_quad_tree(RGB,segs,true,false,true);
