% implements main function of speaker recognition
%% Author info
% Wangbo Zheng and Hao Wang
% University of Stuttgart
%%
% read the TIMIT speaker test files, including the number of
% the speakers, speaker files and speaker names in each fold and subfold.
[num_speaker,speaker_file,speaker_name] = extract_files;

%  get all the adapted parameter information, name, 
% index of the test file and frame length of the test files for each speaker
for NrOfFile= 1:10
    
    speaker_data=speaker_dataset(NrOfFile,num_speaker,speaker_file,speaker_name);
    % get dentification result, including true name, estimated name
    % and the frame length of test files
    detection_info = detection_cell(speaker_data);
    
end;

% get the detection rate(percentage of frames), correct rate
% (percentage of correct speakers) and confusion matrix.
[detection_rate,  correct_rate, confusion_matrix] = detection_rate_confusion_matrix(detection_info_1,detection_info_2,...
                                            detection_info_3,detection_info_4,...
                                            detection_info_5,detection_info_6,...
                                            detection_info_7,detection_info_8,...
                                            detection_info_9,detection_info_10);
                                       
for NrOfFile= 1:10
    
    speaker_data=speaker_dataset(NrOfFile,num_speaker,speaker_file,speaker_name);
    
    % get dentification result, including true name, estimated name
    % and the frame length of test files of 170 speakers
    % including us (Wangbo Zheng and Hao Wang)
    % our own recordings were stored in the first folder "dr1".
    detection_info_170speakers = detection_cell_for_own_audios(speaker_data);
    
end;   

                                        
                                        
 



