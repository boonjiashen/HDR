function [ exposure ] = get_exposure( filename )
%UNTITLED Get the exposure of an image file, given its filename

image_i_info = imfinfo(filename);
exposure = image_i_info.DigitalCamera.ExposureTime;

end

