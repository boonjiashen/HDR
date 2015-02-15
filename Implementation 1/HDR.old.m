%function HDR( folder, extensions )
%HDR Summary of this function goes here
%   Detailed explanation goes here

disp('Hi! This is the HDR algorithm implemented as part of the CS766 Project')
disp('-Jiashen Boon and Urmish Thakker')

if (~exist('folder'))
    error('!!!!!!!!Image Folder was not specified!!!!!!!!')
end

if (~exist('extensions'))
    disp('Since an extension was not specified, assuming jpg')
    extensions ='.jpg';
end

disp('Loading Images from folder')
[exposures, images] = ReadImagesFromFolder(folder,extensions);
[row, col, channels, noi] = size(images);

%imshow(uint8(images(:,:,:,5)))
%[g_y,g_x] = ginput(12)
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
%lnE = zeros(size(g_x,1),channels);

weight = [1:1:256];
weight = min(weight, 256-weight); %Giving higher weight to images in the middle
w = weight;
w = w/max(w); 
%Z = zeros (size(g_x,1),channels,noi)
%size(Z)
% for i = 1:size(g_x,1)
%     for channel = 1:channels
%         for n = 1:noi
%             Z(i,channel,n) = images(floor(single(g_y(i))),floor(single(g_x(i))),channel,n);
%         end
%     end
% end
for channel = 1:channels
	[debevec_g(:,channel), lnE(:,channel)] = gsolve(reshape(shrunk_images(:,:,channel,:), shrunk_row*shrunk_col, noi), lnExpTime, 10, w);
%     z_tmp = zeros(size(g_x,1),noi);
%     for n= 1:noi
%         z_tmp(:,n) = Z(:,channel,n);
%     end
%     [debevec_g(:,channel), lnE(:,channel)] = gsolve(z_tmp, lnExpTime, 100, w);
end

plot(debevec_g(:,1))


disp('Constructing HDR Radiance Map - Debevec');
imgHDR = hdrDebevec(images, debevec_g, lnExpTime, w);
imwrite(imgHDR, 'debevec.png');

disp('Constructing HDR Radiance Map - ReinHard');
imgTMO = Reinhard(imgHDR, 0.18, 1e-6, 3);
imwrite(imgTMO, 'reinhard.png');

disp('done!');
%end

