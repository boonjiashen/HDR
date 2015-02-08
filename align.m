%% Align two offset images

filename = 'exposures/img08.jpg';
max_offset = 1;  % Assume offset in any dim is always less than this

im_ref = rgb2gray(imread(filename));
% im_ref = magic(10);
true_offset = [100 -100];
im_offset = circshift(im_ref, true_offset);

% Binarize both input images to ease comparison
threshold = median([im_ref(:)' im_offset(:)']);
im_ref_bin = im_ref < threshold;
im_offset_bin = im_offset < threshold;

% figure('name', 'ref');
% imshow(im_ref);
% figure('name', 'offset');
% imshow(im_offset);
% figure('name', 'ref');
% imshow(im_ref_bin);
% figure('name', 'offset');
% imshow(im_offset_bin);

coarse_offset = true_offset;  % Coarse resolution offset calculated from subsamples
crop_offset = im_offset_bin( ...
    1 + max(coarse_offset(1) + 1, 0) : end - max(1 - coarse_offset(1), 0), ...
    1 + max(coarse_offset(2) + 1, 0) : end - max(1 - coarse_offset(2), 0) ...
    );  % Remove border pixels to compare same no. of pixels every offset
best_offset = NaN; min_cost = Inf;
for y_offset = (-1 : 1) + coarse_offset(1)
    for x_offset = (-1 : 1) + coarse_offset(2)
        
        % No. of pixels to crop out from reference image, to compare with
        % offset image
        remove_btm = max(coarse_offset(1) - 1, 0) + y_offset - coarse_offset(1) + 1;
        remove_right = max(coarse_offset(2) - 1, 0) + x_offset - coarse_offset(2) + 1;
        
        % Crop reference image to compare with offset image
        crop_ref = im_ref_bin( ...
            end - remove_btm - size(crop_offset, 1) + 1 : end - remove_btm, ...
            end - remove_right - size(crop_offset, 2) + 1 : end - remove_right ...
            );
        cost = sum(xor(crop_ref(:), crop_offset(:)));
        
        if cost < min_cost
            min_cost = cost;
            best_offset = [y_offset x_offset];
            [min_cost best_offset]
            figure;
            subplot(1, 2, 1); imshow(crop_ref);
            subplot(1, 2, 2); imshow(crop_offset);
            
        end
    end
end
fprintf('True offset is %s\n', num2str(true_offset));
fprintf('Calculatedt offset is %s\n', num2str(best_offset));