%% Align 2 images of the lamp series

%% Get filename of two images to be aligned

filenames = get_rel_path_of_images(folder, extension);

middle_ind = floor(numel(filenames) / 2);
filename1 = filenames{middle_ind - 1};
filename2 = filenames{middle_ind};

%% Calculate offset

% Load two images of difference exposures
im_exp1 = (imread(filename1));
im_exp2 = (imread(filename2));

im_ref = im_exp1;  % Reference image for alignment (and we shift the other one)
im_offset = im_exp2;

% Calculate offset
max_offset = 100;  % Some arbitrary value
calc_offset = calculate_offset(rgb2gray(im_ref), rgb2gray(im_offset), max_offset);

%% Display results

figure;
subplot(2, 2, 1); imshow(im_ref); title(sprintf('Reference image, %.3f s exposure', get_exposure(filename1)));
title2 = sprintf('Offset image, %.3f s exposure, calculated offset = %s', ...
    get_exposure(filename2), ...
    num2str(calc_offset));
subplot(2, 2, 2); imshow(im_offset); title(title2);
subplot(2, 2, 3); imshow(abs(im_ref - im_offset)); title('Absolute diff w/o alignment');
subplot(2, 2, 4); imshow(abs(im_ref - circshift(im_offset, -calc_offset))); title('Absolute diff with alignment');