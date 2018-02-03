function speaker_data=speaker_dataset(NrOfFile,num_speaker,speaker_file,speaker_name)
% implements to get all the adapted parameter information, name, 
% index of the test file and frame length of the test files for each speaker 
%% Author info
% Wangbo Zheng and Hao Wang
% University of Stuttgart

%%
% 8 folds
for i = 1:8
    
%     for each speaker 
    for j= 1: num_speaker(i)
       [b lengthOfFrame]= speaker_feature_matrix(j,i,speaker_file,speaker_name);
       [speaker_data{j,i}.b_test speaker_data{j,i}.b_training]=testfileSelection(lengthOfFrame,b,NrOfFile);
      
       [speaker_data{j,i}.weight_adapted,speaker_data{j,i}.means_adapted, speaker_data{j,i}.cov_adapted] = SpeakerModelsAdaption(speaker_data{j,i}.b_training);
       speaker_data{j,i}.name = speaker_name{1,i}{j};
       speaker_data{j,i}.NrOfFile=NrOfFile;
       speaker_data{j,i}.lengthOfTestFrame=lengthOfFrame(NrOfFile);
    end;
    
end;
