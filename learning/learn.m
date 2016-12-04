% nX = length(X);
% nU = length(U);
% 
% Phi = tmprodvect(X,MFcores,BFtypeV);
% theta = zeros(nX,nU);
% 
% % Q = Phi*theta forall x
% 
% % faked next state 
% xnext(1) = rand*(max(MFcores{1}) - min(MFcores{1})) + min(MFcores{1});
% xnext(2) = rand*(max(MFcores{2}) - min(MFcores{2})) + min(MFcores{2});
% 
% 
% % reward 100xN where N is a number of actions
% 
% PhiState = tmprodvect(xnext,MFcores,BFtypeV);
% 
% %reshape(reward + PhiState*theta


nU = 5; %number of actions
xr = 99; %desired state
rate = 0.1; %MUST be a function, probably Boltzman temperature

MFcores = {1:1:100};
theta = zeros(100,nU);
X = [1:1:100]';
Phi = tmprodvect(X,MFcores,BFtypeV);


for k=1:1000
    % x_k is the state of the mavg_beta BEFORE stimulation
    % now we should wait at least 15 s to obtain x_k+1 and reward r_k+1 for
    % that
    theta_new = theta + rate * (r_k+1 + gamma*tmprodvect(x_k,MFcores,BFtypeV)*theta - theta);
end