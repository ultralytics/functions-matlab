function [] = resavematfiles()
% CAUTION. This function loads EVERY mat file in the directory tree and 
% resaves it with compression. This file is useful for archiving old matlab
% code on GitHub.
clc; clear; close

folder = uigetdir();
files = dir([folder '/**/*.mat']);
n=numel(files);

for i = 1:n
    filename = [files(i).folder filesep files(i).name];
    fprintf('%g/%g: %s\n',i,n,filename)
    A = load(filename); %#ok<NASGU>
    save(filename,'-struct','A')
end
    
    