function [RGB,D] = load_color_depth_pair(name,view)
    if nargin < 1; name = 'Adirondack'; end
    if nargin < 2; view = 0; end

    dir = sprintf('Data\\Middlebury3\\%s\\',name);
    if ~isfolder(dir); error('directory not found'); end
    
    getPath = @(fileName) fullfile(dir, sprintf(fileName,view));

    pathRGB = getPath('im%d.png'); pathD = getPath('disp%dGT.pfm');
    if ~(isfile(pathRGB) && isfile(pathD)); error('one or more files not found'); end
    
    RGB = imread(pathRGB);
    D = readpfm(pathD);
    
    % crop each image to be square
    [M,N,~] = size(RGB);
    sz = min(M,N);
    left = max(1,floor((N-sz) / 2)); right = min(N,left+sz);
    top = max(1,floor((M-sz) / 2)); bottom = min(M,top+sz);
    RGB = RGB(top:bottom,left:right,:);
    D = D(top:bottom,left:right,:);
    
    % downsample the image
    mxSz = 800;
    if sz > mxSz
        RGB = imresize(RGB,[mxSz mxSz]);
        D = imresize(D,[mxSz mxSz]);
    end
end
