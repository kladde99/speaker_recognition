function [b, lengthOfFrame]= speaker_feature_matrix(speaker_id,fold_id,speaker_file,speaker_name)
% implements to get the feature vectors and length of the frames.
%% Author info
% Wangbo Zheng and Hao Wang
% University of Stuttgart

%% Reference
% matlab DIRR function written by Maximilien Chaumon on www.mathworks.com
% to find files recursively filtering name, date or bytes 

%% Frame segmentation

run 'extract_files';
Y=[]; % all the output values of individual filter are sequently stored here
lengthOfFrame=zeros(1,10);
for file_id = 1:10
    
%  to read the audio files in each subset seperately   
  file_name= speaker_file{speaker_id,fold_id}{file_id,1};
  speaker_name_path=speaker_name{1,fold_id}{speaker_id,1};
  fold_name=['dr',num2str(fold_id)];
  file_path=strcat('/Users/Ben/Documents/MATLAB/forStudents Kopie/timit/test/',fold_name,'/',speaker_name_path,'/', file_name);
  audio_file= audioread(file_path);
  
%   to segment the audio material into frames, K is the number of frames
  k=floor((size(audio_file,1)-320)/160)+1;

     for i = 0:k-1
         au_frame(:,i+1) = audio_file(160*i+1:160*i+320); 
     end

%% ----- voice activity detection ------%
% to seperate voiced from unvoiced frames

  power_signal = sum ((au_frame.^2),1)/ 320;
  power_noise =  sum(power_signal(1:9))/9 ; 
  gamma = 100;  % gamma to be determined intuitively, compared with other values
  index = power_signal(:) >gamma * power_noise;
  frame_voiced = au_frame(:, index);  


%% --------- voice feature extraction --------%

%   hamming window is applied to avoid leakage effects
  w =repmat(hamming(320),1,size(frame_voiced,2));

  frame_voiced_w = frame_voiced.*w ;
  
% Fourier Transformation to get the frequency spectrum
  frame_freq = abs(fft(frame_voiced_w));
  
%   Mel filter Bank is applied to convert the spectrum to Mel scale
%   spectrum
  [Filter,MelFrequencyVector] = melfilter;
  
  Y_interm=Filter* frame_freq;
  
% all the output values of individual filter are sequently stored here
  lengthOfFrame(file_id)=size(Y_interm,2);
  Y=[Y Y_interm];
  
end;  

%% compute the feature vector of the frames from mel filterbank output using DCT

b=zeros(size(Y,2),15);  
                
for j=1:size(Y,2)                
                
      for n=1:15
          for m=1:22
             interm = log10(Y(m,j))*cos(pi*n*(m-0.5)/22);
              b(j,n) = b(j,n)+interm;
          end;
      end;
end
