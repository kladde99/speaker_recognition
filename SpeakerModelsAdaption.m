function [weight_adapted,means_adapted,cov_adapted]=SpeakerModelsAdaption(b_training)

% implements to get a speaker model from the UBM.
%% Author info
% Wangbo Zheng and Hao Wang
% University of Stuttgart

%% GMM-UBM speaker model
load('UBM_GMMNaive_MFCC_Spectrum0to8000Hz.mat');
T=size(b_training,1);
P_ubm=zeros(1,T); %GMM-UBM
K_mode_pdf=zeros(T,49); %initial value p(b|mu_ubm,k):the k-th Gaussian mode 

for k=1:49
    for t=1:T
        K_mode_pdf(t,k) = (1/sqrt(double((2*pi)^15)*prod(var(k,:))))* ...
        exp(-0.5*((b_training(t,:)-means(k,:))*(eye(15,15)/diag(var(k,:)))*(b_training(t,:)-means(k,:))'));
        weighted_pdf=weights(k)*K_mode_pdf(t,k);
        P_ubm(t)=P_ubm(t)+weighted_pdf;
    end;
end;

%% speaker models adaption

% weight_UBM*p(b|mean,Cov)
temp=repmat(weights,T,1).*K_mode_pdf;

% a posteriori probability of bt belonging to the k-th mode of the UBM-GMM
% use bsxfun function to vectorize the data processing in order to 
% avoid loop
posteriori_Kmode_pdf=bsxfun(@rdivide,temp,P_ubm'); 

sum_Kmode_ap=sum(posteriori_Kmode_pdf,1);% sum of p(k|bt) 1<t<T

temp1=b_training'*posteriori_Kmode_pdf;
means_k=bsxfun(@rdivide,temp1',sum_Kmode_ap');% mean of the k-th Gaussian mode of this speaker

% initial value:containing the diagonal elements of the covariance matrices
% of the k-th Gaussian mode of this speaker
Cov_k=zeros(49*15,15);

for k=1:49
    interm_2=bsxfun(@times,b_training',posteriori_Kmode_pdf(:,k)');
    Cov_k((k-1)*15+1:k*15,:)=interm_2*b_training/sum_Kmode_ap(k)-means_k(k,:)'*means_k(k,:);
end;   

weight_cor=sum_Kmode_ap/T; %the corresponding weight of the k-th mode 
gamma_rf=0.001;  % relevance factor to be chosen

alpha=zeros(1,49);
for k=1:49
    alpha(k)=sum_Kmode_ap(k)/(gamma_rf+sum_Kmode_ap(k));
end;

% adapted parameters
weight_adapted=zeros(1,49);
means_adapted=zeros(49,15);

% covariance to be stored sequently in the direction of rows
cov_adapted=zeros(49*15,15);

for k=1:49
    means_adapted(k,:)=alpha(k)* means_k(k,:)+(1-alpha(k))* means(k,:);
    cov_adapted((k-1)*15+1:k*15,:)=alpha(k)* Cov_k((k-1)*15+1:k*15,:)+(1-alpha(k))*diag(var(k,:));
    weight_adapted(k)=alpha(k)*weight_cor(k)+(1-alpha(k))*weights(k);
end
