function [ offset ] = calculate_offset( im_ref, im_offset, max_offset )
%CALCULATE_OFFSET Returns the offset of an offset image from a reference
% `im_ref` is the grayscale reference image
% `im_offset` is the image that is offset from the reference image
% `max_offset` is a scalar; maximum that im_offset can be offset from im_ref in any dimension
% `offset` is a [vert_offset, hori_offset] matrix

% Coarse resolution offset calculated from subsample of input images
if max_offset == 1
    coarse_offset = [0 0];
else
    coarse_offset = 2 * calculate_offset( ...
        halfsize(im_ref), ...
        halfsize(im_offset), ...
        2^ceil((log2(max_offset)) - 1));
end

% Binarize both input images to ease comparison
threshold = median([im_ref(:)' im_offset(:)']);
im_ref_bin = im_ref < threshold;
im_offset_bin = im_offset < threshold;

% Remove border pixels to compare same no. of pixels every offset
crop_offset = im_offset_bin( ...
    1 + max(coarse_offset(1) + 1, 0) : end - max(1 - coarse_offset(1), 0), ...
    1 + max(coarse_offset(2) + 1, 0) : end - max(1 - coarse_offset(2), 0) ...
    );

% Calculate the best offset from candidates that are +-1 from the coarse offset
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
        
        % Use XOR to compute how bad this offset is
        cost = sum(xor(crop_ref(:), crop_offset(:)));
        
        if cost < min_cost
            min_cost = cost;
            best_offset = [y_offset x_offset];
        end
    end
end

offset = best_offset;