% pendulum with dicrete action and continuous space
% uses V-iteration

clear all
figure(1); clf; figure(2); clf;
% use globals to keep the notation as close as possible to the paper
global MFcores rho_option xr Ts ur wrapflag Qdiag Pdiag gamma

xr = [0; 0];            % desired state
Umax = 10;              % maximum control action
wrapflag = 1;           % set to 1 to wrap alpha
BFtypeV = 1;            % V-function basis function type (1 - triangular, 2 - exponential, 3 - parabolic, 4 - polynomial)
BFtypeP = 1;            % policy basis function type (1 - triangular, 2 - exponential, 3 - parabolic, 4 - polynomial)
rho_option = 2;         % switch different reward functions(1 - quadratic, 2 - abs, 3 - sqrt)
gamma = 0.9999;        % discount factor
Qdiag = [5 1];          % diagonal of the reward Q matrix
Pdiag = 1;              % diagonal of the reward P matrix
Ts = 0.01;              % sampling period
plotflag = 0;           % plotting during value-iteration
xdom = [-1.5*pi 1.5*pi;-40 40]; % state-space domain limits

% uncomment the below line for the pendulum swingup settings
xr = [0; 0]; Umax = 2; wrapflag = 1; xdom = [-pi-0.3 pi+0.3;-30 30]; Ts = 0.01;

n1 = 21;                % number of BF for x(1)
n2 = 21;                % number of BF for x(2)
nr = 1;                 % refine data nr times for plotting
maxiter = 5000;          % number of VI (PI) iterations
epstheta = 0.00001;       % stopping criterion threshold (0.01 seems exaggerated)
%su = 0.1;               % fine step for u around ur
su = 0.05;               % fine step for u around ur

