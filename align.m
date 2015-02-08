%% Align two offset images

filename = 'exposures/img08.jpg';
max_offset = 1;  % Assume offset in any dim is always less than this

im_ref = rgb2gray(imread(filename));
true_offset = [1 1];
im_offset = circshift(im_ref, true_offset);

% figure('name', 'ref');
% imshow(im_ref);
% figure('name', 'offset');
% imshow(im_offset);

% Binarize both input images to ease comparison
threshold = median([im_ref(:)' im_offset(:)']);
im_ref_bin = im_ref < threshold;
im_offset_bin = im_offset < threshold;


crop_offset = im_offset_bin(...
    2 : end - 1, ...
    2 : end - 1);  % Remove border pixels to compare same no. of pixels every offset
best_offset = NaN; min_cost = Inf;
for y_offset = -1 : 1
    for x_offset = -1 : 1
        crop_ref = im_ref_bin( ...
            -y_offset + 2 : -y_offset + 1 + size(crop_offset, 1), ...
            -x_offset + 2 : -x_offset + 1 + size(crop_offset, 2));
        cost = sum(xor(crop_ref(:), crop_offset(:)));
        
        if cost < min_cost
            min_cost = cost;
            best_offset = [y_offset x_offset];
        end
    end
end
fprintf('True offset is %s\n', num2str(true_offset));
fprintf('Calculated offset is %s\n', num2str(best_offset));