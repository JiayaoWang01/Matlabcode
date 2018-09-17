function dx=BGL2(t,x)
w=45;               % Schleifrichtung
m=0.018;            % Masse der Scheibe
M=[m,0;0,m];        % Massematrix
g=9.8;N=m*g;        % Normalkraft
u1=0.55;u2=0.506;   % Reibwert
p1=1.04;p2=0.666;   % p
S=[cos(pi*w/180),sin(pi*w/180);-sin(pi*w/180),cos(pi*w/180)]; % Drehmatrix
K=diag([p1^4*N^2/(4*u1^2) p2^4*N^2/(4*u2^2)]);
U=diag([2/(p1*N)^2 2/(p2*N)^2]);

dx=zeros(4,1);
dx(1:2)=x(3:4);
dx(3:4)=-(M*S)^-1/sqrt((S*x(3:4))'*K*(S*x(3:4)))*U^-1*S*x(3:4);
end