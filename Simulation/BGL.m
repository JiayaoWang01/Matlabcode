function dx=BGL(t,x)
a=45;              % Schleifrichtung
m=0.018;           % Masse der Scheibe
M=[m,0;0,m];       % Massematrix
g=9.8;N=m*g;       % Normalkraft
u1=0.55;u2=0.506;  %Reibwert
K=[N^2*u1^2/4,0;0,N^2*u2^2/4];
U=[2/(N^2*u1^2),0;0,2/(N^2*u2^2)];
S=[cos(pi*a/180),sin(pi*a/180);-sin(pi*a/180),cos(pi*a/180)];   %Drehmatrix
dx=zeros(4,1);
dx(1:2)=x(3:4);
dx(3:4)=-(M*S)^-1/sqrt((S*x(3:4))'*K*(S*x(3:4)))*U^-1*S*x(3:4);
end

