%function HDR( folder, extensions )
%HDR Summary of this function goes here
%   Use - HDR('../../../Images/','.jpg')
%   Detailed explanation goes here

disp('Hi! This is the HDR algorithm implemented as part of the CS766 Project')
disp('-Jiashen Boon and Urmish Thakker')

if ~exist('folder', 'var')
    error('!!!!!!!!Image Folder was not specified!!!!!!!!')
end

if exist('extensions', 'var')
    [exposures, images] = ReadImagesFromFolder(folder,extensions);
else
    [exposures, images] = ReadImagesFromFolder(folder);
end

disp('Loading Images from folder')
[row, col, channels, noi] = size(images);
disp('Shrinking Images - I am not sure how to select the pixels, we can fix this later') %TODO
shrunk_row = 20;
shrunk_col = 30;
shrunk_images = zeros(shrunk_row, shrunk_col, channels, noi);
for i = 1:noi
	shrunk_images(:,:,:,i) = round(imresize(images(:,:,:,i), [shrunk_row shrunk_col], 'bilinear'));
end

lnExpTime = log(exposures);

disp('Using gsolve as described by debevec')
debevec_g = zeros(256,channels);
lnE = zeros(shrunk_row*shrunk_col,channels);

weight = [1:1:256];
weight = min(weight, 256-weight); %Giving higher weight to images in the middle
w = weight;
w = w/max(w); 

for channel = 1:channels
	[debevec_g(:,channel), lnE(:,channel)] = gsolve(reshape(shrunk_images(:,:,channel,:), shrunk_row*shrunk_col, noi), lnExpTime, 10, w);
end

disp('Constructing HDR Radiance Map - Debevec');
imgHDR = hdrDebevec(images, debevec_g, lnExpTime, w);
imwrite(imgHDR, 'debevec.png');

disp('Tone Mapping - ReinHard');
alpha_ = 0.18;
delta = 1e-6;
white_ = 3;
imgTMO = Reinhard(imgHDR, alpha_, delta, white_);
imwrite(imgTMO, 'reinhard.png');
disp('Tone Mapping - Bilateral Filter');
imgBFO = BFMapper(imgHDR);

figure('name', 'Reinhard tone map'); imshow(imgTMO);
figure('name', 'Bilateral filter tone map'); imshow(imgBFO);

disp('done!');
