function [ im_output ] = halfsize( im_input )
%HALFSIZE Returns an image scaled down 50%, with appropriate blurring

kernel = fspecial('gaussian');
im_blurred = conv2(double(im_input), kernel);
im_output = im_blurred(1:2:end, 1:2:end);

im_output = cast(im_output, 'like', im_input);  % Make same type as input