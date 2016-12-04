addpath('./stimuli')
%==========================================================================
global maximalExecutionTime useStimuli randNum%(s)

nU = 9; %number of actions
xr = 99; %desired state - 99% focused
timeBeforeExecution = 15; %(s)
time = 0;




numOfStimulations = 0;
xk = 0.031;
xnext = 0;
uk = 1;
rnext = 0;

learningRate = 1;
eRate = @(k) 1/k;
gamma = 0.95; %discount factor 
BFtypeV = 1;

MFcores = {0:0.05:1};
theta = -0.3*ones(21,nU);
theta_new = theta;
X = [0:0.05:1]';
Phi = tmprodvect(X,MFcores,BFtypeV);
%==========================================================================


s = tcpip('127.0.0.1',7676);
fopen(s);


fs = 250;
totalTime = 0;
tic;
xLength = 1;

buffSize = 750; %3(s)
cicrBuff = zeros(1,buffSize);
cicrBuffBeta = zeros(1,100);
betaAveragePlot = zeros(1,100);
betaAverage = zeros(1,100);
subplot(311); h1 = plot(cicrBuff); title('Raw EEG'); ylabel('mV');
subplot(312); h2 = plot(cicrBuffBeta); title('Beta waves ratio'); ylabel('%');
subplot(313); h3 = plot(betaAveragePlot); title('Long-term concentration level'); ylabel('%');

h1.YDataSource = 'cicrBuff';
h2.YDataSource = 'cicrBuffBeta';
h3.YDataSource = 'betaAveragePlot';


betaStorage = [];
focusStorage = [];
betaIndexToStore = 1;
focusIndexToStore = 1;
lastExecutionTime =0;

betaStorage = zeros(1,225000);
focusStorage = zeros(1,225000);


figure(1);
tic;

counter = 1;
while time<maximalExecutionTime
    
    RawPackage = fread(s);
    signal = streamToDouble(RawPackage);
    %processing here
    
    % plot(xLength-length(signal):xLength-1, signal, 'b'); hold on

    
    if xLength<buffSize
        cicrBuff(xLength:xLength + length(signal)-1) = signal;
    else
        cicrBuff = [cicrBuff(length(signal)+1:end) signal];
    end
    
    rel_beta = bandpower(cicrBuff,fs,[13,30])/bandpower(cicrBuff,fs,[0.1 50]);
    
    if xLength<buffSize
        cicrBuffBeta(end) = rel_beta*100;
    else
        cicrBuffBeta = [cicrBuffBeta(2:end) rel_beta*100];
    end
    
    refreshdata(h1);
    refreshdata(h2);
    refreshdata(h3);
    drawnow;
    
    
    if xLength>=buffSize
        mavg = tsmovavg(cicrBuffBeta,'s',50);
        betaAveragePlot = mavg;
        betaAverage = mavg/100;
        xk = betaAverage(end);
        
       
        time = toc;
        
                if time-lastExecutionTime>=timeBeforeExecution & useStimuli
                    lastExecutionTime = time;
                    numOfStimulations = numOfStimulations+1;
                    
                    %here we can measure x_k+1 and r_k+1
                    xnext = betaAverage(end);
                    rnext = rho(xk,xnext);
                    
                    disp(['New stimulation is available: ', num2str(time), ' elapsed']); %tic;
                    %here we can update learning algorithm
                    PhiCurrentState = tmprodvect(xk,MFcores,BFtypeV);
                    PhiNextState = tmprodvect(xnext,MFcores,BFtypeV);
                    actuatedX = PhiCurrentState~=0;
                    
                    %that's the essence of learning algorithm
                    theta(actuatedX,uk) =  PhiCurrentState(actuatedX)' .* (theta(actuatedX,uk) + ...
                    learningRate * (rnext + gamma * PhiNextState*theta(:,uk) - PhiCurrentState*theta(:,uk))); 

                    %xk

                    %here we can select next action and store it  
                    xk = betaAverage(end);

                    %TODO: select and apply new action     
                    if rand()<eRate(numOfStimulations)
                    %exploitation
                        [~,uk] = max(PhiCurrentState*theta);
                    else
                    %exploration
                        uk = randi(nU-1)+1;
                    end
                    invokeStimulus(uk);
                end
                
                
          
    
%    beta
    %here we should store data - beta waves and focus level
    betaDataToStore = rel_beta;
    focusDataToStore = betaAverage(end);
   
    betaStorage(betaIndexToStore:betaIndexToStore+length(betaDataToStore)) = betaDataToStore;
    betaIndexToStore = betaIndexToStore+length(betaDataToStore);
    
    
    
    focusStorage(focusIndexToStore:focusIndexToStore+length(focusDataToStore)-1) = focusDataToStore;
    focusIndexToStore = focusIndexToStore+length(focusDataToStore);
    
    
    end    
    xLength = xLength + length(signal);
    
   
    
    qqq=1;
    
end


%shrink and save data 
betaStorage = betaStorage(1:betaIndexToStore-1);
focusStorage = focusStorage(1:focusIndexToStore-1);


if useStimuli
    save(strcat('dataSimulation_',num2str(randNum),'_stimuli'));
else
    save(strcat('dataSimulation_',num2str(randNum),'_empty'));
end