close all;
clear all;
clc;
dirpath1='DepthImages\Right Hand Horizontal Wave';
file_dir = 'DepthData\';
action = 'Right Hand Horizontal Wave'; 
    action_dir = strcat(file_dir,action,'\'); %strcat is string concatenation
    fpath = fullfile(action_dir, '*.mat');
    depth_dir = dir(fpath);
    n=0;
    for i = 1:length(depth_dir)
        depth_name = depth_dir(i).name; % Show the Name of the depth sequence
        type='mat';
type1='jpg';
oldvar = 'depth';
    infile = fullfile('DepthData\Right Hand Horizontal Wave',depth_name); 
    datastruct = load(infile);
    fn = fieldnames(datastruct);
    firstvar = fn{1};
    data = datastruct.(firstvar);
    size(data,3);
for k=1:size(data,3)
    outfile = fullfile(dirpath1, sprintf('horizontalwave%d.jpg',k+n));
    imwrite(data(:,:,k),outfile);
    if ~strcmp(oldvar, firstvar)
      fprintf('loading from variable %s as of file %d\n', firstvar);
    end
end
n=n+size(data,3);
    end