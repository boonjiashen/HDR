%% Baseline HDR algorithm using MATLAB's image toolbox

%% Get relative filepaths of input images to HDR

if exist('extension', 'var')
    fullpaths = get_rel_path_of_images(folder, extension);
else
    fullpaths = get_rel_path_of_images(folder);
end

%% Create HDR image

im_hdr = makehdr(fullpaths);  % Create HDR image from input images
im_ldr = tonemap(im_hdr);  % Map HDR to 0:255 range to make it viewable

imshow(im_ldr);