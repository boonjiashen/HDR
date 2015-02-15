%% Tune bilateral filter for a particular dataset

if ~exist('folder', 'var')
    error('!!!!!!!!Image Folder was not specified!!!!!!!!')
end

[exposures, images] = ReadImagesFromFolder(folder);

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
im_radiance = hdrDebevec(images, debevec_g, lnExpTime, w);

%%

contrast = 15;
for spatial_sigma = [1, 3, 10]
    disp(spatial_sigma)
    im_bilateral = BFMapper(im_radiance, 'contrast', contrast, 'spatial_sigma', spatial_sigma);    
    figure('name', sprintf('spatial sigma=%i', spatial_sigma)); imshow(im_bilateral);
end

disp('done!');



%% for contrast = [5 15 25];
for contrast = 15;
    for spatial_sigma = [30]
        disp(spatial_sigma)
        im_bilateral = BFMapper(im_radiance, 'contrast', contrast, 'spatial_sigma', spatial_sigma);
        description = sprintf('minion_contrast%i_spatial%i_240.jpg', contrast, spatial_sigma);
        figure('name', description); imshow(im_bilateral);
        
        imwrite(im_bilateral, description);
    end
end
