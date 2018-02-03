function detection_info_170speakers = detection_cell_for_own_audios(speaker_data)
% this function is almost the same with the function "detection
% cell",except that the overall number of speakers is 170,including us
% (Wangbo Zheng and Hao Wang)
% our own recordings were stored in the first folder "dr1".
% implements to get dentification result, including true name, estimated name
% and the frame length of test files
%% Author info
% Wangbo Zheng and Hao Wang
% University of Stuttgart

%% 
% Vectorize the speaker info

 speaker_data_vector = [speaker_data(1:13,1);speaker_data(1:26,2);
                       speaker_data(1:26,3);speaker_data(1:32,4);
                       speaker_data(1:28,5);speaker_data(1:11,6);
                       speaker_data(1:23,7);speaker_data(1:11,8)];
 detection_info_170speakers=cell(170,3);
 for i = 1:170
     
     b_unknown = speaker_data_vector{i}.b_training;
     true_name = speaker_data_vector{i}.name;
     num_test_frame = speaker_data_vector{i}.lengthOfTestFrame;
     T=size(b_unknown,1);
     P_adapted=zeros(170,T); 
     
     for j=1:170
         weighted_pdf=zeros(T,T); 
         for k=1:49
             Minus_interm = bsxfun(@minus,b_unknown,speaker_data_vector{j}.means_adapted(k,:));
             P_adapted_interm = speaker_data_vector{j}.weight_adapted(k)*(1/sqrt(double((2*pi)^15)*det(speaker_data_vector{j}.cov_adapted((k-1)*15+1:k*15,:))))* ...
             exp(-0.5*Minus_interm*(eye(15,15)/speaker_data_vector{j}.cov_adapted((k-1)*15+1:k*15,:))*Minus_interm');
             weighted_pdf=P_adapted_interm+weighted_pdf;        
         end;
         P_adapted(j,:)=diag(weighted_pdf)';
     end;
         log_likeli_pdf = sum(log(P_adapted),2);
         [ma,speaker_id]=max(log_likeli_pdf); % index of the max value
         estimate_name = speaker_data_vector{speaker_id}.name;
 
         detection_info_170speakers(i,:) = {true_name estimate_name num_test_frame};
       
 end;