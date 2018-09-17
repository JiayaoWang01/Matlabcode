function [ a ] = Drehungwinkel(x1,y1,x2,y2)
x1=-x1;x2=-x2;
a=atan((y1-y2)/(x1-x2));
a=round(rad2deg(a));
end

