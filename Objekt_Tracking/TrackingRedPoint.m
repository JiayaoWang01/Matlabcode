function [xmitte,ymitte] = TrackingRedPoint(frames,End,SearchSize,R,G,B)
global k
%% Ginput im ersrten Frame
k=1;
Img=frames(:,:,:,k);
figure(1)
imshow(Img)
title('Bitte klicken roten Punkt');
[x,y]=ginput(1);
close
x=round(x);
y=round(y);
a=1;
xr=[];
yr=[];

%% rote Farbe erkennen
for i=y-SearchSize:y+SearchSize
        for j=x-SearchSize:x+SearchSize
            if((Img(i,j,1)>R&Img(i,j,2)<G&Img(i,j,3)<B)==1)
            xr(a)=j;
            yr(a)=i;
            a=a+1;
            end
        end
end
    [xmitte(1),ymitte(1)]=Searchcentre(xr,yr);
%Rekursion
for k=2:End
    Img=frames(:,:,:,k);
    clear xr yr a
    x=round(xmitte(k-1));
    y=round(ymitte(k-1));
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
    [xmitte(k),ymitte(k)]=Searchcentre(xr,yr);
end
end

