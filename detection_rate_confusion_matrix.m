function [detection_rate,  correct_rate, confusion_matrix] = detection_rate_confusion_matrix(detection_info_1,detection_info_2,...
                                            detection_info_3,detection_info_4,...
                                            detection_info_5,detection_info_6,...
                                            detection_info_7,detection_info_8,...
                                            detection_info_9,detection_info_10)
% implements to get the detection rate(percentage of frames), correct rate
% (percentage of correct speakers) and confusion matrix.
%% Author info
% Wangbo Zheng and Hao Wang
% University of Stuttgart

%%
%  vectorize the detection info and initialization
detection_info_all = cell(1,10);
detection_info_all{1}=detection_info_1;
detection_info_all{2}=detection_info_2;
detection_info_all{3}=detection_info_3;
detection_info_all{4}=detection_info_4;
detection_info_all{5}=detection_info_5;
detection_info_all{6}=detection_info_6;
detection_info_all{7}=detection_info_7;
detection_info_all{8}=detection_info_8;
detection_info_all{9}=detection_info_9;
detection_info_all{10}=detection_info_10;

new_speaker_judge=zeros(168,10);
frame_sum = 0;
confusion_matrix= zeros(168,168);
num_correct_speaker = 0;

%% -------------- detection rate computing phase -------------- %
for i = 1:10
   
    speaker_judge=zeros(168,1);
    
       for j=1:168
       speaker_judge(j) = double(strcmp(detection_info_all{i}{j, 1},detection_info_all{i}{j, 2}));
       end
   
   new_speaker_judge(:,i) = cell2mat(detection_info_all{i}(1:168, 3)).*speaker_judge;
   frame_sum_interm= sum(cell2mat(detection_info_all{i}(1:168, 3)));
   frame_sum = frame_sum+frame_sum_interm;
   num_correct_speaker = num_correct_speaker+sum(speaker_judge);
  
%% ---------- confusion matrix computing phase ---------------- % 
   
   confusion_matrix_interm = diag(speaker_judge);
   cmp_interm = zeros(168,1);
   false_speaker_id = find(1-speaker_judge);
       
       for a= 1:size(false_speaker_id)
           
           false_speaker_name = detection_info_all{i}{false_speaker_id(a),2};
           
           for b= 1:168
               
              cmp_interm(b) = strcmp(detection_info_all{i}{b,1},false_speaker_name);
           
           end
           confusion_matrix_interm(find(cmp_interm),false_speaker_id(a)) = 1;
           
       end
   confusion_matrix =  confusion_matrix+ confusion_matrix_interm;
end

%% result output

detection_rate = sum(sum(new_speaker_judge))/frame_sum ;
correct_rate = num_correct_speaker /1680;
confusion_matrix = sparse(confusion_matrix);
 
end