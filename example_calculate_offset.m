%% Align two offset images

% Load two grayscale images of difference exposures
im_exp1 = rgb2gray(imread('exposures/img08.jpg'));
im_exp2 = rgb2gray(imread('exposures/img05.jpg'));

im_ref = im_exp1;  % Reference image for alignment (and we shift the other one)

for i = 1:3
    
    % Translate second image by a ground truth
    true_offset = randi([-max_offset max_offset], [1 2]);
    im_offset = circshift(im_exp2, true_offset);

    % Calculate offset
    calc_offset = calculate_offset(im_ref, im_offset, max_offset);

    figure_title = sprintf('True offset = %s, calculated = %s', num2str(true_offset), num2str(calc_offset));
    figure;
    subplot(1, 2, 1); imshow(im_ref); title('Reference image');
    subplot(1, 2, 2); imshow(im_offset); title(['Offset image, ' figure_title]);
    
end