%% Align two offset images

filename = 'exposures/img08.jpg';
max_offset = 100;  % Assume offset in any dim is always less than this

im_ref = rgb2gray(imread(filename));

for i = 1:10
    
    % Translate reference image by a ground truth
    true_offset = randi([-max_offset max_offset], [1 2]);
    im_offset = circshift(im_ref, true_offset);

    % Calculate offset
    calc_offset = calculate_offset(im_ref, im_offset, max_offset);

    % Compare calculation with truth
    fprintf('%s \t True offset\n', num2str(true_offset));
    fprintf('%s \t Calculated offset\n', num2str(calc_offset));
end