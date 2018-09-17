function [xmitte,ymitte] = TrackingRedPoint(frames,End,SearchSize,R,G,B)
global r
%% Ginput im ersrten Frame
r=1;
Img=frames(:,:,:,r);
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
    [xmitte(r),ymitte(r)]=Searchcentre(xr,yr);
%Rekursion
for r=2:End
    Img=frames(:,:,:,r);
    clear xr yr a
    x=round(xmitte(r-1));
    y=round(ymitte(r-1));
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
    [xmitte(r),ymitte(r)]=Searchcentre(xr,yr);
end
end

