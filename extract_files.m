function [num_speaker,speaker_file,speaker_name] = extract_files
% implements to read the TIMIT speaker test files, including the number of
% the speakers, speaker files and speaker names in each fold and subfold.
%% Author info
% Wangbo Zheng and Hao Wang
% University of Stuttgart

%% Reference
% matlab DIRR function written by Maximilien Chaumon on www.mathworks.com
% to lists all files in the current directory and sub directories 

%%
% get all the folds and files using dirr function, read the own audio fold
% path
Files = dirr(fullfile('/Users/Ben/Documents/MATLAB/forStudents Kopie/timit/test','*.wav'));

% get the number of people in differrent folds
num_speaker = zeros(8,1);
for i= 1: 8
   num_speaker(i)= length(Files(i).isdir);

end


for j= 1:8         % 8 subfolds
   for k=1:num_speaker(j) % # people in each subfold

      speaker_file{k,j}=cellstr(char(Files(j).isdir(k).isdir.name)); 
      % first convert to char ,because easy to get the file names,then  to
      % cell, because easy to array them 
      speaker_name{j} = cellstr(char(Files(j).isdir.name));
   end
  
end