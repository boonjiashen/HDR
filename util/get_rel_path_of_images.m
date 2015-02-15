function [ relpaths ] = get_rel_path_of_images( folder, extension )
%GET_REL_PATH_OF_IMAGES Summary of this function goes here
%   Get relative path of images in a folder
%   Example: If folder is '../exposures' and extension is 'jpg',
%   returns {'../exposures/001.jpg', '../exposures/002.jpg', etc}

% Get filenames (without folder)
glob = fullfile(folder, ['*.' extension]);
filenames = dir(glob);

% Add folder to filenames
relpaths = cell(numel(filenames, 1));
for i = 1 : numel(filenames)
    relpaths{i} = fullfile(folder, filenames(i).name);
end

end

