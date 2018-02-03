function detection_info = detection_cell(speaker_data)
% implements to get dentification result, including true name, estimated name
% and the frame length of test files
%% Author info
% Wangbo Zheng and Hao Wang
% University of Stuttgart

%% 
% Vectorize the speaker info
 speaker_data_vector = [speaker_data(1:11,1);speaker_data(1:26,2);
                       speaker_data(1:26,3);speaker_data(1:32,4);
                       speaker_data(1:28,5);speaker_data(1:11,6);
                       speaker_data(1:23,7);speaker_data(1:11,8)];
% initialize the identification result, including true name, estimated name
% and the frame length of test files
 detection_info=cell(168,3);
 
 for i = 1:168
     
     b_unknown = speaker_data_vector{i}.b_test;
     true_name = speaker_data_vector{i}.name;
     num_test_frame = speaker_data_vector{i}.lengthOfTestFrame;
     T=size(b_unknown,1);
     P_adapted=zeros(168,T);
     
% 168 speakers in folds to be validated
     for j=1:168
         weighted_pdf=zeros(T,T); 
%   49 GMM adapted models to be sumed up to get the maximal likelihood   
         for k=1:49
%              vector b minus vector mean
             Minus_interm = bsxfun(@minus,b_unknown,speaker_data_vector{j}.means_adapted(k,:));
             P_adapted_interm = speaker_data_vector{j}.weight_adapted(k)*(1/sqrt(double((2*pi)^15)*det(speaker_data_vector{j}.cov_adapted((k-1)*15+1:k*15,:))))* ...
             exp(-0.5*Minus_interm*(eye(15,15)/speaker_data_vector{j}.cov_adapted((k-1)*15+1:k*15,:))*Minus_interm');
             weighted_pdf=P_adapted_interm+weighted_pdf;        
         end;
         P_adapted(j,:)=diag(weighted_pdf)';
     end;
     
%      maximal log likelihood
         log_likeli_pdf = sum(log(P_adapted),2);
         [ma,speaker_id]=max(log_likeli_pdf); % index of the max value
         estimate_name = speaker_data_vector{speaker_id}.name;
 
         detection_info(i,:) = {true_name estimate_name num_test_frame};
         
 end;