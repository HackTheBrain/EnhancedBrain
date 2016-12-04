function dof = tmprod(x,a)
% for a single point x (a vector)

dof = tmpgrade(x(end),a{end})';
for i = length(x)-1 : -1 : 1,
   dof = dof*tmpgrade(x(i),a{i});
   dof = dof(:);
end;   
