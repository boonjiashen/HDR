function [ exposures, images ] = ReadImagesFromFolder( folder, extensions )
%READIMAGESFROMFOLDER Summary
%   Reads Images from a folder and returns a matrix of image values and
%   their corresponding exposure values

images = [];
exposures = [];

filenames = dir([folder,'/*',extensions]);
NOI = length(filenames); %Represents the number of images in the folder
exposures = zeros(NOI,1);
%disp (exposures);
instanceFile = [folder,'/',filenames(1).name];
image_info = imfinfo(instanceFile);
%disp(image_info.DigitalCamera.ExposureTime) %DigitalCamera has the field ExposureTime in
%it
images = zeros(image_info.Height, image_info.Width, image_info.NumberOfSamples, NOI); %NumberOfSamples 
%is the number of color channels

for i = 1:NOI
    filename = [folder, '/', filenames(i).name];
	img = imread(filename);
	images(:,:,:,i) = img;
	image_i_info = imfinfo(filename);
	exposures(i) = image_i_info.DigitalCamera.ExposureTime;
end

end

