% get path from user
[fileName, dirPath] = uigetfile('Data\Middlebury3\*.pfm');
if isnumeric(fileName) && fileName == 0; disp('file not selected or not found'); return; end
filePath = fullfile(dirPath, fileName);
if ~isfile(filePath); disp('file not found'); return; end

% read pfm file
D = readpfm(filePath);

% print stats
fprintf('\n');
disp(filePath);
fprintf('min         %.2f\n', min(D(:)));
fprintf('max         %.2f\n', max(D(:)));
fprintf('height      %d\n', size(D, 1));
fprintf('width       %d\n', size(D, 2));
fprintf('num pixels  %d\n', numel(D));
fprintf('\n');

% display figure with histgram and colored depth image
figure; 
imshow(D, [], 'Border', 'tight', 'Colormap', parula); 
colorbar;
title(fileName);
