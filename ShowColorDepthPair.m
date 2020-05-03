function ShowColorDepthPair(name, view)
    if nargin < 1; name = 'Adirondack'; end
    if nargin < 2; view = 0; end

    [I, D] = LoadColorDepthPair(name, view);

    figure('WindowState', 'maximized');
    subtightplot(1,2,1);
    imshow(I, 'Border', 'tight');
    title('Color');

    subtightplot(1,2,2);
    imshow(D, [], 'Border', 'tight', 'Colormap', parula); 
    title('Depth');
end
