%% Align the images of the lamp series

%% Get filename of two images to be aligned

folder = 'lamp_series';
extension = 'JPG';
filenames = get_rel_path_of_images(folder, extension);

middle_ind = floor(numel(filenames) / 2);
filename1 = filenames{middle_ind + 2};
filename2 = filenames{middle_ind + 3};

%% Calculate offset

% Load two grayscale images of difference exposures
im_exp1 = rgb2gray(imread(filename1));
im_exp2 = rgb2gray(imread(filename2));

im_ref = im_exp1;  % Reference image for alignment (and we shift the other one)
im_offset = im_exp2;

% Calculate offset
max_offset = 100;  % Some arbitrary value
calc_offset = calculate_offset(im_ref, im_offset, max_offset);

%% Display results

figure('name', 'Input images');
subplot(1, 2, 1); imshow(im_ref); title(sprintf('Reference image, %f s exposure', get_exposure(filename1)));
title2 = sprintf('Offset image, %f s exposure, calculated offset = %s', ...
    get_exposure(filename2), ...
    num2str(calc_offset));
subplot(1, 2, 2); imshow(im_offset); title(title2);

figure('name', 'Image difference before and after alignment');
subplot(1, 2, 1); imshow(abs(im_ref - im_offset)); title('Absolute diff w/o alignment');
subplot(1, 2, 2); imshow(abs(im_ref - circshift(im_offset, -calc_offset))); title('Absolute diff with alignment');