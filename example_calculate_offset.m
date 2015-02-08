%% Align two offset images

filename = 'exposures/img08.jpg';
max_offset = 100;  % Assume offset in any dim is always less than this

im_ref = rgb2gray(imread(filename));

for i = 1:3
    
    % Translate reference image by a ground truth
    true_offset = randi([-max_offset max_offset], [1 2]);
    im_offset = circshift(im_ref, true_offset);

    % Calculate offset
    calc_offset = calculate_offset(im_ref, im_offset, max_offset);

    figure_title = sprintf('True offset = %s, calculated = %s', num2str(true_offset), num2str(calc_offset));
    figure;
    subplot(1, 2, 1); imshow(im_ref); title('Reference image');
    subplot(1, 2, 2); imshow(im_offset); title(['Offset image, ' figure_title]);
    
    % Compare calculation with truth
    fprintf('%s \t True offset\n', num2str(true_offset));
    fprintf('%s \t Calculated offset\n', num2str(calc_offset));
end