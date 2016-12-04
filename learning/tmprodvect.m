function dof1 = tmprodvect(x,mfs,BFtype)
% Calculate Cartesian product of membership degrees
% for a set of points x (x is a matrix)

if BFtype == 4,                                     % polynomial
    dof1 = polyregr(x);                             % basis function values for all current states (polynomial)
else
    n = size(x,2);                                  % aux var
    for j = n : -1 : 1,
        Mu{n-j+1} = tmpgrade(x(:,j),mfs{j},BFtype); % pre-computer membership degrees
    end;
    
    for i = size(x,1) : -1 : 1,
        dof = Mu{end}(i,:)';
        for j = n-1 : -1 : 1,
            dof = dof*Mu{j}(i,:);                   % calculate product
            dof = dof(:);                           % flatten in an array
        end;
        dof1(i,:) = dof';
    end;
end;