ur = fminbnd(@(u) sum((xr-f(xr',u)').^2), -Umax, Umax); 	% control action corresponding to desired state
if ur < su/100, ur = 0; end;
U = [-Umax:1:Umax fliplr(ur-su:-su:ur-.5) ur:su:ur+.5]';
U = sort(unique(U));    % keep unique values of control actions and sort them
% U = [-Umax:1:Umax]';

U = [-2 -1 0 1 2]';
nU = size(U,1);         % number of action samples

s1 = diff(xdom(1,:))/(n1-1);    % step for basis function cores in x(1)
s2 = diff(xdom(2,:))/(n2-1);    % step for basis function cores in x(2)
MFcores = {[fliplr(xr(1)-s1:-s1:xdom(1,1)) xr(1):s1:xdom(1,2)]; ...
    [fliplr(xr(2)-s2:-s2:xdom(2,1)) xr(2):s2:xdom(2,2)]};   % basis function cores
% K = length(MFcores{1})*length(MFcores{2});                  % total number of basis functions

[x1,x2] = ndgrid(MFcores{1},MFcores{2});
X = [x1(:) x2(:)];      % data set to optimize on
nX = size(X,1);         % number of state samples

% fine grid for plotting
xRefined = [fliplr(xr(1)-s1/nr:-s1/nr:min(MFcores{1})) xr(1):s1/nr:max(MFcores{1})];
yRefined = [fliplr(xr(2)-s2/nr:-s2/nr:min(MFcores{2})) xr(2):s2/nr:max(MFcores{2})];

[xx1,xx2] = ndgrid([fliplr(xr(1)-s1/nr:-s1/nr:min(MFcores{1})) xr(1):s1/nr:max(MFcores{1})], ...
                    [fliplr(xr(2)-s2/nr:-s2/nr:min(MFcores{2})) xr(2):s2/nr:max(MFcores{2})]);
XX = [xx1(:) xx2(:)];   % data set to generate plots

% plotmfs
% return

% compose filename for saving data
filename = ['Ref=' num2str(round(180*xr(1)/pi)) '_Umax=' num2str(Umax) '_Qvel=' num2str(Qdiag(2)) '_Grid=' num2str(n1) '_gamma=' num2str(gamma)];
filename = strrep(filename, '.', ',');  % replace dots by commas
switch rho_option
    case 1, filename = [filename '_quad'];
    case 2, filename = [filename '_abs'];
    case 3, filename = [filename '_sqrt'];
end;
switch BFtypeV
    case 1, filename = [filename '_lin'];
    case 2, filename = [filename '_exp'];
    case 3, filename = [filename '_par'];
end;

fprintf('Precomputing state transitions ...\n');
[Xnext,Urep] = f(X,U);                          % compute next state for all actions (stacked in Xnext)
r = rho(Xnext,Urep);                            % pre-compute rho over all actions
%r = rho(repmat(X,length(U),1),Urep);


PhiV = tmprodvect(X,MFcores,BFtypeV);           % basis function values for all current states
PhinextV = tmprodvect(Xnext,MFcores,BFtypeV);   % basis function values for all future states
PhixxV = tmprodvect(XX,MFcores,BFtypeV);        % evaluate BF for visualization data
PhiP = tmprodvect(X,MFcores,BFtypeP);           % basis function values for all current states
PhixxP = tmprodvect(XX,MFcores,BFtypeP);        % evaluate BF for visualization data
% Phi = sparse(Phi);

KV = size(PhiV,2);                      % total number of basis functions
theta = zeros(KV,maxiter);              % value function parameters
KP = size(PhiP,2);                      % total number of basis functions
p = zeros(KP,maxiter);                  % policy parameters
Vrefined = xx1;
P = Vrefined;

fprintf('iteration: '); 
for j = 2 : maxiter                     % VI / PI iterations
    fprintf('%02d,', j-1)
    if rem(j-1,30) == 0, fprintf('\niteration: '); end;
    if BFtypeV == 2 || BFtypeV == 4         % prepare for least-squares estimate
        [theta_target,maxUind] = max(reshape(r + gamma*PhinextV*theta(:,j-1),nX,nU),[],2);   % Bellman equation RHS
        p_target = U(maxUind);              % target for the LS estimate of optimal action
    else
        [theta(:,j),maxUind] = max(reshape(r + gamma*PhinextV*theta(:,j-1),nX,nU),[],2);     % Bellman equation RHS
        p(:,j) = U(maxUind);                % optimal action
    end;
    if BFtypeV == 2 || BFtypeV == 4         % least-squares estimate
    %     indphi = find(any(phi > 0));        % find indices of data with at least one nonzero BF value
    %     [~,indphi] = rref(phi,1e-3);        % find indices of linearly independent columns
        indphi = 1 : size(PhiV,2);          % use all basis funnctions
        theta(:,j) = theta(:,j-1);          % parameters from previous iteration as default
        p(:,j) = p(:,j-1);                  % parameters from previous iteration as default
        theta(indphi,j) = PhiV(:,indphi) \ theta_target;    % LS estimate of V-function parameters
        p(:,j) = PhiP \ p_target;           % LS estimate of policy parameters
    end;
    if plotflag
        V(:) = PhixxV*theta(:,j);           % calculate V function
        P(:) = PhixxP*p(:,j);               % calculate policy
        figure(1); mesh(xx1,xx2,V); 
        figure(2); contour(xx1,xx2,V,50);
        drawnow;
    end;
    if max(abs(theta(:,j) - theta(:,j-1))) < epstheta, break; end;   % convergence check
end;
fprintf('\n'); 
theta = theta(:,1:j);                   % cut off unused parameter storage
p = p(:,1:j);                           % cut off unused parameter storage

Vrefined(:) = PhixxV*theta(:,end);             % calculate final V function
P(:) = PhixxP*p(:,end);                 % calculate final policy

figure(3); clf; plot(theta');           % plot value function parameter convergence

V = x1;
V(:) = PhiV*theta(:,end);

save(filename);
% plotV_movie;