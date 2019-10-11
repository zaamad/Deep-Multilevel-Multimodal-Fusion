close all;
clear all;
clc;
dirpath1='SignalImages\Hand Clap'
file_dir = 'InertialData\'
action = 'Hand Clap' 
    action_dir = strcat(file_dir,action,'\') %strcat is string concatenation
    fpath = fullfile(action_dir,'*.mat')
    depth_dir = dir(fpath)
  N=0;
    for i = 1:length(depth_dir) 
         n=1;m=52; 
    
        depth_name = depth_dir(i).name; % Show the Name of the depth sequence
        type='mat';
type1='[]';
oldvar = 'd_iner';
infile = fullfile('InertialData\Hand Clap',depth_name);
 datastruct = load(infile);
    fn = fieldnames(datastruct);
    firstvar = fn{1};
    data = datastruct.(firstvar);
data=data';
data=[data;data(1,:);data(3,:);data(5,:);data(2,:);data(4,:);data(6,:);...
    data(1,:);data(4,:);data(2,:);data(5,:);data(3,:);data(6,:);...
    data(1,:);data(5,:);data(2,:);data(6,:);data(1,:);data(6,:)];
size(data);
for k=1:2
 data1=data(:,n:m);
 F=mat2gray(data1);
 outfile = fullfile(dirpath1, sprintf('clap%d.jpg',k+N));
imwrite(F,outfile)
 if ~strcmp(oldvar, firstvar)
      fprintf('loading from variable %s as of file %d\n', firstvar);
 end
 n=n+52;m=m+52;
end
N=N+2;
end





 