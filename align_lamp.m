%% Align the images of the lamp series

%% Get filename of two images to be aligned

folder = 'lamp_series';
extension = 'JPG';
filenames = get_rel_path_of_images(folder, extension);
filenames = filenames(end - 7 : end);  % Reduce no. of images to a subset

n_images = numel(filenames);
images = cell(1, n_images);
for ni = 1 : numel(filenames)
    images{ni} = rgb2gray(imread(filenames{ni}));
end

%% Calculate offset

ind_ref = floor(numel(filenames) / 2);  % Index of reference image

% Calculate offset of every image to the reference image
max_offset = 100;  % Some arbitrary value
calc_offsets = zeros(n_images, 2);
for ni = 1 : n_images
    if ni == ind_ref; continue; end;
    calc_offset = calculate_offset(images{ind_ref}, images{ni}, max_offset);
    calc_offsets(ni, :) = calc_offset;
end

%% Display results

% Prevents underscore from acting as subscript in plot title
set(0, 'defaulttextinterpreter', 'none');  

for ni = 1 : n_images
    if ni == ind_ref; continue; end;

    fn_ref = filenames{ind_ref};  % filename of reference image
    im_ref = images{ind_ref};
    fn_offset = filenames{ni};  % filename of offset image
    im_offset = images{ni};
    calc_offset = calc_offsets(ni, :);
    
    figure('name', 'Input images');
    subplot(2, 2, 1); imshow(im_ref); title(sprintf(['Reference ' fn_ref ', %.3f s exposure'], get_exposure(fn_ref)));
    
    title2 = sprintf(['Offset ' fn_offset ', %.3f s exposure, calculated offset = %s'], ...
        get_exposure(fn_offset), ...
        num2str(calc_offset));
    subplot(2, 2, 2); imshow(im_offset); title(title2);
    subplot(2, 2, 3); imshow(abs(im_ref - im_offset)); title('Absolute diff w/o alignment');
    subplot(2, 2, 4); imshow(abs(im_ref - circshift(im_offset, -calc_offset))); title('Absolute diff with alignment');
    
end