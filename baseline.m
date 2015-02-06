%% Baseline HDR algorithm using MATLAB's image toolbox

%% Get relative filepaths of input images to HDR

filenames = dir('exposures/*.jpg');
for i = 1 : numel(filenames)
    fullpaths{i} = ['exposures/' filenames(i).name];
end
% 
% for i = 1:numel(filenames)
%     ims{i} = imread(['exposures/' filenames{i}]);
% end

%% Create HDR image

im_hdr = makehdr(fullpaths);  % Create HDR image from input images
im_ldr = tonemap(im_hdr);  % Map HDR to 0:255 range to make it viewable

imshow(im_ldr);