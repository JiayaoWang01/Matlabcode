function [ xc,yc ] = Searchcentre( xr,yr )
%% Delaunay-Triangulierung
xr=xr';
yr=yr';
dt=DelaunayTri(xr,yr);

%% konvexe Hülle suchen
t=convexHull(dt);
x=xr(t);
y=yr(t);

%% Kreis Fitting
n=length(x);
xx=x.*x;
yy=y.*y;
xy=x.*y;
A=[sum(x) sum(y) n; sum(xy) sum(yy) sum(y); sum(xx) sum(xy) sum(x)];
B=[-sum(xx+yy);-sum(xx.*y+yy.*y);-sum(xx.*x+xy.*y)];

%% Kreismittelpunkt bestimmen
a=A\B;
xc=-.5*a(1);
yc=-.5*a(2);
end

