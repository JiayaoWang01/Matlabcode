function [ w ] = schRichtung( Img )
SearchSize=20;
R=60;G=150;B=150; %RGB-Wert der gezeichneten Punkte
%% Bild ziegen
figure
imshow(Img)
title('Winkel der Schleifenrichtun bestimmen')
%% Farbe erkennen
[x,y]=ginput(1);
x=round(x);
y=round(y);
a=1;
xr=[];
yr=[];
for i=y-SearchSize:y+SearchSize
        for j=x-SearchSize:x+SearchSize
            if((Img(i,j,1)>R&Img(i,j,2)<G&Img(i,j,3)<B)==1)
            xr(a)=j;
            yr(a)=i;
            a=a+1;
            end
        end
end
[x1,y1]=Searchcentre( xr,yr );
clear x y xr yr
[x,y]=ginput(1);
x=round(x);
y=round(y);
a=1;
xr=[];
yr=[];
for i=y-SearchSize:y+SearchSize
        for j=x-SearchSize:x+SearchSize
            if((Img(i,j,1)>R&Img(i,j,2)<G&Img(i,j,3)<B)==1)
            xr(a)=j;
            yr(a)=i;
            a=a+1;
            end
        end
end
[x2,y2]=Searchcentre( xr,yr );
%% Winkel rechnen
x1=-x1; x2=-x2;
w=atan((y1-y2)/(x1-x2));
w=round(rad2deg(w));
close
end

