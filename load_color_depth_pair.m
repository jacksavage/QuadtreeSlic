function [I, D] = load_color_depth_pair(name, view)
    if nargin < 1; name = 'Adirondack'; end
    if nargin < 2; view = 0; end

    dir = sprintf('Data\\Middlebury3\\%s\\', name);
    if ~isfolder(dir); error('directory not found'); end
    
    getPath = @(fileName) fullfile(dir, sprintf(fileName, view));

    pathI = getPath('im%d.png'); pathD = getPath('disp%dGT.pfm');
    if ~(isfile(pathI) && isfile(pathD)); error('one or more files not found'); end
    I = imread(pathI);
    D = readpfm(pathD);
end
