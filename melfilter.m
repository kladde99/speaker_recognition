function [Filter,MelFrequencyVector] = melfilter
%% Create a mel frequency filterbank

%% Author info
% Wangbo Zheng and Hao Wang
% University of Stuttgart

%%
% the form of the filter bank is triangle
if nargin<3 || isempty(hWindow), hWindow = @triang; end


% basic info of frequency of the audio 
fs=16000; K=320;
f_min = 0;          % filter coefficients start at this frequency (Hz)
f_max = fs/2;    % filter coefficients end at this frequency (Hz)
% 320 sample values eaqually distributed over 8000 HZ
FrequencyVector= linspace( f_min, f_max, K ); 

N=22; % number of the mel filter banks

for j= 1: K  
    
   if    FrequencyVector(j)>1000
         MelFrequencyVector(j) = 2595*log10(1+FrequencyVector(j)/700); % Convert to mel scale
   else 
         MelFrequencyVector(j)= FrequencyVector(j);  % linear area from 0HZ to 1000HZ
   end
   
end

MaxF = max(MelFrequencyVector);                  
MinF = min(MelFrequencyVector);                 
MelBinWidth = (MaxF-MinF)/(N+1);                
Filter = zeros([N numel(MelFrequencyVector)]);  

%% Mel filter bank
for i = 1:N
    iFilter = find(MelFrequencyVector>=((i-1)*MelBinWidth+MinF) & ...
                    MelFrequencyVector<=((i+1)*MelBinWidth+MinF));
    Filter(i,iFilter) = hWindow(numel(iFilter)); % Triangle window
end

% normalization of mel bank filter
max_filter =repmat( max(Filter,[],2),1,320);  
    Filter = Filter./max_filter;
    
end
